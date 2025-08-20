//
//  CGDKNetworking.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import Foundation
import Combine

// MARK: - HTTP Method
public enum CGDKHTTPMethod: String, CaseIterable {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

// MARK: - Network Errors
public enum CGDKNetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case httpError(Int, String?)
    case networkUnavailable
    case timeout
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .httpError(let code, let message):
            return "HTTP Error \(code): \(message ?? "Unknown error")"
        case .networkUnavailable:
            return "Network unavailable"
        case .timeout:
            return "Request timeout"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

// MARK: - API Request Protocol
public protocol CGDKAPIRequest {
    associatedtype Response: Codable
    
    var baseURL: String { get }
    var path: String { get }
    var method: CGDKHTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
    var timeout: TimeInterval { get }
}

// MARK: - Default Implementation
public extension CGDKAPIRequest {
    var baseURL: String { "" }
    var headers: [String: String] { [:] }
    var parameters: [String: Any]? { nil }
    var body: Data? { nil }
    var timeout: TimeInterval { 30.0 }
    
    var url: URL? {
        guard var components = URLComponents(string: baseURL + path) else {
            return nil
        }
        
        if let parameters = parameters {
            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        return components.url
    }
}

// MARK: - HTTP Client
public final class CGDKHTTPClient: ObservableObject {
    @MainActor
    public static let shared = CGDKHTTPClient()
    
    private let session: URLSession
    private var cancellables = Set<AnyCancellable>()
    
    public init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    public func send<T: CGDKAPIRequest>(_ request: T) async throws -> T.Response {
        guard let url = request.url else {
            throw CGDKNetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = request.timeout
        
        // Set headers
        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set body
        if let body = request.body {
            urlRequest.httpBody = body
        }
        
        CGDKLogDebug("Making \(request.method.rawValue) request to: \(url)")
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw CGDKNetworkError.unknown(URLError(.badServerResponse))
            }
            
            CGDKLogDebug("Received response with status code: \(httpResponse.statusCode)")
            
            // Check for HTTP errors
            if httpResponse.statusCode >= 400 {
                let errorMessage = String(data: data, encoding: .utf8)
                throw CGDKNetworkError.httpError(httpResponse.statusCode, errorMessage)
            }
            
            // Decode response
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedResponse = try decoder.decode(T.Response.self, from: data)
                return decodedResponse
            } catch {
                throw CGDKNetworkError.decodingError(error)
            }
            
        } catch let error as CGDKNetworkError {
            throw error
        } catch {
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                throw CGDKNetworkError.networkUnavailable
            } else if (error as NSError).code == NSURLErrorTimedOut {
                throw CGDKNetworkError.timeout
            } else {
                throw CGDKNetworkError.unknown(error)
            }
        }
    }
    
    public func sendPublisher<T: CGDKAPIRequest>(_ request: T) -> AnyPublisher<T.Response, CGDKNetworkError> {
        guard let url = request.url else {
            return Fail(error: CGDKNetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = request.timeout
        
        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body = request.body {
            urlRequest.httpBody = body
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.Response.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return CGDKNetworkError.decodingError(error)
                } else {
                    return CGDKNetworkError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - JSON Request Helper
public struct CGDKJSONRequest<Response: Codable>: CGDKAPIRequest {
    public let baseURL: String
    public let path: String
    public let method: CGDKHTTPMethod
    public let headers: [String: String]
    public let parameters: [String: Any]?
    public let body: Data?
    public let timeout: TimeInterval
    
    public init<Body: Codable>(
        baseURL: String,
        path: String,
        method: CGDKHTTPMethod,
        headers: [String: String] = ["Content-Type": "application/json"],
        parameters: [String: Any]? = nil,
        body: Body? = nil,
        timeout: TimeInterval = 30.0
    ) throws {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.timeout = timeout
        
        if let body = body {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                self.body = try encoder.encode(body)
            } catch {
                throw CGDKNetworkError.encodingError(error)
            }
        } else {
            self.body = nil
        }
    }
}

// MARK: - API Service Protocol
public protocol CGDKAPIService {
    var baseURL: String { get }
    var defaultHeaders: [String: String] { get }
    var client: CGDKHTTPClient { get }
}

public extension CGDKAPIService {
    var defaultHeaders: [String: String] {
        ["Content-Type": "application/json"]
    }
    
    var client: CGDKHTTPClient {
        // Return a new instance instead of shared to avoid main actor issues
        CGDKHTTPClient(configuration: .default)
    }
}

// MARK: - Response Wrapper
public struct CGDKAPIResponse<T: Codable>: Codable {
    public let data: T?
    public let message: String?
    public let success: Bool
    public let errors: [String]?
    
    public init(data: T?, message: String? = nil, success: Bool = true, errors: [String]? = nil) {
        self.data = data
        self.message = message
        self.success = success
        self.errors = errors
    }
}

// MARK: - Pagination Support
public struct CGDKPaginatedResponse<T: Codable>: Codable {
    public let data: [T]
    public let pagination: CGDKPagination
    
    public init(data: [T], pagination: CGDKPagination) {
        self.data = data
        self.pagination = pagination
    }
}

public struct CGDKPagination: Codable {
    public let currentPage: Int
    public let totalPages: Int
    public let totalItems: Int
    public let itemsPerPage: Int
    public let hasNext: Bool
    public let hasPrevious: Bool
    
    public init(
        currentPage: Int,
        totalPages: Int,
        totalItems: Int,
        itemsPerPage: Int,
        hasNext: Bool,
        hasPrevious: Bool
    ) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.totalItems = totalItems
        self.itemsPerPage = itemsPerPage
        self.hasNext = hasNext
        self.hasPrevious = hasPrevious
    }
}

// MARK: - Network Monitor
@MainActor
public final class CGDKNetworkMonitor: ObservableObject {
    public static let shared = CGDKNetworkMonitor()
    
    @Published public private(set) var isConnected = true
    @Published public private(set) var connectionType: ConnectionType = .unknown
    
    public enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        // Monitor network connectivity
        // This is a simplified implementation
        // In a real app, you might want to use Network framework
    }
    
    public func startMonitoring() {
        // Start network monitoring
        CGDKLogInfo("Network monitoring started")
    }
    
    public func stopMonitoring() {
        // Stop network monitoring
        CGDKLogInfo("Network monitoring stopped")
    }
}

// MARK: - Image Loading Helper
@MainActor
public final class CGDKImageLoader: ObservableObject {
    public static let shared = CGDKImageLoader()
    
    private let cache = NSCache<NSString, NSData>()
    
    private init() {
        cache.countLimit = 100
    }
    
    public func loadImage(from url: URL) async throws -> Data {
        let cacheKey = NSString(string: url.absoluteString)
        
        // Check cache first
        if let cachedData = cache.object(forKey: cacheKey) {
            return cachedData as Data
        }
        
        // Download image
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Cache the result
        cache.setObject(NSData(data: data), forKey: cacheKey)
        
        return data
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
}

// MARK: - Request Builder
public final class CGDKRequestBuilder {
    private var baseURL: String = ""
    private var path: String = ""
    private var method: CGDKHTTPMethod = .GET
    private var headers: [String: String] = [:]
    private var parameters: [String: Any] = [:]
    private var bodyData: Data?
    private var timeout: TimeInterval = 30.0
    
    public init() {}
    
    public func baseURL(_ url: String) -> Self {
        self.baseURL = url
        return self
    }
    
    public func path(_ path: String) -> Self {
        self.path = path
        return self
    }
    
    public func method(_ method: CGDKHTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    public func header(_ key: String, _ value: String) -> Self {
        self.headers[key] = value
        return self
    }
    
    public func headers(_ headers: [String: String]) -> Self {
        self.headers.merge(headers) { _, new in new }
        return self
    }
    
    public func parameter(_ key: String, _ value: Any) -> Self {
        self.parameters[key] = value
        return self
    }
    
    public func parameters(_ parameters: [String: Any]) -> Self {
        self.parameters.merge(parameters) { _, new in new }
        return self
    }
    
    public func body<T: Codable>(_ body: T) throws -> Self {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.bodyData = try encoder.encode(body)
        return self
    }
    
    public func timeout(_ timeout: TimeInterval) -> Self {
        self.timeout = timeout
        return self
    }
    
    public func build<Response: Codable>() throws -> CGDKJSONRequest<Response> {
        return try CGDKJSONRequest<Response>(
            baseURL: baseURL,
            path: path,
            method: method,
            headers: headers,
            parameters: parameters.isEmpty ? nil : parameters,
            body: bodyData as? Response,
            timeout: timeout
        )
    }
}