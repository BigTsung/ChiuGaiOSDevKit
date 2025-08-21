//
//  CGDKEPaperView.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Main E-Paper View
public struct CGDKEPaperView: View {
    @State private var currentPage = 0
    @State private var selectedTime = "TIME"
    @State private var selectedLifestyle = "FRESH"
    @State private var showDetail = false
    
    private let pages = [
        "1989",
        "NAFIO", 
        "YOUR OLD TIME"
    ]
    
    private let timeOptions = ["TIME", "MOMENT", "ERA", "PERIOD"]
    private let lifestyleOptions = ["FRESH", "MODERN", "CLASSIC", "VINTAGE"]
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header with navigation
                headerView
                    .padding(.horizontal, CGDKEPaperTokens.Space.lg)
                    .padding(.top, CGDKEPaperTokens.Space.xl)
                
                // Main content area
                ScrollView {
                    VStack(spacing: CGDKEPaperTokens.Space.xl) {
                        mainContentCard
                        
                        // Secondary content
                        HStack(spacing: CGDKEPaperTokens.Space.lg) {
                            timeSelectionCard
                            lifestyleCard
                        }
                        
                        // Interactive elements
                        interactiveSection
                        
                        // Footer navigation
                        CGDKEPaperNavigation(
                            currentPage: currentPage,
                            totalPages: pages.count,
                            onPageChange: { currentPage = $0 }
                        )
                        .padding(.vertical, CGDKEPaperTokens.Space.xl)
                    }
                    .padding(CGDKEPaperTokens.Space.lg)
                }
            }
        }
        .background(CGDKEPaperTokens.Color.paper)
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { withAnimation { currentPage = max(0, currentPage - 1) } }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
            }
            .disabled(currentPage == 0)
            .opacity(currentPage == 0 ? 0.3 : 1)
            
            Spacer()
            
            Text("12/13")
                .font(CGDKEPaperTokens.Typography.caption())
                .foregroundStyle(CGDKEPaperTokens.Color.inkMuted)
            
            Spacer()
            
            Button(action: { withAnimation { currentPage = min(pages.count - 1, currentPage + 1) } }) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
            }
            .disabled(currentPage == pages.count - 1)
            .opacity(currentPage == pages.count - 1 ? 0.3 : 1)
        }
        .buttonStyle(.plain)
    }
    
    private var mainContentCard: some View {
        CGDKEPaperCard {
            VStack(spacing: CGDKEPaperTokens.Space.lg) {
                // Large title
                Text(pages[currentPage])
                    .font(CGDKEPaperTokens.Typography.title())
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
                    .tracking(3)
                    .multilineTextAlignment(.center)
                
                // Subtitle based on current page
                Text(pageSubtitle)
                    .font(CGDKEPaperTokens.Typography.subheading())
                    .foregroundStyle(CGDKEPaperTokens.Color.inkLight)
                    .tracking(1)
                    .multilineTextAlignment(.center)
                
                // Description
                Text(pageDescription)
                    .font(CGDKEPaperTokens.Typography.body())
                    .foregroundStyle(CGDKEPaperTokens.Color.inkMuted)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, CGDKEPaperTokens.Space.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, CGDKEPaperTokens.Space.xl)
        }
    }
    
    private var timeSelectionCard: some View {
        CGDKEPaperCard(title: "TIME") {
            VStack(alignment: .leading, spacing: CGDKEPaperTokens.Space.md) {
                ForEach(timeOptions, id: \.self) { option in
                    Button(action: { selectedTime = option }) {
                        HStack {
                            Image(systemName: selectedTime == option ? "largecircle.fill.circle" : "circle")
                                .font(.caption)
                                .foregroundStyle(CGDKEPaperTokens.Color.ink)
                            
                            Text(option)
                                .font(CGDKEPaperTokens.Typography.body())
                                .foregroundStyle(CGDKEPaperTokens.Color.ink)
                            
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var lifestyleCard: some View {
        CGDKEPaperCard(title: "IGNORANCE") {
            VStack(alignment: .leading, spacing: CGDKEPaperTokens.Space.sm) {
                Text("NEW LIFE")
                    .font(CGDKEPaperTokens.Typography.subheading())
                    .foregroundStyle(CGDKEPaperTokens.Color.ink)
                
                Text(selectedLifestyle)
                    .font(CGDKEPaperTokens.Typography.body())
                    .foregroundStyle(CGDKEPaperTokens.Color.inkLight)
                
                Divider()
                    .background(CGDKEPaperTokens.Color.border)
                
                VStack(alignment: .leading, spacing: CGDKEPaperTokens.Space.xs) {
                    ForEach(lifestyleOptions, id: \.self) { option in
                        Button(action: { selectedLifestyle = option }) {
                            Text(option)
                                .font(CGDKEPaperTokens.Typography.caption())
                                .foregroundStyle(selectedLifestyle == option ? 
                                               CGDKEPaperTokens.Color.ink : 
                                               CGDKEPaperTokens.Color.inkMuted)
                                .underline(selectedLifestyle == option)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var interactiveSection: some View {
        VStack(spacing: CGDKEPaperTokens.Space.lg) {
            HStack(spacing: CGDKEPaperTokens.Space.md) {
                CGDKEPaperButton("EXPLORE", style: .primary) {
                    showDetail.toggle()
                }
                
                CGDKEPaperButton("RESET", style: .secondary) {
                    resetToDefaults()
                }
                
                CGDKEPaperButton("INFO", style: .minimal) {
                    // Show info
                }
            }
            
            // Status indicators
            HStack {
                statusIndicator("★", isActive: true)
                statusIndicator("✕", isActive: false)
                statusIndicator("◆", isActive: currentPage > 0)
                
                Spacer()
                
                Text("Be")
                    .font(CGDKEPaperTokens.Typography.label())
                    .foregroundStyle(CGDKEPaperTokens.Color.inkMuted)
            }
        }
    }
    
    private func statusIndicator(_ symbol: String, isActive: Bool) -> some View {
        Text(symbol)
            .font(CGDKEPaperTokens.Typography.body())
            .foregroundStyle(isActive ? CGDKEPaperTokens.Color.ink : CGDKEPaperTokens.Color.inkMuted)
    }
    
    private var pageSubtitle: String {
        switch pages[currentPage] {
        case "1989": return "THE BEGINNING"
        case "NAFIO": return "TRANSFORMATION"
        case "YOUR OLD TIME": return "REFLECTION"
        default: return "UNKNOWN"
        }
    }
    
    private var pageDescription: String {
        switch pages[currentPage] {
        case "1989": return "The year that changed everything. A moment in time when the world shifted and new possibilities emerged from the digital revolution."
        case "NAFIO": return "The evolution continues. From simple beginnings to complex realities, the transformation of ideas into tangible experiences."
        case "YOUR OLD TIME": return "Memories preserved in digital amber. The nostalgic pull of yesteryear meets the infinite potential of tomorrow."
        default: return "Every page tells a story."
        }
    }
    
    private func resetToDefaults() {
        currentPage = 0
        selectedTime = "TIME"
        selectedLifestyle = "FRESH"
    }
}



// MARK: - Preview
#Preview("E-Paper Main") {
    CGDKEPaperView()
}
