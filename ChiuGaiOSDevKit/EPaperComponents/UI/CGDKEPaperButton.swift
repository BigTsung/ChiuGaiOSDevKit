//
//  CGDKEPaperButton.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKEPaperButton: View {
    let title: String
    let action: () -> Void
    let style: Style
    
    public enum Style {
        case primary
        case secondary
        case minimal
    }
    
    public init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(CGDKEPaperTokens.Typography.body())
                .tracking(0.5)
                .foregroundStyle(textColor)
                .padding(.horizontal, CGDKEPaperTokens.Space.lg)
                .padding(.vertical, CGDKEPaperTokens.Space.md)
                .background(backgroundColor)
                .overlay(
                    Rectangle()
                        .strokeBorder(borderColor, lineWidth: borderWidth)
                )
                .cornerRadius(CGDKEPaperTokens.Corner.sm)
        }
        .buttonStyle(.plain)
    }
    
    private var textColor: Color {
        switch style {
        case .primary: return CGDKEPaperTokens.Color.paper
        case .secondary: return CGDKEPaperTokens.Color.ink
        case .minimal: return CGDKEPaperTokens.Color.inkLight
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return CGDKEPaperTokens.Color.ink
        case .secondary: return CGDKEPaperTokens.Color.paper
        case .minimal: return Color.clear
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary: return CGDKEPaperTokens.Color.ink
        case .secondary: return CGDKEPaperTokens.Color.ink
        case .minimal: return CGDKEPaperTokens.Color.border
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary: return 2
        case .secondary: return 1.5
        case .minimal: return 1
        }
    }
}

#Preview{
    CGDKEPaperButton("TEST", style: .primary){
        
    }
    CGDKEPaperButton("TEST", style: .minimal){
        
    }
    CGDKEPaperButton("TEST", style: .secondary){
        
    }
}
