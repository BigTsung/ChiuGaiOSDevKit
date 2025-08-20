//
//  CGDKRetroTextField.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Text Field
public struct CGDKRetroTextField: View {
    @Binding private var text: String
    private let placeholder: String
    private let label: String?
    
    public init(_ placeholder: String, text: Binding<String>, label: String? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.label = label
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.xs) {
            if let label = label {
                Text(label)
                    .font(CGDKRetroTokens.Font.caption())
                    .foregroundStyle(CGDKRetroTokens.Color.textMuted)
            }
            
            TextField(placeholder, text: $text)
                .font(CGDKRetroTokens.Font.body())
                .foregroundStyle(CGDKRetroTokens.Color.text)
                .padding(CGDKRetroTokens.Space.md)
                .background(CGDKRetroTokens.Color.screen)
                .overlay(
                    Rectangle()
                        .stroke(CGDKRetroTokens.Color.border, lineWidth: CGDKRetroTokens.Border.thin)
                )
        }
    }
}