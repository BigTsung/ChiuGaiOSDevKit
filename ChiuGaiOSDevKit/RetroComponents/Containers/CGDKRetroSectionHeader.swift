//
//  CGDKRetroSectionHeader.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Section Header
public struct CGDKRetroSectionHeader: View {
    private let title: String
    private let style: Style
    
    public enum Style {
        case title, heading, label
        
        var font: Font {
            switch self {
            case .title: return CGDKRetroTokens.Font.title()
            case .heading: return CGDKRetroTokens.Font.heading()
            case .label: return CGDKRetroTokens.Font.body()
            }
        }
    }
    
    public init(_ title: String, style: Style = .heading) {
        self.title = title
        self.style = style
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .font(style.font)
                .foregroundStyle(CGDKRetroTokens.Color.text)
                .textCase(.uppercase)
            Spacer()
        }
        .padding(.horizontal, CGDKRetroTokens.Space.lg)
        .padding(.vertical, CGDKRetroTokens.Space.sm)
        .background(
            Rectangle()
                .fill(CGDKRetroTokens.Color.selected)
        )
        .overlay(
            Rectangle()
                .stroke(CGDKRetroTokens.Color.border, lineWidth: CGDKRetroTokens.Border.thin)
        )
    }
}