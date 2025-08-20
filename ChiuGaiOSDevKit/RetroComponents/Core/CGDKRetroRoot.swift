//
//  CGDKRetroRoot.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Enhanced Retro Root Container
public struct CGDKRetroRoot<Content: View>: View {
    private let content: Content
    private let colorScheme: CGDKRetroTokens.ColorScheme
    @StateObject private var themeManager = CGDKThemeManager(theme: .retro)
    @StateObject private var toastCenter = CGDKToastCenter()
    
    public init(colorScheme: CGDKRetroTokens.ColorScheme = .classic, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.colorScheme = colorScheme
    }
    
    public var body: some View {
        let colors = CGDKRetroTokens.Color.colors(for: colorScheme)
        
        content
            .environmentObject(themeManager)
            .environmentObject(toastCenter)
            .background(colors.background.ignoresSafeArea())
            .preferredColorScheme(colorScheme == .white ? .light : .dark)
    }
}