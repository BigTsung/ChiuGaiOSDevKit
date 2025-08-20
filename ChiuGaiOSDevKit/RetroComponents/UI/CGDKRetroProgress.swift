//
//  CGDKRetroProgress.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Progress Bar
public struct CGDKRetroProgress: View {
    private let progress: Double // 0.0 to 1.0
    private let label: String?
    private let showPercentage: Bool
    private let width: CGFloat
    private let colors: CGDKRetroTokens.RetroColors
    private let style: Style
    
    public enum Style {
        case bar        // [████████░░░░] 80%
        case dots       // [••••••••    ] 67%
        case ascii      // [========----] 67%
        case loading    // [>>>>>>>     ] Loading...
    }
    
    public init(
        _ label: String? = nil,
        progress: Double,
        style: Style = .bar,
        showPercentage: Bool = true,
        width: CGFloat = 200,
        colorScheme: CGDKRetroTokens.ColorScheme = .classic
    ) {
        self.label = label
        self.progress = max(0, min(1, progress))
        self.style = style
        self.showPercentage = showPercentage
        self.width = width
        self.colors = CGDKRetroTokens.Color.colors(for: colorScheme)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.xs) {
            if let label = label {
                Text(label)
                    .font(CGDKRetroTokens.Font.caption())
                    .foregroundStyle(colors.textMuted)
            }
            
            HStack(spacing: CGDKRetroTokens.Space.sm) {
                progressBar
                
                if showPercentage {
                    Text("\(Int(progress * 100))%")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(colors.text)
                        .frame(minWidth: 36, alignment: .trailing)
                }
            }
        }
    }
    
    private var progressBar: some View {
        HStack(spacing: 0) {
            Text("[")
                .font(CGDKRetroTokens.Font.body())
                .foregroundStyle(colors.border)
            
            progressContent
                .frame(width: width)
            
            Text("]")
                .font(CGDKRetroTokens.Font.body())
                .foregroundStyle(colors.border)
        }
    }
    
    private var progressContent: some View {
        let totalChars = Int(width / 8) // 大約每個字符8點寬
        let filledChars = Int(Double(totalChars) * progress)
        let emptyChars = totalChars - filledChars
        
        return HStack(spacing: 0) {
            Text(String(repeating: filledCharacter, count: filledChars))
                .font(CGDKRetroTokens.Font.body())
                .foregroundStyle(colors.accent)
            
            Text(String(repeating: emptyCharacter, count: emptyChars))
                .font(CGDKRetroTokens.Font.body())
                .foregroundStyle(colors.borderLight)
        }
    }
    
    private var filledCharacter: String {
        switch style {
        case .bar: return "█"
        case .dots: return "•"
        case .ascii: return "="
        case .loading: return ">"
        }
    }
    
    private var emptyCharacter: String {
        switch style {
        case .bar: return "░"
        case .dots: return " "
        case .ascii: return "-"
        case .loading: return " "
        }
    }
}