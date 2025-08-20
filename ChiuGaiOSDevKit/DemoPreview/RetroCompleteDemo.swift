//
//  RetroCompleteDemo.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKRetroCompleteDemoView: View {
    @State private var currentColorScheme: CGDKRetroTokens.ColorScheme = .classic
    @State private var isToggleOn = false
    @State private var progress: Double = 0.7
    @State private var sliderValue: Double = 50
    @State private var selectedOption = "Option 1"
    @State private var showAlert = false
    @State private var animatedProgress: Double = 0
    
    private let colorSchemes: [CGDKRetroTokens.ColorScheme] = [.classic, .amber, .green, .blue, .white, .matrix]
    private let options = ["Option 1", "Option 2", "Option 3", "Debug Mode"]
    
    public init() {}
    
    public var body: some View {
        CGDKRetroRoot(colorScheme: currentColorScheme) {
            ScrollView {
                VStack(spacing: CGDKRetroTokens.Space.lg) {
                    // Header
                    headerSection
                    
                    // Color Scheme Selector
                    colorSchemeSection
                    
                    // UI Components Demo
                    toggleSection
                    progressSection
                    sliderSection
                    pickerSection
                    buttonsSection
                    
                    Spacer(minLength: CGDKRetroTokens.Space.xxl)
                }
                .padding(CGDKRetroTokens.Space.lg)
            }
        }
        .overlay {
            if showAlert {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showAlert = false
                    }
                
                CGDKRetroAlert(
                    title: "System Alert",
                    message: "This is a demonstration of the retro alert component with terminal styling.",
                    primaryButton: "ACCEPT",
                    secondaryButton: "CANCEL",
                    colorScheme: currentColorScheme,
                    primaryAction: {
                        showAlert = false
                    },
                    secondaryAction: {
                        showAlert = false
                    }
                )
            }
        }
        .onAppear {
            startProgressAnimation()
        }
    }
    
    private var headerSection: some View {
        CGDKRetroContainer(title: "RETRO UI DEMO") {
            VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.md) {
                Text("TERMINAL INTERFACE COMPONENTS")
                    .font(CGDKRetroTokens.Font.heading())
                    .foregroundStyle(CGDKRetroTokens.Color.colors(for: currentColorScheme).text)
                
                Text("Demonstrating various UI components with retro terminal styling and multiple color schemes.")
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(CGDKRetroTokens.Color.colors(for: currentColorScheme).textMuted)
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var colorSchemeSection: some View {
        CGDKRetroContainer(title: "COLOR SCHEMES") {
            VStack(spacing: CGDKRetroTokens.Space.md) {
                CGDKRetroPicker(
                    "Select Theme",
                    selection: $currentColorScheme,
                    options: colorSchemes,
                    colorScheme: currentColorScheme
                ) { scheme in
                    switch scheme {
                    case .classic: return "CLASSIC"
                    case .amber: return "AMBER"
                    case .green: return "GREEN"
                    case .blue: return "BLUE"
                    case .white: return "WHITE"
                    case .matrix: return "MATRIX"
                    }
                }
                
                // Color Scheme Info
                VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.xs) {
                    Text("Current: \(colorSchemeName)")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(CGDKRetroTokens.Color.colors(for: currentColorScheme).accent)
                    
                    Text(colorSchemeDescription)
                        .font(CGDKRetroTokens.Font.small())
                        .foregroundStyle(CGDKRetroTokens.Color.colors(for: currentColorScheme).textMuted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var toggleSection: some View {
        CGDKRetroContainer(title: "TOGGLE CONTROLS") {
            VStack(spacing: CGDKRetroTokens.Space.lg) {
                CGDKRetroToggle("System Power", isOn: $isToggleOn, colorScheme: currentColorScheme)
                
                CGDKRetroToggle("Debug Mode", isOn: .constant(true), colorScheme: currentColorScheme)
                
                CGDKRetroToggle("Network", isOn: .constant(false), colorScheme: currentColorScheme)
                
                // Status Display
                HStack {
                    Text("STATUS:")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(CGDKRetroTokens.Color.colors(for: currentColorScheme).textMuted)
                    
                    Text(isToggleOn ? "ONLINE" : "OFFLINE")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(isToggleOn ? 
                                       CGDKRetroTokens.Color.colors(for: currentColorScheme).accent : 
                                       CGDKRetroTokens.Color.colors(for: currentColorScheme).textMuted)
                    
                    Spacer()
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var progressSection: some View {
        CGDKRetroContainer(title: "PROGRESS INDICATORS") {
            VStack(spacing: CGDKRetroTokens.Space.lg) {
                CGDKRetroProgress(
                    "System Loading",
                    progress: progress,
                    style: .bar,
                    colorScheme: currentColorScheme
                )
                
                CGDKRetroProgress(
                    "Data Transfer",
                    progress: animatedProgress,
                    style: .ascii,
                    colorScheme: currentColorScheme
                )
                
                CGDKRetroProgress(
                    "Processing",
                    progress: 0.3,
                    style: .dots,
                    showPercentage: false,
                    colorScheme: currentColorScheme
                )
                
                CGDKRetroProgress(
                    "Initializing",
                    progress: 0.9,
                    style: .loading,
                    colorScheme: currentColorScheme
                )
                
                // Manual Progress Control
                HStack {
                    CGDKRetroButton("RESET", style: CGDKRetroButton.Style.outline) {
                        progress = 0
                    }
                    
                    CGDKRetroButton("+10%", style: .secondary) {
                        progress = min(1.0, progress + 0.1)
                    }
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var sliderSection: some View {
        CGDKRetroContainer(title: "SLIDERS") {
            VStack(spacing: CGDKRetroTokens.Space.lg) {
                CGDKRetroSlider(
                    "Volume",
                    value: $sliderValue,
                    in: 0...100,
                    colorScheme: currentColorScheme
                )
                
                CGDKRetroSlider(
                    "Brightness",
                    value: .constant(75),
                    in: 0...100,
                    colorScheme: currentColorScheme
                )
                
                CGDKRetroSlider(
                    "Speed",
                    value: .constant(33),
                    in: 0...50,
                    width: 150,
                    colorScheme: currentColorScheme
                )
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var pickerSection: some View {
        CGDKRetroContainer(title: "SELECTION") {
            VStack(spacing: CGDKRetroTokens.Space.lg) {
                CGDKRetroPicker(
                    "Mode Selection",
                    selection: $selectedOption,
                    options: options,
                    colorScheme: currentColorScheme
                )
                
                // Selected info
                HStack {
                    Text("SELECTED:")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(CGDKRetroTokens.Color.colors(for: currentColorScheme).textMuted)
                    
                    Text(selectedOption.uppercased())
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(CGDKRetroTokens.Color.colors(for: currentColorScheme).accent)
                    
                    Spacer()
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var buttonsSection: some View {
        CGDKRetroContainer(title: "ACTIONS") {
            VStack(spacing: CGDKRetroTokens.Space.md) {
                CGDKRetroButton("EXECUTE COMMAND", style: CGDKRetroButton.Style.primary) {
                    // Primary action
                }
                
                HStack(spacing: CGDKRetroTokens.Space.md) {
                    CGDKRetroButton("CANCEL", style: CGDKRetroButton.Style.outline) {
                        // Cancel action
                    }
                    
                    CGDKRetroButton("ALERT", style: .secondary) {
                        showAlert = true
                    }
                }
                
                CGDKRetroButton("RESTART SYSTEM", style: CGDKRetroButton.Style.outline) {
                    resetAllStates()
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    // Helper computed properties
    private var colorSchemeName: String {
        switch currentColorScheme {
        case .classic: return "CLASSIC WHITE/GREEN"
        case .amber: return "AMBER TERMINAL"
        case .green: return "GREEN MONITOR"
        case .blue: return "BLUE SCREEN"
        case .white: return "WHITE PAPER"
        case .matrix: return "MATRIX GREEN"
        }
    }
    
    private var colorSchemeDescription: String {
        switch currentColorScheme {
        case .classic: return "Traditional terminal with white text and green accents"
        case .amber: return "Vintage amber phosphor monitor style"
        case .green: return "Classic green screen computer terminal"
        case .blue: return "Blue tinted modern terminal interface"
        case .white: return "High contrast black on white display"
        case .matrix: return "Matrix-style bright green digital rain"
        }
    }
    
    // Helper functions
    private func startProgressAnimation() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: true)) {
            animatedProgress = 1.0
        }
    }
    
    private func resetAllStates() {
        isToggleOn = false
        progress = 0.0
        sliderValue = 50
        selectedOption = options[0]
        animatedProgress = 0
        startProgressAnimation()
    }
}

// MARK: - Color Scheme Showcase
public struct CGDKRetroColorSchemesView: View {
    public init() {}
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: CGDKRetroTokens.Space.lg) {
                ForEach([CGDKRetroTokens.ColorScheme.classic, .amber, .green, .blue, .white, .matrix], id: \.self) { scheme in
                    colorSchemeCard(scheme)
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    private func colorSchemeCard(_ scheme: CGDKRetroTokens.ColorScheme) -> some View {
        CGDKRetroRoot(colorScheme: scheme) {
            CGDKRetroContainer(title: schemeName(scheme)) {
                VStack(spacing: CGDKRetroTokens.Space.md) {
                    CGDKRetroProgress("Loading", progress: 0.6, colorScheme: scheme)
                    CGDKRetroToggle("Power", isOn: .constant(true), colorScheme: scheme)
                    CGDKRetroButton("TEST", style: CGDKRetroButton.Style.primary) {}
                }
                .padding(CGDKRetroTokens.Space.md)
            }
            .frame(height: 200)
        }
    }
    
    private func schemeName(_ scheme: CGDKRetroTokens.ColorScheme) -> String {
        switch scheme {
        case .classic: return "CLASSIC"
        case .amber: return "AMBER"
        case .green: return "GREEN" 
        case .blue: return "BLUE"
        case .white: return "WHITE"
        case .matrix: return "MATRIX"
        }
    }
}

// MARK: - Previews
#Preview("Complete Retro Demo") {
    CGDKRetroCompleteDemoView()
}

#Preview("Color Schemes") {
    CGDKRetroColorSchemesView()
}

#Preview("Individual Components") {
    CGDKRetroRoot(colorScheme: .amber) {
        VStack(spacing: CGDKRetroTokens.Space.lg) {
            CGDKRetroToggle("Test Toggle", isOn: .constant(true), colorScheme: .amber)
            CGDKRetroProgress("Progress", progress: 0.75, style: .ascii, colorScheme: .amber)
            CGDKRetroSlider("Slider", value: .constant(60), colorScheme: .amber)
            CGDKRetroPicker("Picker", selection: .constant("A"), options: ["A", "B", "C"], colorScheme: .amber)
        }
        .padding()
    }
}