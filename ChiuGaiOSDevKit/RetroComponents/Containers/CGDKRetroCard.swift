//
//  CGDKRetroCard.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Card Component
public struct CGDKRetroCard<Content: View>: View {
    @EnvironmentObject var tm: CGDKThemeManager
    private let content: Content
    private let borderWidth: CGFloat
    private let cornerRadius: CGFloat
    
    public init(
        borderWidth: CGFloat = CGDKRetroTokens.Border.medium,
        cornerRadius: CGFloat = CGDKRetroTokens.Corner.medium,
        @ViewBuilder content: () -> Content
    ) {
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(CGDKRetroTokens.Space.lg)
            .background(tm.theme.colors.card)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(CGDKRetroTokens.Color.border, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}