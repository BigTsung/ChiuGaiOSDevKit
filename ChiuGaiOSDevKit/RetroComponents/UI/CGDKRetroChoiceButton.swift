//
//  CGDKRetroChoiceButton.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Choice Button
public struct CGDKRetroChoiceButton: View {
    private let title: String
    private let isSelected: Bool
    private let action: () -> Void
    
    public init(_ title: String, isSelected: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: CGDKRetroTokens.Space.md) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(CGDKRetroTokens.Color.text)
                
                Text(title)
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(CGDKRetroTokens.Color.text)
                
                Spacer()
            }
            .padding(.vertical, CGDKRetroTokens.Space.sm)
            .padding(.horizontal, CGDKRetroTokens.Space.md)
            .background(
                isSelected ? CGDKRetroTokens.Color.selected : Color.clear
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}