//
//  RetroDemo.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKRetroDemoView: View {
    @State private var selectedChoice = 0
    @State private var signature = ""
    @State private var phoneNumber = ""
    
    private let choices = [
        "In this line of text.",
        "There should be two lines of text here.",
        "Yes, here you need lines for 3-4. So that you can see the progression."
    ]
    
    public init() {}
    
    public var body: some View {
        CGDKRetroRoot {
            VStack(spacing: 0) {
                // Main Card Container
                CGDKRetroContainer {
                    VStack(spacing: 0) {
                        // Title Section
                        titleSection
                        
                        // For What Section
                        forWhatSection
                        
                        // Choose Section
                        chooseSection
                        
                        // Input Section
                        inputSection
                    }
                }
                .padding(CGDKRetroTokens.Space.lg)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var titleSection: some View {
        CGDKRetroSectionHeader("NEW CHOICE", style: .title)
    }
    
    private var forWhatSection: some View {
        VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.md) {
            // Section Header
            HStack {
                Text("For what?")
                    .font(CGDKRetroTokens.Font.heading())
                    .foregroundStyle(CGDKRetroTokens.Color.text)
                Spacer()
            }
            .padding(.horizontal, CGDKRetroTokens.Space.lg)
            .padding(.top, CGDKRetroTokens.Space.lg)
            
            // Description Text
            VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.sm) {
                Text("I do not know what to write,")
                Text("so I will just run the text")
                Text("through the translator.")
                Text("That should be enough.")
                Text("No, it wasn't enough, but now")
                Text("it should. Something like.")
            }
            .font(CGDKRetroTokens.Font.body())
            .foregroundStyle(CGDKRetroTokens.Color.textMuted)
            .padding(.horizontal, CGDKRetroTokens.Space.lg)
            .padding(.bottom, CGDKRetroTokens.Space.lg)
        }
        .background(CGDKRetroTokens.Color.screen)
        .overlay(
            Rectangle()
                .stroke(CGDKRetroTokens.Color.borderLight, lineWidth: CGDKRetroTokens.Border.thin)
        )
    }
    
    private var chooseSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Choose Header
            HStack {
                Text("Choose")
                    .font(CGDKRetroTokens.Font.heading())
                    .foregroundStyle(CGDKRetroTokens.Color.text)
                Spacer()
            }
            .padding(.horizontal, CGDKRetroTokens.Space.lg)
            .padding(.top, CGDKRetroTokens.Space.lg)
            .padding(.bottom, CGDKRetroTokens.Space.md)
            
            // Choice Options
            VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.xs) {
                ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                    CGDKRetroChoiceButton(
                        choice,
                        isSelected: selectedChoice == index
                    ) {
                        selectedChoice = index
                    }
                }
            }
            .padding(.horizontal, CGDKRetroTokens.Space.lg)
            
            // Your variant text
            HStack {
                Spacer()
                Text("Your variant")
                    .font(CGDKRetroTokens.Font.small())
                    .foregroundStyle(CGDKRetroTokens.Color.textMuted)
                    .italic()
                Spacer()
            }
            .padding(.top, CGDKRetroTokens.Space.lg)
            .padding(.bottom, CGDKRetroTokens.Space.lg)
        }
        .background(CGDKRetroTokens.Color.screen)
        .overlay(
            Rectangle()
                .stroke(CGDKRetroTokens.Color.borderLight, lineWidth: CGDKRetroTokens.Border.thin)
        )
    }
    
    private var inputSection: some View {
        HStack(spacing: 0) {
            // Signature Field
            VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.xs) {
                Text("Signature")
                    .font(CGDKRetroTokens.Font.caption())
                    .foregroundStyle(CGDKRetroTokens.Color.textMuted)
                
                TextField("", text: $signature)
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(CGDKRetroTokens.Color.text)
                    .padding(CGDKRetroTokens.Space.md)
                    .background(CGDKRetroTokens.Color.terminal)
                    .overlay(
                        Rectangle()
                            .stroke(CGDKRetroTokens.Color.border, lineWidth: CGDKRetroTokens.Border.thin)
                    )
            }
            .frame(maxWidth: .infinity)
            
            // Vertical Divider
            Rectangle()
                .fill(CGDKRetroTokens.Color.border)
                .frame(width: CGDKRetroTokens.Border.thin)
            
            // Your Number Field
            VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.xs) {
                Text("Your number")
                    .font(CGDKRetroTokens.Font.caption())
                    .foregroundStyle(CGDKRetroTokens.Color.textMuted)
                
                TextField("", text: $phoneNumber)
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(CGDKRetroTokens.Color.text)
                    .padding(CGDKRetroTokens.Space.md)
                    .background(CGDKRetroTokens.Color.terminal)
                    .overlay(
                        Rectangle()
                            .stroke(CGDKRetroTokens.Color.border, lineWidth: CGDKRetroTokens.Border.thin)
                    )
                    .keyboardType(.numberPad)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(CGDKRetroTokens.Space.lg)
        .background(CGDKRetroTokens.Color.screen)
        .overlay(
            Rectangle()
                .stroke(CGDKRetroTokens.Color.border, lineWidth: CGDKRetroTokens.Border.thin)
        )
    }
}

// MARK: - Additional Retro Components for flexibility

public struct CGDKRetroList<Item: Identifiable, ItemView: View>: View {
    private let items: [Item]
    private let itemView: (Item) -> ItemView
    
    public init(_ items: [Item], @ViewBuilder itemView: @escaping (Item) -> ItemView) {
        self.items = items
        self.itemView = itemView
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                itemView(item)
                    .padding(.vertical, CGDKRetroTokens.Space.sm)
                    .padding(.horizontal, CGDKRetroTokens.Space.md)
                    .overlay(
                        Rectangle()
                            .stroke(CGDKRetroTokens.Color.borderLight, lineWidth: CGDKRetroTokens.Border.thin)
                    )
            }
        }
    }
}

// MARK: - Previews
#Preview("Retro Demo") {
    CGDKRetroDemoView()
}

#Preview("Retro Components") {
    CGDKRetroRoot {
        VStack(spacing: CGDKRetroTokens.Space.lg) {
            CGDKRetroCard {
                VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.md) {
                    Text("RETRO COMPONENTS")
                        .font(CGDKRetroTokens.Font.title())
                        .foregroundStyle(CGDKRetroTokens.Color.text)
                    
                    Text("This is a retro-styled card component with monospace fonts and terminal aesthetics.")
                        .font(CGDKRetroTokens.Font.body())
                        .foregroundStyle(CGDKRetroTokens.Color.textMuted)
                }
            }
            
            CGDKRetroButton("PRIMARY BUTTON", style: CGDKRetroButton.Style.primary) {}
            CGDKRetroButton("SECONDARY BUTTON", style: CGDKRetroButton.Style.secondary) {}
            CGDKRetroButton("OUTLINE BUTTON", style: CGDKRetroButton.Style.outline) {}
            
            CGDKRetroTextField("Enter text...", text: .constant(""))
        }
        .padding(CGDKRetroTokens.Space.lg)
    }
}