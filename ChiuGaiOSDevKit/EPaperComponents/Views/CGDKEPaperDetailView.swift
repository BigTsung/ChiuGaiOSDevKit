//
//  CGDKEPaperDetailView.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKEPaperDetailView: View {
    @Binding var isPresented: Bool
    
    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: CGDKEPaperTokens.Space.xl) {
                headerSection
                contentSection
                footerSection
            }
            .padding(CGDKEPaperTokens.Space.lg)
        }
        .background(CGDKEPaperTokens.Color.paper)
        .overlay(alignment: .topTrailing) {
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
            }
            .buttonStyle(.plain)
            .padding(CGDKEPaperTokens.Space.lg)
        }
    }
    
    private var headerSection: some View {
        CGDKEPaperCard(title: "DETAILED VIEW") {
            VStack(alignment: .leading, spacing: CGDKEPaperTokens.Space.md) {
                Text("COMPREHENSIVE EXPERIENCE")
                    .font(CGDKEPaperTokens.Typography.heading())
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
                
                Text("This detailed view showcases the complete e-paper aesthetic with enhanced functionality and deeper content exploration.")
                    .font(CGDKEPaperTokens.Typography.body())
                    .foregroundStyle(CGDKEPaperTokens.Color.inkLight)
            }
        }
    }
    
    private var contentSection: some View {
        VStack(spacing: CGDKEPaperTokens.Space.lg) {
            CGDKEPaperCard(title: "FEATURES") {
                VStack(alignment: .leading, spacing: CGDKEPaperTokens.Space.sm) {
                    featureRow("Typography", "Custom monospace fonts")
                    featureRow("Colors", "E-paper inspired palette")
                    featureRow("Layout", "Card-based composition")
                    featureRow("Interaction", "Minimal touch controls")
                    featureRow("Animation", "Subtle transitions")
                }
            }
            
            CGDKEPaperCard(title: "TECHNICAL") {
                VStack(alignment: .leading, spacing: CGDKEPaperTokens.Space.sm) {
                    technicalRow("Framework", "SwiftUI")
                    technicalRow("Compatibility", "iOS 15+")
                    technicalRow("Architecture", "MVVM")
                    technicalRow("Performance", "Optimized")
                }
            }
        }
    }
    
    private var footerSection: some View {
        CGDKEPaperCard {
            VStack(spacing: CGDKEPaperTokens.Space.md) {
                Text("THANK YOU FOR EXPLORING")
                    .font(CGDKEPaperTokens.Typography.subheading())
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
                
                CGDKEPaperButton("CLOSE", style: .primary) {
                    isPresented = false
                }
            }
        }
    }
    
    private func featureRow(_ title: String, _ description: String) -> some View {
        HStack {
            Text(title.uppercased())
                .font(CGDKEPaperTokens.Typography.caption())
                .foregroundStyle(CGDKEPaperTokens.Color.ink)
                .frame(width: 80, alignment: .leading)
            
            Text(description)
                .font(CGDKEPaperTokens.Typography.caption())
                .foregroundStyle(CGDKEPaperTokens.Color.inkMuted)
            
            Spacer()
        }
    }
    
    private func technicalRow(_ key: String, _ value: String) -> some View {
        HStack {
            Text(key)
                .font(CGDKEPaperTokens.Typography.caption())
                .foregroundStyle(CGDKEPaperTokens.Color.inkLight)
            
            Spacer()
            
            Text(value)
                .font(CGDKEPaperTokens.Typography.caption())
                .foregroundStyle(CGDKEPaperTokens.Color.ink)
        }
    }
}