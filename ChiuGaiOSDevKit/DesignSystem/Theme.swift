//
//  Theme.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI
import Combine   // ✅ Swift 6 必須顯式匯入

public struct CGDKTheme: Equatable {
    public struct Colors: Equatable {              // ✅ 加上 Equatable
        public let bg, card, text, muted, brand, line, danger: Color
        public init(bg: Color, card: Color, text: Color, muted: Color, brand: Color, line: Color, danger: Color) {
            self.bg = bg; self.card = card; self.text = text; self.muted = muted
            self.brand = brand; self.line = line; self.danger = danger
        }
    }
    public struct Radius: Equatable {              // ✅ 加上 Equatable
        public let sm, md, lg, pill: CGFloat
        public init(sm: CGFloat, md: CGFloat, lg: CGFloat, pill: CGFloat) {
            self.sm = sm; self.md = md; self.lg = lg; self.pill = pill
        }
    }

    public let colors: Colors
    public let radius: Radius

    public static let `default` = CGDKTheme(
        colors: .init(bg: CGDKTokens.Color.bg,
                      card: CGDKTokens.Color.card,
                      text: CGDKTokens.Color.text,
                      muted: CGDKTokens.Color.muted,
                      brand: CGDKTokens.Color.brand,
                      line: CGDKTokens.Color.line,
                      danger: CGDKTokens.Color.danger),
        radius: .init(sm: CGDKTokens.Radius.sm,
                      md: CGDKTokens.Radius.md,
                      lg: CGDKTokens.Radius.lg,
                      pill: CGDKTokens.Radius.pill)
    )
}

@MainActor                                      // ✅ 建議：限制在主執行緒
public final class CGDKThemeManager: ObservableObject {
    @Published public private(set) var theme: CGDKTheme
    public init(theme: CGDKTheme = .default) { self.theme = theme }
    public func apply(_ theme: CGDKTheme) { self.theme = theme }
}

public struct CGDKThemedBackground: ViewModifier {
    @EnvironmentObject var tm: CGDKThemeManager
    public func body(content: Content) -> some View {
        content
            .tint(tm.theme.colors.brand)
            .foregroundStyle(tm.theme.colors.text)
            .background(tm.theme.colors.bg.ignoresSafeArea())
    }
}
public extension View { func cgdkThemedBackground() -> some View { modifier(CGDKThemedBackground()) } }
