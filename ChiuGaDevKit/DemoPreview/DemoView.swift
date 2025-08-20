//
//  DemoView.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKDemoView: View {
    @StateObject var theme = CGDKThemeManager()
    @StateObject var toast = CGDKToastCenter()
    public init() {}
    public var body: some View {
        CGDKToastHost(center: toast) {
            ScrollView {
                CGDKSectionHeader("ChiuGaDevKit", sub: "Design System")
                VStack(spacing: CGDKTokens.Space.lg) {
                    CGDKCard {
                        VStack(alignment: .leading, spacing: CGDKTokens.Space.sm) {
                            Text("統一設計系統").font(CGDKTokens.Font.title())
                            Text("這是 Card + Tokens + Theme 的示範。")
                                .foregroundStyle(CGDKTokens.Color.muted)
                        }
                    }
                    CGDKButton("顯示 Toast") { toast.show("已儲存") }
                    CGDKButton("Danger", style: .danger) {}
                    CGDKButton("Ghost", style: .ghost) {}
                }
                .padding(CGDKTokens.Space.xl)
            }
            .environmentObject(theme)
            .cgdkThemedBackground()
            .cgdkAppStyle()
        }
    }
}

#Preview("Demo") {
    CGDKDemoView()
        .environmentObject(CGDKThemeManager())   // ← 必加
}
