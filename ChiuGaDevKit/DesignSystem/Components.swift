//
//  Components.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKButton: View {
    public enum Style { case primary, ghost, danger }
    let title: String; let style: Style; let action: () -> Void
    @EnvironmentObject var tm: CGDKThemeManager
    public init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title; self.style = style; self.action = action
    }
    public var body: some View {
        Button(action: action) {
            Text(title).font(CGDKTokens.Font.body(16))
                .padding(.vertical, CGDKTokens.Space.md)
                .padding(.horizontal, CGDKTokens.Space.xl)
                .frame(maxWidth: .infinity)
        }
        .background(background)
        .foregroundStyle(foreground)
        .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.md, style: .continuous))
        .overlay {
            if style == .ghost {
                RoundedRectangle(cornerRadius: tm.theme.radius.md)
                    .stroke(tm.theme.colors.brand.opacity(0.4), lineWidth: 1)
            }
        }
    }
    private var background: some ShapeStyle {
        switch style {
        case .primary: tm.theme.colors.brand
        case .danger:  tm.theme.colors.danger
        case .ghost:   Color.clear
        }
    }
    private var foreground: Color { style == .ghost ? tm.theme.colors.brand : .white }
}

public struct CGDKCard<Content: View>: View {
    @EnvironmentObject var tm: CGDKThemeManager
    let content: Content
    public init(@ViewBuilder _ c: ()->Content){ self.content = c() }
    public var body: some View {
        content
            .padding(CGDKTokens.Space.lg)
            .background(tm.theme.colors.card)
            .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.lg, style: .continuous))
    }
}

public struct CGDKSectionHeader: View {
    let title: String; let sub: String?
    public init(_ title: String, sub: String? = nil){ self.title = title; self.sub = sub }
    public var body: some View {
        HStack {
            Text(title).font(CGDKTokens.Font.title())
            Spacer()
            if let s = sub { Text(s).font(CGDKTokens.Font.caption()).foregroundStyle(CGDKTokens.Color.muted) }
        }
        .padding(.horizontal, CGDKTokens.Space.xl)
        .padding(.top, CGDKTokens.Space.lg)
    }
}
