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
    @EnvironmentObject var tm: CGDKThemeManager
    @State private var text = ""
    @State private var isLoading = false
    @State private var showActionSheet = false
    @State private var showBottomSheet = false
    
    var body: some View {
        ScrollView {
            CGDKSectionHeader("ChiuGaiOSDevKit", sub: "Design System Demo")
            
            CGDKVStack(spacing: .lg) {
                // Basic Components
                CGDKCard {
                    CGDKVStack(spacing: .sm, alignment: .leading) {
                        Text("基本組件演示").font(CGDKTokens.Font.title())
                        Text("這是 Card + Tokens + Theme 的示範。")
                            .foregroundStyle(tm.theme.colors.muted)
                    }
                }
                
                // Buttons
                CGDKCard {
                    CGDKVStack(spacing: .md) {
                        Text("按鈕組件").font(CGDKTokens.Font.title(18))
                        CGDKButton("主要按鈕") { toast.show("主要按鈕被點擊") }
                        CGDKButton("危險按鈕", style: .danger) { toast.show("危險操作") }
                        CGDKButton("輔助按鈕", style: .ghost) { toast.show("輔助按鈕") }
                        CGDKLoadingButton("載入按鈕", isLoading: isLoading) {
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isLoading = false
                                toast.show("載入完成")
                            }
                        }
                    }
                }
                
                // Text Input
                CGDKCard {
                    CGDKVStack(spacing: .md, alignment: .leading) {
                        Text("輸入組件").font(CGDKTokens.Font.title(18))
                        CGDKTextField("輸入文字", text: $text, validationRules: [
                            CGDKRequiredRule(),
                            CGDKMinLengthRule(3)
                        ])
                    }
                }
                
                // UX Patterns
                CGDKCard {
                    CGDKVStack(spacing: .md) {
                        Text("UX 模式").font(CGDKTokens.Font.title(18))
                        CGDKButton("顯示操作選單", style: .ghost) {
                            showActionSheet = true
                        }
                        CGDKButton("顯示底部面板", style: .ghost) {
                            showBottomSheet = true
                        }
                    }
                }
                
                // Empty State
                CGDKCard {
                    CGDKEmptyState(
                        title: "暫無內容",
                        subtitle: "點擊下方按鈕添加新內容",
                        systemImage: "plus.circle",
                        actionTitle: "添加內容"
                    ) {
                        toast.show("添加新內容")
                    }
                }
            }
            .cgdkPadding(.xl)
        }
        .cgdkActionSheet(isPresented: $showActionSheet, title: "選擇操作", items: [
            CGDKActionSheetItem(title: "編輯") { toast.show("編輯") },
            CGDKActionSheetItem(title: "分享") { toast.show("分享") },
            CGDKActionSheetItem(title: "刪除", style: .destructive) { toast.show("刪除") }
        ])
        .cgdkBottomSheet(isPresented: $showBottomSheet) {
            CGDKVStack(spacing: .lg) {
                Text("底部面板").font(CGDKTokens.Font.title())
                Text("這是一個可拖動的底部面板")
                    .foregroundStyle(tm.theme.colors.muted)
                CGDKButton("關閉") {
                    showBottomSheet = false
                }
            }
            .cgdkPadding(.xl)
        }
    }
}

#Preview("Demo") {
    CGDKDemoView()
        .environmentObject(CGDKThemeManager())
}
