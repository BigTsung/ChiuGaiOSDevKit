//
//  CGDKEPaperTokens.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKEPaperTokens {
    public struct Color {
        public static let paper = SwiftUI.Color(red: 0.98, green: 0.96, blue: 0.94)
        public static let ink = SwiftUI.Color.black
        public static let inkLight = SwiftUI.Color(red: 0.3, green: 0.3, blue: 0.3)
        public static let inkMuted = SwiftUI.Color(red: 0.6, green: 0.6, blue: 0.6)
        public static let accent = SwiftUI.Color(red: 0.2, green: 0.2, blue: 0.2)
        public static let border = SwiftUI.Color(red: 0.85, green: 0.85, blue: 0.85)
    }
    
    public struct Typography {
        public static func title() -> Font {
            .custom("Courier", size: 32, relativeTo: .largeTitle).weight(.black)
        }
        
        public static func heading() -> Font {
            .custom("Courier", size: 20, relativeTo: .title2).weight(.bold)
        }
        
        public static func subheading() -> Font {
            .custom("Courier", size: 16, relativeTo: .headline).weight(.semibold)
        }
        
        public static func body() -> Font {
            .custom("Courier", size: 14, relativeTo: .body).weight(.medium)
        }
        
        public static func caption() -> Font {
            .custom("Courier", size: 12, relativeTo: .caption).weight(.regular)
        }
        
        public static func label() -> Font {
            .custom("Courier", size: 10, relativeTo: .caption2).weight(.medium)
        }
    }
    
    public struct Space {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
        public static let xxl: CGFloat = 48
    }
    
    public struct Corner {
        public static let none: CGFloat = 0
        public static let sm: CGFloat = 2
        public static let md: CGFloat = 4
        public static let lg: CGFloat = 8
    }
}