//
//  CGDKRetroButton.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Button
public struct CGDKRetroButton: View {
    private let title: String
    private let style: Style
    private let action: () -> Void
    
    public enum Style {
        case primary, secondary, outline
    }
    
    public init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(CGDKRetroTokens.Font.body())
                .foregroundStyle(textColor)
                .padding(.horizontal, CGDKRetroTokens.Space.lg)
                .padding(.vertical, CGDKRetroTokens.Space.md)
                .background(backgroundColor)
                .overlay(
                    Rectangle()
                        .stroke(borderColor, lineWidth: CGDKRetroTokens.Border.medium)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return CGDKRetroTokens.Color.terminal
        case .secondary:
            return CGDKRetroTokens.Color.text
        case .outline:
            return CGDKRetroTokens.Color.text
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return CGDKRetroTokens.Color.text
        case .secondary:
            return CGDKRetroTokens.Color.text.opacity(0.2)
        case .outline:
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        return CGDKRetroTokens.Color.border
    }
}