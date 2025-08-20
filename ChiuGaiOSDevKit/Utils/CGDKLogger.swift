//
//  CGDKLogger.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import Foundation
import os.log

public enum CGDKLogLevel: Int, CaseIterable {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    
    var emoji: String {
        switch self {
        case .verbose: return "💬"
        case .debug: return "🐛"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        }
    }
    
    var osLogType: OSLogType {
        switch self {
        case .verbose, .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        }
    }
}

@MainActor
public final class CGDKLogger {
    public static let shared = CGDKLogger()
    
    private let osLog: OSLog
    public var minimumLevel: CGDKLogLevel = .debug
    public var isEnabled: Bool = true
    
    private init() {
        osLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "ChiuGaiOSDevKit", category: "CGDK")
    }
    
    public func log(_ level: CGDKLogLevel, 
                   _ message: String, 
                   file: String = #file, 
                   function: String = #function, 
                   line: Int = #line) {
        guard isEnabled && level.rawValue >= minimumLevel.rawValue else { return }
        
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "\(level.emoji) [\(fileName):\(line)] \(function) - \(message)"
        
        #if DEBUG
        print(logMessage)
        #endif
        
        os_log("%@", log: osLog, type: level.osLogType, logMessage)
    }
    
    public func verbose(_ message: String, 
                       file: String = #file, 
                       function: String = #function, 
                       line: Int = #line) {
        log(.verbose, message, file: file, function: function, line: line)
    }
    
    public func debug(_ message: String, 
                     file: String = #file, 
                     function: String = #function, 
                     line: Int = #line) {
        log(.debug, message, file: file, function: function, line: line)
    }
    
    public func info(_ message: String, 
                    file: String = #file, 
                    function: String = #function, 
                    line: Int = #line) {
        log(.info, message, file: file, function: function, line: line)
    }
    
    public func warning(_ message: String, 
                       file: String = #file, 
                       function: String = #function, 
                       line: Int = #line) {
        log(.warning, message, file: file, function: function, line: line)
    }
    
    public func error(_ message: String, 
                     file: String = #file, 
                     function: String = #function, 
                     line: Int = #line) {
        log(.error, message, file: file, function: function, line: line)
    }
}

// MARK: - Global logging functions for convenience
public func CGDKLogVerbose(_ message: String, 
                          file: String = #file, 
                          function: String = #function, 
                          line: Int = #line) {
    Task { @MainActor in
        CGDKLogger.shared.verbose(message, file: file, function: function, line: line)
    }
}

public func CGDKLogDebug(_ message: String, 
                        file: String = #file, 
                        function: String = #function, 
                        line: Int = #line) {
    Task { @MainActor in
        CGDKLogger.shared.debug(message, file: file, function: function, line: line)
    }
}

public func CGDKLogInfo(_ message: String, 
                       file: String = #file, 
                       function: String = #function, 
                       line: Int = #line) {
    Task { @MainActor in
        CGDKLogger.shared.info(message, file: file, function: function, line: line)
    }
}

public func CGDKLogWarning(_ message: String, 
                          file: String = #file, 
                          function: String = #function, 
                          line: Int = #line) {
    Task { @MainActor in
        CGDKLogger.shared.warning(message, file: file, function: function, line: line)
    }
}

public func CGDKLogError(_ message: String, 
                        file: String = #file, 
                        function: String = #function, 
                        line: Int = #line) {
    Task { @MainActor in
        CGDKLogger.shared.error(message, file: file, function: function, line: line)
    }
}