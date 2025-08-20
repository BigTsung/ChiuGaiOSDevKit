//
//  CGDKStorage.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import Foundation
import Security
import CoreData

// MARK: - UserDefaults Wrapper
@propertyWrapper
public struct CGDKUserDefault<T> {
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard
    
    public init(key: String, defaultValue: T, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
    
    public var wrappedValue: T {
        get {
            return container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
    
    public var projectedValue: CGDKUserDefault<T> {
        return self
    }
    
    public func remove() {
        container.removeObject(forKey: key)
    }
}

// MARK: - UserDefaults Manager
@MainActor
public final class CGDKUserDefaultsManager {
    public static let shared = CGDKUserDefaultsManager()
    
    private let container: UserDefaults
    
    public init(container: UserDefaults = .standard) {
        self.container = container
    }
    
    public func set<T>(_ value: T, forKey key: String) {
        container.set(value, forKey: key)
    }
    
    public func get<T>(_ type: T.Type, forKey key: String, defaultValue: T) -> T {
        return container.object(forKey: key) as? T ?? defaultValue
    }
    
    public func remove(forKey key: String) {
        container.removeObject(forKey: key)
    }
    
    public func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        container.removePersistentDomain(forName: domain)
    }
    
    public func exists(forKey key: String) -> Bool {
        return container.object(forKey: key) != nil
    }
}

// MARK: - Keychain Helper
public enum CGDKKeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)
}

public final class CGDKKeychain {
    public static let shared = CGDKKeychain()
    
    private init() {}
    
    public func save(_ data: Data, forKey key: String, accessibility: CFString = kSecAttrAccessibleWhenUnlocked) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: accessibility
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw CGDKKeychainError.unexpectedStatus(status)
        }
    }
    
    public func save(_ string: String, forKey key: String, accessibility: CFString = kSecAttrAccessibleWhenUnlocked) throws {
        guard let data = string.data(using: .utf8) else {
            throw CGDKKeychainError.invalidItemFormat
        }
        try save(data, forKey: key, accessibility: accessibility)
    }
    
    public func load(forKey key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw CGDKKeychainError.itemNotFound
            } else {
                throw CGDKKeychainError.unexpectedStatus(status)
            }
        }
        
        guard let data = item as? Data else {
            throw CGDKKeychainError.invalidItemFormat
        }
        
        return data
    }
    
    public func loadString(forKey key: String) throws -> String {
        let data = try load(forKey: key)
        guard let string = String(data: data, encoding: .utf8) else {
            throw CGDKKeychainError.invalidItemFormat
        }
        return string
    }
    
    public func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw CGDKKeychainError.unexpectedStatus(status)
        }
    }
    
    public func exists(forKey key: String) -> Bool {
        do {
            _ = try load(forKey: key)
            return true
        } catch {
            return false
        }
    }
    
    public func deleteAll() throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw CGDKKeychainError.unexpectedStatus(status)
        }
    }
}

// MARK: - Keychain Property Wrapper
@propertyWrapper
public struct CGDKKeychainStorage {
    private let key: String
    private let keychain: CGDKKeychain
    
    public init(key: String, keychain: CGDKKeychain = .shared) {
        self.key = key
        self.keychain = keychain
    }
    
    public var wrappedValue: String? {
        get {
            try? keychain.loadString(forKey: key)
        }
        set {
            if let newValue = newValue {
                try? keychain.save(newValue, forKey: key)
            } else {
                try? keychain.delete(forKey: key)
            }
        }
    }
    
    public var projectedValue: CGDKKeychainStorage {
        return self
    }
    
    public func remove() {
        try? keychain.delete(forKey: key)
    }
}

// MARK: - Core Data Helper
public protocol CGDKManagedObjectConvertible {
    associatedtype ManagedObject: NSManagedObject
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject
    static func fromManagedObject(_ managedObject: ManagedObject) -> Self
}

@MainActor
public final class CGDKCoreDataManager {
    public static let shared = CGDKCoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public init(modelName: String = "DataModel") {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                CGDKLogError("Core Data failed to load store: \(error)")
            }
        }
        
        context.automaticallyMergesChangesFromParent = true
    }
    
    public func save() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            CGDKLogInfo("Core Data context saved successfully")
        } catch {
            CGDKLogError("Failed to save Core Data context: \(error)")
        }
    }
    
    public func delete<T: NSManagedObject>(_ object: T) {
        context.delete(object)
        save()
    }
    
    public func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try context.fetch(request)
        } catch {
            CGDKLogError("Failed to fetch objects: \(error)")
            return []
        }
    }
    
    public func create<T: NSManagedObject>(_ type: T.Type) -> T {
        return T(context: context)
    }
    
    public func deleteAll<T: NSManagedObject>(_ type: T.Type) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            save()
        } catch {
            CGDKLogError("Failed to delete all objects of type \(type): \(error)")
        }
    }
}

// MARK: - Generic Storage Protocol
public protocol CGDKStorageProtocol {
    func save<T: Codable>(_ object: T, forKey key: String) throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T
    func delete(forKey key: String) throws
    func exists(forKey key: String) -> Bool
}

// MARK: - JSON File Storage
public final class CGDKFileStorage: CGDKStorageProtocol {
    public static let shared = CGDKFileStorage()
    
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    
    public init() {
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private func fileURL(forKey key: String) -> URL {
        return documentsDirectory.appendingPathComponent("\(key).json")
    }
    
    public func save<T: Codable>(_ object: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL(forKey: key))
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T {
        let data = try Data(contentsOf: fileURL(forKey: key))
        return try JSONDecoder().decode(type, from: data)
    }
    
    public func delete(forKey key: String) throws {
        try fileManager.removeItem(at: fileURL(forKey: key))
    }
    
    public func exists(forKey key: String) -> Bool {
        return fileManager.fileExists(atPath: fileURL(forKey: key).path)
    }
    
    public func deleteAll() throws {
        let files = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        for file in files where file.pathExtension == "json" {
            try fileManager.removeItem(at: file)
        }
    }
}

// MARK: - Unified Storage Manager
@MainActor
public final class CGDKStorageManager {
    public static let shared = CGDKStorageManager()
    
    public let userDefaults = CGDKUserDefaultsManager.shared
    public let keychain = CGDKKeychain.shared
    public let fileStorage = CGDKFileStorage.shared
    public let coreData = CGDKCoreDataManager.shared
    
    private init() {}
    
    public func clearAllData() {
        userDefaults.removeAll()
        try? keychain.deleteAll()
        try? fileStorage.deleteAll()
        
        CGDKLogInfo("All storage data cleared")
    }
}