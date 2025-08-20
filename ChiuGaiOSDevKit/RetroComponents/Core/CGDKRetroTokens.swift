//
//  CGDKRetroTokens.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Design Tokens
public enum CGDKRetroTokens {
    
    // MARK: - Color Schemes
    public enum ColorScheme {
        case classic    // 黑底白字綠色強調
        case amber      // 黑底琥珀色
        case green      // 黑底綠色
        case blue       // 黑底藍色
        case white      // 白底黑字
        case matrix     // 黑底綠色Matrix風格
    }
    
    public enum Color {
        // 基礎色彩
        public static let terminal    = SwiftUI.Color.black
        public static let screen      = SwiftUI.Color(red: 0.05, green: 0.05, blue: 0.05)
        public static let border      = SwiftUI.Color.white
        public static let borderLight = SwiftUI.Color.white.opacity(0.7)
        public static let text        = SwiftUI.Color.white
        public static let textMuted   = SwiftUI.Color.white.opacity(0.8)
        public static let accent      = SwiftUI.Color.green
        public static let selected    = SwiftUI.Color.white.opacity(0.2)
        
        // 擴展色彩方案
        public static let amber       = SwiftUI.Color(red: 1.0, green: 0.75, blue: 0.0)
        public static let amberDim    = SwiftUI.Color(red: 0.8, green: 0.6, blue: 0.0)
        public static let greenBright = SwiftUI.Color(red: 0.0, green: 1.0, blue: 0.0)
        public static let greenDim    = SwiftUI.Color(red: 0.0, green: 0.8, blue: 0.0)
        public static let blueBright  = SwiftUI.Color(red: 0.0, green: 0.8, blue: 1.0)
        public static let blueDim     = SwiftUI.Color(red: 0.0, green: 0.6, blue: 0.8)
        public static let matrixGreen = SwiftUI.Color(red: 0.0, green: 1.0, blue: 0.41)
        
        // 根據色彩方案獲取顏色
        public static func colors(for scheme: ColorScheme) -> RetroColors {
            switch scheme {
            case .classic:
                return RetroColors(
                    background: terminal,
                    screen: screen,
                    border: border,
                    borderLight: borderLight,
                    text: text,
                    textMuted: textMuted,
                    accent: accent,
                    selected: selected
                )
            case .amber:
                return RetroColors(
                    background: terminal,
                    screen: SwiftUI.Color(red: 0.1, green: 0.05, blue: 0.0),
                    border: amber,
                    borderLight: amberDim,
                    text: amber,
                    textMuted: amberDim,
                    accent: amber,
                    selected: amber.opacity(0.2)
                )
            case .green:
                return RetroColors(
                    background: terminal,
                    screen: SwiftUI.Color(red: 0.0, green: 0.05, blue: 0.0),
                    border: greenBright,
                    borderLight: greenDim,
                    text: greenBright,
                    textMuted: greenDim,
                    accent: greenBright,
                    selected: greenBright.opacity(0.2)
                )
            case .blue:
                return RetroColors(
                    background: terminal,
                    screen: SwiftUI.Color(red: 0.0, green: 0.02, blue: 0.1),
                    border: blueBright,
                    borderLight: blueDim,
                    text: blueBright,
                    textMuted: blueDim,
                    accent: blueBright,
                    selected: blueBright.opacity(0.2)
                )
            case .white:
                return RetroColors(
                    background: SwiftUI.Color.white,
                    screen: SwiftUI.Color(red: 0.95, green: 0.95, blue: 0.95),
                    border: SwiftUI.Color.black,
                    borderLight: SwiftUI.Color.black.opacity(0.7),
                    text: SwiftUI.Color.black,
                    textMuted: SwiftUI.Color.black.opacity(0.7),
                    accent: SwiftUI.Color.blue,
                    selected: SwiftUI.Color.black.opacity(0.1)
                )
            case .matrix:
                return RetroColors(
                    background: terminal,
                    screen: SwiftUI.Color(red: 0.0, green: 0.05, blue: 0.02),
                    border: matrixGreen,
                    borderLight: matrixGreen.opacity(0.7),
                    text: matrixGreen,
                    textMuted: matrixGreen.opacity(0.8),
                    accent: matrixGreen,
                    selected: matrixGreen.opacity(0.2)
                )
            }
        }
    }
    
    public struct RetroColors {
        public let background: SwiftUI.Color
        public let screen: SwiftUI.Color
        public let border: SwiftUI.Color
        public let borderLight: SwiftUI.Color
        public let text: SwiftUI.Color
        public let textMuted: SwiftUI.Color
        public let accent: SwiftUI.Color
        public let selected: SwiftUI.Color
        
        public init(
            background: SwiftUI.Color,
            screen: SwiftUI.Color,
            border: SwiftUI.Color,
            borderLight: SwiftUI.Color,
            text: SwiftUI.Color,
            textMuted: SwiftUI.Color,
            accent: SwiftUI.Color,
            selected: SwiftUI.Color
        ) {
            self.background = background
            self.screen = screen
            self.border = border
            self.borderLight = borderLight
            self.text = text
            self.textMuted = textMuted
            self.accent = accent
            self.selected = selected
        }
    }
    
    public enum Font {
        public static func title(_ size: CGFloat = 24) -> SwiftUI.Font { 
            .system(size: size, weight: .bold, design: .monospaced) 
        }
        public static func heading(_ size: CGFloat = 18) -> SwiftUI.Font { 
            .system(size: size, weight: .semibold, design: .monospaced) 
        }
        public static func body(_ size: CGFloat = 16) -> SwiftUI.Font { 
            .system(size: size, weight: .regular, design: .monospaced) 
        }
        public static func caption(_ size: CGFloat = 14) -> SwiftUI.Font { 
            .system(size: size, weight: .regular, design: .monospaced) 
        }
        public static func small(_ size: CGFloat = 12) -> SwiftUI.Font { 
            .system(size: size, weight: .regular, design: .monospaced) 
        }
    }
    
    public enum Border {
        public static let thin: CGFloat = 1
        public static let medium: CGFloat = 2
        public static let thick: CGFloat = 3
    }
    
    public enum Corner {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 12
        public static let large: CGFloat = 16
    }
    
    public enum Space {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 24
    }
}