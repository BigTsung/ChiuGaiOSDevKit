//
//  CGDKLayoutHelpers.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Spacing Components
public struct CGDKSpacer: View {
    public enum Size {
        case xs, sm, md, lg, xl, xxl
        case custom(CGFloat)
        
        var value: CGFloat {
            switch self {
            case .xs: return CGDKTokens.Space.xs
            case .sm: return CGDKTokens.Space.sm
            case .md: return CGDKTokens.Space.md
            case .lg: return CGDKTokens.Space.lg
            case .xl: return CGDKTokens.Space.xl
            case .xxl: return CGDKTokens.Space.xxl
            case .custom(let value): return value
            }
        }
    }
    
    private let size: Size
    private let isVertical: Bool
    
    public init(_ size: Size = .md, vertical: Bool = true) {
        self.size = size
        self.isVertical = vertical
    }
    
    public var body: some View {
        if isVertical {
            Rectangle()
                .fill(Color.clear)
                .frame(height: size.value)
        } else {
            Rectangle()
                .fill(Color.clear)
                .frame(width: size.value)
        }
    }
}

// MARK: - Divider Components
public struct CGDKDivider: View {
    @EnvironmentObject private var tm: CGDKThemeManager
    
    private let thickness: CGFloat
    private let isVertical: Bool
    
    public init(thickness: CGFloat = 1, vertical: Bool = false) {
        self.thickness = thickness
        self.isVertical = vertical
    }
    
    public var body: some View {
        Rectangle()
            .fill(tm.theme.colors.line)
            .frame(
                width: isVertical ? thickness : nil,
                height: isVertical ? nil : thickness
            )
    }
}

// MARK: - Container Components
public struct CGDKVStack<Content: View>: View {
    private let spacing: CGDKSpacer.Size
    private let alignment: HorizontalAlignment
    private let content: Content
    
    public init(
        spacing: CGDKSpacer.Size = .md,
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.alignment = alignment
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: alignment, spacing: spacing.value) {
            content
        }
    }
}

public struct CGDKHStack<Content: View>: View {
    private let spacing: CGDKSpacer.Size
    private let alignment: VerticalAlignment
    private let content: Content
    
    public init(
        spacing: CGDKSpacer.Size = .md,
        alignment: VerticalAlignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.alignment = alignment
        self.content = content()
    }
    
    public var body: some View {
        HStack(alignment: alignment, spacing: spacing.value) {
            content
        }
    }
}

// MARK: - Layout Modifiers
public extension View {
    func cgdkPadding(_ size: CGDKSpacer.Size = .md) -> some View {
        padding(size.value)
    }
    
    func cgdkPadding(_ edges: Edge.Set, _ size: CGDKSpacer.Size = .md) -> some View {
        padding(edges, size.value)
    }
    
    func cgdkFrame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        self.frame(
            minWidth: minWidth,
            idealWidth: width,
            maxWidth: maxWidth,
            minHeight: minHeight,
            idealHeight: height,
            maxHeight: maxHeight,
            alignment: alignment
        )
    }
}

// MARK: - Common Layout Patterns
public struct CGDKSection<Header: View, Content: View>: View {
    @EnvironmentObject private var tm: CGDKThemeManager
    
    private let header: Header
    private let content: Content
    
    public init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.content = content()
    }
    
    public var body: some View {
        CGDKVStack(spacing: .sm, alignment: .leading) {
            header
            content
        }
        .cgdkPadding(.lg)
        .background(tm.theme.colors.card)
        .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.lg, style: .continuous))
    }
}

public struct CGDKListRow<Content: View>: View {
    @EnvironmentObject private var tm: CGDKThemeManager
    
    private let content: Content
    private let action: (() -> Void)?
    
    public init(action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    public var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    rowContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                rowContent
            }
        }
    }
    
    private var rowContent: some View {
        content
            .cgdkPadding(.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(tm.theme.colors.card)
            .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.md, style: .continuous))
    }
}

public struct CGDKGrid<Content: View>: View {
    private let columns: [GridItem]
    private let spacing: CGFloat
    private let content: Content
    
    public init(
        columns: Int = 2,
        spacing: CGDKSpacer.Size = .md,
        @ViewBuilder content: () -> Content
    ) {
        self.columns = Array(repeating: GridItem(.flexible()), count: columns)
        self.spacing = spacing.value
        self.content = content()
    }
    
    public var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            content
        }
    }
}