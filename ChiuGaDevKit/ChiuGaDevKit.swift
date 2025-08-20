//
//  ChiuGaDevKit.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

/// A convenience root view that wires up the design system and
/// common UX helpers such as theming and toast presentation.
public struct CGDKRoot<Content: View>: View {
    @StateObject private var themeManager: CGDKThemeManager
    @StateObject private var toastCenter = CGDKToastCenter()
    private let content: () -> Content

    /// Creates a root container.
    /// - Parameters:
    ///   - theme: Initial theme to apply. Defaults to ``CGDKTheme.default``.
    ///   - content: The view hierarchy that should adopt the standard style.
    public init(theme: CGDKTheme = .default, @ViewBuilder content: @escaping () -> Content) {
        _themeManager = StateObject(wrappedValue: CGDKThemeManager(theme: theme))
        self.content = content
    }

    public var body: some View {
        CGDKToastHost(center: toastCenter) {
            content()
                .environmentObject(themeManager)
                .environmentObject(toastCenter)
                .cgdkThemedBackground()
                .cgdkAppStyle()
        }
    }
}

