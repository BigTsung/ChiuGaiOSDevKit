//
//  Tokens.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public enum CGDKTokens {
    public enum Color {
        public static let brand  = SwiftUI.Color(hex: 0x5B8CFF)
        public static let bg     = SwiftUI.Color(hex: 0x0B0B0C)
        public static let card   = SwiftUI.Color.white.opacity(0.06)
        public static let text   = SwiftUI.Color.white
        public static let muted  = SwiftUI.Color.white.opacity(0.64)
        public static let line   = SwiftUI.Color.white.opacity(0.12)
        public static let danger = SwiftUI.Color(red: 0.95, green: 0.25, blue: 0.25)
    }
    public enum Space {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 24
        public static let xxl: CGFloat = 32
    }
    public enum Radius {
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 20
        public static let xl: CGFloat = 24
        public static let pill: CGFloat = 999
    }
    public enum Font {
        public static func title(_ s: CGFloat = 22) -> SwiftUI.Font { .system(size: s, weight: .semibold) }
        public static func body(_ s: CGFloat = 16) -> SwiftUI.Font { .system(size: s, weight: .regular) }
        public static func caption(_ s: CGFloat = 12) -> SwiftUI.Font { .system(size: s, weight: .regular) }
    }
}

public extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF)/255,
                  green: Double((hex >> 8) & 0xFF)/255,
                  blue: Double(hex & 0xFF)/255,
                  opacity: alpha)
    }
}
