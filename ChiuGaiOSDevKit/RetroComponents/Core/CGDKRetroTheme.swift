//
//  CGDKRetroTheme.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Theme Definition
public extension CGDKTheme {
    static let retro = CGDKTheme(
        colors: .init(
            bg: CGDKRetroTokens.Color.terminal,
            card: CGDKRetroTokens.Color.screen,
            text: CGDKRetroTokens.Color.text,
            muted: CGDKRetroTokens.Color.textMuted,
            brand: CGDKRetroTokens.Color.accent,
            line: CGDKRetroTokens.Color.borderLight,
            danger: SwiftUI.Color.red
        ),
        radius: .init(
            sm: CGDKRetroTokens.Corner.small,
            md: CGDKRetroTokens.Corner.medium,
            lg: CGDKRetroTokens.Corner.large,
            xl: CGDKRetroTokens.Corner.large + 4,
            pill: 999
        )
    )
}