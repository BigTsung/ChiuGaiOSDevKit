//
//  CGDKValidator.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import Foundation

public enum CGDKValidationError: LocalizedError {
    case required
    case tooShort(min: Int)
    case tooLong(max: Int)
    case invalidEmail
    case invalidPhone
    case invalidPassword
    case mismatchPassword
    case custom(String)
    
    public var errorDescription: String? {
        switch self {
        case .required:
            return "This field is required"
        case .tooShort(let min):
            return "Must be at least \(min) characters"
        case .tooLong(let max):
            return "Must be no more than \(max) characters"
        case .invalidEmail:
            return "Invalid email address"
        case .invalidPhone:
            return "Invalid phone number"
        case .invalidPassword:
            return "Password must contain at least 8 characters, including uppercase, lowercase, and number"
        case .mismatchPassword:
            return "Passwords do not match"
        case .custom(let message):
            return message
        }
    }
}

public struct CGDKValidator {
    public static func validate(_ value: String?, rules: [CGDKValidationRule]) -> Result<String, CGDKValidationError> {
        let text = value?.trimmed ?? ""
        
        for rule in rules {
            switch rule.validate(text) {
            case .success:
                continue
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return .success(text)
    }
}

public protocol CGDKValidationRule {
    func validate(_ value: String) -> Result<String, CGDKValidationError>
}

// MARK: - Built-in Rules
public struct CGDKRequiredRule: CGDKValidationRule {
    public init() {}
    
    public func validate(_ value: String) -> Result<String, CGDKValidationError> {
        value.isEmpty ? .failure(.required) : .success(value)
    }
}

public struct CGDKMinLengthRule: CGDKValidationRule {
    private let minLength: Int
    
    public init(_ minLength: Int) {
        self.minLength = minLength
    }
    
    public func validate(_ value: String) -> Result<String, CGDKValidationError> {
        value.count >= minLength ? .success(value) : .failure(.tooShort(min: minLength))
    }
}

public struct CGDKMaxLengthRule: CGDKValidationRule {
    private let maxLength: Int
    
    public init(_ maxLength: Int) {
        self.maxLength = maxLength
    }
    
    public func validate(_ value: String) -> Result<String, CGDKValidationError> {
        value.count <= maxLength ? .success(value) : .failure(.tooLong(max: maxLength))
    }
}

public struct CGDKEmailRule: CGDKValidationRule {
    public init() {}
    
    public func validate(_ value: String) -> Result<String, CGDKValidationError> {
        value.isEmpty || value.isEmail ? .success(value) : .failure(.invalidEmail)
    }
}

public struct CGDKPhoneRule: CGDKValidationRule {
    public init() {}
    
    public func validate(_ value: String) -> Result<String, CGDKValidationError> {
        value.isEmpty || value.isPhone ? .success(value) : .failure(.invalidPhone)
    }
}

public struct CGDKPasswordRule: CGDKValidationRule {
    public init() {}
    
    public func validate(_ value: String) -> Result<String, CGDKValidationError> {
        if value.isEmpty { return .success(value) }
        
        let hasUppercase = value.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = value.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumber = value.rangeOfCharacter(from: .decimalDigits) != nil
        let hasMinLength = value.count >= 8
        
        return (hasUppercase && hasLowercase && hasNumber && hasMinLength) 
            ? .success(value) 
            : .failure(.invalidPassword)
    }
}

public struct CGDKPasswordMatchRule: CGDKValidationRule {
    private let originalPassword: String
    
    public init(matches password: String) {
        self.originalPassword = password
    }
    
    public func validate(_ value: String) -> Result<String, CGDKValidationError> {
        value == originalPassword ? .success(value) : .failure(.mismatchPassword)
    }
}

public struct CGDKCustomRule: CGDKValidationRule {
    private let validator: (String) -> Bool
    private let errorMessage: String
    
    public init(errorMessage: String, validator: @escaping (String) -> Bool) {
        self.errorMessage = errorMessage
        self.validator = validator
    }
    
    public func validate(_ value: String) -> Result<String, CGDKValidationError> {
        validator(value) ? .success(value) : .failure(.custom(errorMessage))
    }
}