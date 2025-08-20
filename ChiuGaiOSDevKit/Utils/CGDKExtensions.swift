//
//  CGDKExtensions.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI
import Foundation

// MARK: - String Extensions
public extension String {
    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isPhone: Bool {
        let phoneRegex = "^[+]?[0-9]{8,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func limitLength(_ max: Int) -> String {
        if count <= max { return self }
        return String(prefix(max))
    }
}

// MARK: - View Extensions
public extension View {
    func cgdkHidden(_ isHidden: Bool) -> some View {
        opacity(isHidden ? 0 : 1)
    }
    
    func cgdkBorder(_ color: Color = .gray, width: CGFloat = 1, radius: CGFloat = 8) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: width)
        )
    }
    
    @ViewBuilder
    func cgdkIf<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Collection Extensions
public extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    var isNotEmpty: Bool { !isEmpty }
}

// MARK: - Date Extensions
public extension Date {
    @MainActor
    func formatted(_ format: CGDKDateFormat) -> String {
        CGDKDateFormatter.shared.string(from: self, format: format)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        Calendar.current.date(byAdding: component, value: value, to: self) ?? self
    }
}

// MARK: - Optional Extensions
public extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }
    
    var orEmpty: String {
        self ?? ""
    }
}