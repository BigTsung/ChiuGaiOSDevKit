//
//  CGDKEPaperCard.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKEPaperCard<Content: View>: View {
    let title: String?
    let content: Content
    
    public init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CGDKEPaperTokens.Space.md) {
            if let title = title {
                Text(title)
                    .font(CGDKEPaperTokens.Typography.heading())
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
                    .tracking(1.2)
            }
            
            content
        }
        .padding(CGDKEPaperTokens.Space.lg)
        .background(CGDKEPaperTokens.Color.paper)
        .overlay(
            Rectangle()
                .strokeBorder(CGDKEPaperTokens.Color.border, lineWidth: 1)
        )
        .cornerRadius(CGDKEPaperTokens.Corner.md)
    }
}

#Preview {
    VStack(spacing: 16) {
        CGDKEPaperCard(title: "SAMPLE CARD") {
            VStack(alignment: .leading, spacing: 8) {
                Text("This is a sample card content")
                    .font(CGDKEPaperTokens.Typography.body())
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
                
                Text("Additional description text")
                    .font(CGDKEPaperTokens.Typography.caption())
                    .foregroundStyle(CGDKEPaperTokens.Color.inkMuted)
            }
        }
        
        CGDKEPaperCard {
            Text("Card without title")
                .font(CGDKEPaperTokens.Typography.body())
                .foregroundStyle(CGDKEPaperTokens.Color.ink)
        }
    }
    .padding()
    .background(CGDKEPaperTokens.Color.paper)
}