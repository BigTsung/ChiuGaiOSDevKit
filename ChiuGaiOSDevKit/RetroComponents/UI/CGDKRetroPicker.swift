//
//  CGDKRetroPicker.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Picker
public struct CGDKRetroPicker<T: Hashable>: View {
    @Binding private var selection: T
    private let options: [T]
    private let label: String?
    private let displayText: (T) -> String
    private let colors: CGDKRetroTokens.RetroColors
    
    public init(
        _ label: String? = nil,
        selection: Binding<T>,
        options: [T],
        colorScheme: CGDKRetroTokens.ColorScheme = .classic,
        displayText: @escaping (T) -> String = { "\($0)" }
    ) {
        self.label = label
        self._selection = selection
        self.options = options
        self.displayText = displayText
        self.colors = CGDKRetroTokens.Color.colors(for: colorScheme)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.xs) {
            if let label = label {
                Text(label)
                    .font(CGDKRetroTokens.Font.caption())
                    .foregroundStyle(colors.textMuted)
            }
            
            HStack {
                Button("<") {
                    if let currentIndex = options.firstIndex(of: selection),
                       currentIndex > 0 {
                        selection = options[currentIndex - 1]
                    }
                }
                .font(CGDKRetroTokens.Font.body())
                .foregroundStyle(colors.border)
                
                Text("[ \(displayText(selection)) ]")
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(colors.text)
                    .frame(minWidth: 120)
                
                Button(">") {
                    if let currentIndex = options.firstIndex(of: selection),
                       currentIndex < options.count - 1 {
                        selection = options[currentIndex + 1]
                    }
                }
                .font(CGDKRetroTokens.Font.body())
                .foregroundStyle(colors.border)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}