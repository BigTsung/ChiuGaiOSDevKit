//
//  DemoView.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKDemoView: View {
    public init() {}
    public var body: some View {
        CGDKRoot {
            DemoContent()
        }
    }
}

private struct DemoContent: View {
    @EnvironmentObject var toast: CGDKToastCenter
    var body: some View {
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
    }
}

#Preview("Demo") {
    CGDKDemoView()
        .environmentObject(CGDKThemeManager())
}
