//
//  CGDKRetroToggle.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Toggle
public struct CGDKRetroToggle: View {
    @Binding private var isOn: Bool
    private let label: String?
    private let colors: CGDKRetroTokens.RetroColors
    
    public init(_ label: String? = nil, isOn: Binding<Bool>, colorScheme: CGDKRetroTokens.ColorScheme = .classic) {
        self.label = label
        self._isOn = isOn
        self.colors = CGDKRetroTokens.Color.colors(for: colorScheme)
    }
    
    public var body: some View {
        HStack(spacing: CGDKRetroTokens.Space.md) {
            if let label = label {
                Text(label)
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(colors.text)
            }
            
            Button(action: { isOn.toggle() }) {
                HStack(spacing: CGDKRetroTokens.Space.xs) {
                    Text("[")
                        .font(CGDKRetroTokens.Font.body())
                        .foregroundStyle(colors.border)
                    
                    Text(isOn ? "X" : " ")
                        .font(CGDKRetroTokens.Font.body())
                        .foregroundStyle(colors.accent)
                        .frame(width: 12)
                    
                    Text("]")
                        .font(CGDKRetroTokens.Font.body())
                        .foregroundStyle(colors.border)
                    
                    Text(isOn ? "ON" : "OFF")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(isOn ? colors.accent : colors.textMuted)
                        .frame(minWidth: 24, alignment: .leading)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}