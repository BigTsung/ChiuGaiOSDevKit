//
//  CGDKRetroContainer.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Container
public struct CGDKRetroContainer<Content: View>: View {
    private let content: Content
    private let title: String?
    
    public init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = title {
                CGDKRetroSectionHeader(title, style: .title)
            }
            
            content
        }
        .background(CGDKRetroTokens.Color.screen)
        .overlay(
            Rectangle()
                .stroke(CGDKRetroTokens.Color.border, lineWidth: CGDKRetroTokens.Border.thick)
        )
        .clipShape(Rectangle())
    }
}