//
//  Components.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

public struct CGDKButton: View {
    public enum Style { case primary, ghost, danger }
    let title: String; let style: Style; let action: () -> Void
    @EnvironmentObject var tm: CGDKThemeManager
    public init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title; self.style = style; self.action = action
    }
    public var body: some View {
        Button(action: action) {
            Text(title).font(CGDKTokens.Font.body(16))
                .padding(.vertical, CGDKTokens.Space.md)
                .padding(.horizontal, CGDKTokens.Space.xl)
                .frame(maxWidth: .infinity)
        }
        .background(background)
        .foregroundStyle(foreground)
        .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.md, style: .continuous))
        .overlay {
            if style == .ghost {
                RoundedRectangle(cornerRadius: tm.theme.radius.md)
                    .stroke(tm.theme.colors.brand.opacity(0.4), lineWidth: 1)
            }
        }
    }
    private var background: some ShapeStyle {
        switch style {
        case .primary: tm.theme.colors.brand
        case .danger:  tm.theme.colors.danger
        case .ghost:   Color.clear
        }
    }
    private var foreground: Color { style == .ghost ? tm.theme.colors.brand : .white }
}

public struct CGDKCard<Content: View>: View {
    @EnvironmentObject var tm: CGDKThemeManager
    let content: Content
    public init(@ViewBuilder _ c: ()->Content){ self.content = c() }
    public var body: some View {
        content
            .padding(CGDKTokens.Space.lg)
            .background(tm.theme.colors.card)
            .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.lg, style: .continuous))
    }
}

public struct CGDKSectionHeader: View {
    let title: String; let sub: String?
    public init(_ title: String, sub: String? = nil){ self.title = title; self.sub = sub }
    public var body: some View {
        HStack {
            Text(title).font(CGDKTokens.Font.title())
            Spacer()
            if let s = sub { Text(s).font(CGDKTokens.Font.caption()).foregroundStyle(CGDKTokens.Color.muted) }
        }
        .padding(.horizontal, CGDKTokens.Space.xl)
        .padding(.top, CGDKTokens.Space.lg)
    }
}

// MARK: - Loading Components
public struct CGDKLoadingIndicator: View {
    @State private var isAnimating = false
    
    private let size: CGFloat
    private let lineWidth: CGFloat
    
    public init(size: CGFloat = 24, lineWidth: CGFloat = 3) {
        self.size = size
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(CGDKTokens.Color.brand, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear { isAnimating = true }
    }
}

public struct CGDKLoadingButton: View {
    let title: String
    let isLoading: Bool
    let style: CGDKButton.Style
    let action: () -> Void
    
    @EnvironmentObject var tm: CGDKThemeManager
    
    public init(_ title: String, isLoading: Bool = false, style: CGDKButton.Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: isLoading ? {} : action) {
            HStack(spacing: CGDKTokens.Space.sm) {
                if isLoading {
                    CGDKLoadingIndicator(size: 16, lineWidth: 2)
                        .foregroundStyle(.white)
                }
                Text(isLoading ? "Loading..." : title)
                    .font(CGDKTokens.Font.body(16))
            }
            .padding(.vertical, CGDKTokens.Space.md)
            .padding(.horizontal, CGDKTokens.Space.xl)
            .frame(maxWidth: .infinity)
        }
        .background(isLoading ? AnyShapeStyle(tm.theme.colors.muted) : AnyShapeStyle(backgroundStyle))
        .foregroundStyle(isLoading ? .white : foregroundStyle)
        .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.md, style: .continuous))
        .overlay {
            if style == .ghost && !isLoading {
                RoundedRectangle(cornerRadius: tm.theme.radius.md)
                    .stroke(tm.theme.colors.brand.opacity(0.4), lineWidth: 1)
            }
        }
        .disabled(isLoading)
    }
    
    private var backgroundStyle: some ShapeStyle {
        switch style {
        case .primary: tm.theme.colors.brand
        case .danger: tm.theme.colors.danger
        case .ghost: Color.clear
        }
    }
    
    private var foregroundStyle: Color {
        style == .ghost ? tm.theme.colors.brand : .white
    }
}

// MARK: - Text Input Components
public struct CGDKTextField: View {
    @Binding private var text: String
    @State private var errorMessage: String?
    @FocusState private var isFocused: Bool
    
    private let placeholder: String
    private let isSecure: Bool
    private let validationRules: [CGDKValidationRule]
    private let onCommit: (() -> Void)?
    
    @EnvironmentObject var tm: CGDKThemeManager
    
    public init(
        _ placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        validationRules: [CGDKValidationRule] = [],
        onCommit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.validationRules = validationRules
        self.onCommit = onCommit
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CGDKTokens.Space.xs) {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .focused($isFocused)
            .font(CGDKTokens.Font.body())
            .padding(CGDKTokens.Space.md)
            .background(tm.theme.colors.card)
            .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: tm.theme.radius.sm)
                    .stroke(borderColor, lineWidth: 1)
            )
            .onSubmit {
                validateInput()
                onCommit?()
            }
            .onChange(of: text) { _, _ in
                if errorMessage != nil {
                    validateInput()
                }
            }
            
            if let error = errorMessage {
                Text(error)
                    .font(CGDKTokens.Font.caption())
                    .foregroundStyle(tm.theme.colors.danger)
            }
        }
    }
    
    private var borderColor: Color {
        if let _ = errorMessage {
            return tm.theme.colors.danger
        } else if isFocused {
            return tm.theme.colors.brand
        } else {
            return tm.theme.colors.line
        }
    }
    
    private func validateInput() {
        let result = CGDKValidator.validate(text, rules: validationRules)
        switch result {
        case .success:
            errorMessage = nil
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Image Components
public struct CGDKAsyncImage: View {
    private let url: URL?
    private let placeholder: AnyView
    
    public init(url: URL?, @ViewBuilder placeholder: () -> some View = { Color.gray.opacity(0.3) }) {
        self.url = url
        self.placeholder = AnyView(placeholder())
    }
    
    public var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            placeholder
        }
    }
}

public struct CGDKAvatar: View {
    private let imageURL: URL?
    private let name: String
    private let size: CGFloat
    
    @EnvironmentObject var tm: CGDKThemeManager
    
    public init(imageURL: URL? = nil, name: String, size: CGFloat = 40) {
        self.imageURL = imageURL
        self.name = name
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(tm.theme.colors.brand)
                .frame(width: size, height: size)
            
            if let imageURL = imageURL {
                CGDKAsyncImage(url: imageURL) {
                    Circle()
                        .fill(tm.theme.colors.muted)
                }
                .frame(width: size, height: size)
                .clipShape(Circle())
            } else {
                Text(initials)
                    .font(.system(size: size * 0.4, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
    }
    
    private var initials: String {
        let words = name.split(separator: " ")
        if words.count >= 2 {
            return String(words[0].prefix(1) + words[1].prefix(1)).uppercased()
        } else {
            return String(name.prefix(2)).uppercased()
        }
    }
}

// MARK: - List Components
public struct CGDKList<Item: Identifiable, ItemView: View>: View {
    private let items: [Item]
    private let itemView: (Item) -> ItemView
    
    public init(_ items: [Item], @ViewBuilder itemView: @escaping (Item) -> ItemView) {
        self.items = items
        self.itemView = itemView
    }
    
    public var body: some View {
        LazyVStack(spacing: CGDKTokens.Space.sm) {
            ForEach(items) { item in
                itemView(item)
            }
        }
    }
}

public struct CGDKEmptyState: View {
    private let title: String
    private let subtitle: String?
    private let systemImage: String
    private let action: (() -> Void)?
    private let actionTitle: String?
    
    @EnvironmentObject var tm: CGDKThemeManager
    
    public init(
        title: String,
        subtitle: String? = nil,
        systemImage: String = "tray",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: CGDKTokens.Space.lg) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(tm.theme.colors.muted)
            
            VStack(spacing: CGDKTokens.Space.sm) {
                Text(title)
                    .font(CGDKTokens.Font.title())
                    .foregroundStyle(tm.theme.colors.text)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(CGDKTokens.Font.body())
                        .foregroundStyle(tm.theme.colors.muted)
                        .multilineTextAlignment(.center)
                }
            }
            
            if let actionTitle = actionTitle, let action = action {
                CGDKButton(actionTitle, style: .ghost, action: action)
                    .frame(maxWidth: 200)
            }
        }
        .padding(CGDKTokens.Space.xxl)
    }
}
