//
//  CGDKRetroAlert.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Alert
public struct CGDKRetroAlert: View {
    private let title: String
    private let message: String?
    private let primaryButton: String
    private let secondaryButton: String?
    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?
    private let colors: CGDKRetroTokens.RetroColors
    
    public init(
        title: String,
        message: String? = nil,
        primaryButton: String = "OK",
        secondaryButton: String? = nil,
        colorScheme: CGDKRetroTokens.ColorScheme = .classic,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.colors = CGDKRetroTokens.Color.colors(for: colorScheme)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 標題列
            HStack {
                Text("*** \(title.uppercased()) ***")
                    .font(CGDKRetroTokens.Font.heading())
                    .foregroundStyle(colors.text)
            }
            .padding(CGDKRetroTokens.Space.md)
            .frame(maxWidth: .infinity)
            .background(colors.selected)
            .overlay(
                Rectangle()
                    .stroke(colors.border, lineWidth: CGDKRetroTokens.Border.medium)
            )
            
            // 內容
            VStack(spacing: CGDKRetroTokens.Space.md) {
                if let message = message {
                    Text(message)
                        .font(CGDKRetroTokens.Font.body())
                        .foregroundStyle(colors.textMuted)
                        .multilineTextAlignment(.center)
                }
                
                // 按鈕
                HStack(spacing: CGDKRetroTokens.Space.md) {
                    if let secondaryButton = secondaryButton {
                        CGDKRetroButton(secondaryButton, style: CGDKRetroButton.Style.outline) {
                            secondaryAction?()
                        }
                    }
                    
                    CGDKRetroButton(primaryButton, style: CGDKRetroButton.Style.primary) {
                        primaryAction()
                    }
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
            .background(colors.screen)
            .overlay(
                Rectangle()
                    .stroke(colors.border, lineWidth: CGDKRetroTokens.Border.medium)
            )
        }
        .frame(maxWidth: 300)
    }
}