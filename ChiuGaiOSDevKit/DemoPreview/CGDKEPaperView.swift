//
//  CGDKEPaperView.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - E-Paper Theme Tokens
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

// MARK: - E-Paper Card Component
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

// MARK: - E-Paper Button Component
public struct CGDKEPaperButton: View {
    let title: String
    let action: () -> Void
    let style: Style
    
    public enum Style {
        case primary
        case secondary
        case minimal
    }
    
    public init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(CGDKEPaperTokens.Typography.body())
                .tracking(0.5)
                .foregroundStyle(textColor)
                .padding(.horizontal, CGDKEPaperTokens.Space.lg)
                .padding(.vertical, CGDKEPaperTokens.Space.md)
                .background(backgroundColor)
                .overlay(
                    Rectangle()
                        .strokeBorder(borderColor, lineWidth: borderWidth)
                )
                .cornerRadius(CGDKEPaperTokens.Corner.sm)
        }
        .buttonStyle(.plain)
    }
    
    private var textColor: Color {
        switch style {
        case .primary: return CGDKEPaperTokens.Color.paper
        case .secondary: return CGDKEPaperTokens.Color.ink
        case .minimal: return CGDKEPaperTokens.Color.inkLight
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return CGDKEPaperTokens.Color.ink
        case .secondary: return CGDKEPaperTokens.Color.paper
        case .minimal: return Color.clear
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary: return CGDKEPaperTokens.Color.ink
        case .secondary: return CGDKEPaperTokens.Color.ink
        case .minimal: return CGDKEPaperTokens.Color.border
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary: return 2
        case .secondary: return 1.5
        case .minimal: return 1
        }
    }
}

// MARK: - E-Paper Navigation Component
public struct CGDKEPaperNavigation: View {
    let currentPage: Int
    let totalPages: Int
    let onPageChange: (Int) -> Void
    
    public init(currentPage: Int, totalPages: Int, onPageChange: @escaping (Int) -> Void) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.onPageChange = onPageChange
    }
    
    public var body: some View {
        HStack(spacing: CGDKEPaperTokens.Space.sm) {
            ForEach(0..<totalPages, id: \.self) { index in
                Button(action: { onPageChange(index) }) {
                    Circle()
                        .fill(index == currentPage ? CGDKEPaperTokens.Color.ink : CGDKEPaperTokens.Color.border)
                        .frame(width: 8, height: 8)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

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

// MARK: - Detail View for Full Experience
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

// MARK: - Complete E-Paper Experience
public struct CGDKEPaperCompleteView: View {
    @State private var showDetail = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            CGDKEPaperView()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showDetail) {
            CGDKEPaperDetailView(isPresented: $showDetail)
        }
    }
}

// MARK: - Preview
#Preview("E-Paper Main") {
    CGDKEPaperView()
}

#Preview("E-Paper Complete") {
    CGDKEPaperCompleteView()
}

#Preview("E-Paper Detail") {
    CGDKEPaperDetailView(isPresented: .constant(true))
}