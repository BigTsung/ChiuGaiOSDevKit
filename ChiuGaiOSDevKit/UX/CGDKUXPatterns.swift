//
//  CGDKUXPatterns.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI
import Combine

// MARK: - Alert System
public struct CGDKAlertData: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let primaryButton: CGDKAlertButton
    public let secondaryButton: CGDKAlertButton?
    
    public init(
        title: String,
        message: String? = nil,
        primaryButton: CGDKAlertButton,
        secondaryButton: CGDKAlertButton? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}

public struct CGDKAlertButton {
    public let title: String
    public let style: Style
    public let action: () -> Void
    
    public enum Style {
        case `default`, destructive, cancel
    }
    
    public init(title: String, style: Style = .default, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = style
        self.action = action
    }
}

@MainActor
public final class CGDKAlertManager: ObservableObject {
    @Published public var currentAlert: CGDKAlertData?
    
    public init() {}
    
    public func show(_ alert: CGDKAlertData) {
        currentAlert = alert
    }
    
    public func dismiss() {
        currentAlert = nil
    }
}

public struct CGDKAlertHost<Content: View>: View {
    @ObservedObject var alertManager: CGDKAlertManager
    let content: Content
    @EnvironmentObject var tm: CGDKThemeManager
    
    public init(alertManager: CGDKAlertManager, @ViewBuilder content: () -> Content) {
        self.alertManager = alertManager
        self.content = content()
    }
    
    public var body: some View {
        content
            .overlay {
                if let alert = alertManager.currentAlert {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                alertManager.dismiss()
                            }
                        
                        VStack(spacing: CGDKTokens.Space.lg) {
                            VStack(spacing: CGDKTokens.Space.sm) {
                                Text(alert.title)
                                    .font(CGDKTokens.Font.title(18))
                                    .foregroundStyle(tm.theme.colors.text)
                                
                                if let message = alert.message {
                                    Text(message)
                                        .font(CGDKTokens.Font.body())
                                        .foregroundStyle(tm.theme.colors.muted)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            
                            VStack(spacing: CGDKTokens.Space.sm) {
                                CGDKButton(alert.primaryButton.title, style: buttonStyle(alert.primaryButton.style)) {
                                    alert.primaryButton.action()
                                    alertManager.dismiss()
                                }
                                
                                if let secondary = alert.secondaryButton {
                                    CGDKButton(secondary.title, style: buttonStyle(secondary.style)) {
                                        secondary.action()
                                        alertManager.dismiss()
                                    }
                                }
                            }
                        }
                        .padding(CGDKTokens.Space.xl)
                        .background(tm.theme.colors.card)
                        .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.lg))
                        .padding(CGDKTokens.Space.xl)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: alertManager.currentAlert != nil)
    }
    
    private func buttonStyle(_ style: CGDKAlertButton.Style) -> CGDKButton.Style {
        switch style {
        case .default: return .primary
        case .destructive: return .danger
        case .cancel: return .ghost
        }
    }
}

// MARK: - Action Sheet
public struct CGDKActionSheetItem {
    public let title: String
    public let style: Style
    public let action: () -> Void
    
    public enum Style {
        case `default`, destructive
    }
    
    public init(title: String, style: Style = .default, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
}

public struct CGDKActionSheet: View {
    @Binding var isPresented: Bool
    let title: String?
    let items: [CGDKActionSheetItem]
    
    @EnvironmentObject var tm: CGDKThemeManager
    
    public init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        items: [CGDKActionSheetItem]
    ) {
        self._isPresented = isPresented
        self.title = title
        self.items = items
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if let title = title {
                Text(title)
                    .font(CGDKTokens.Font.body())
                    .foregroundStyle(tm.theme.colors.muted)
                    .padding(CGDKTokens.Space.lg)
                    .frame(maxWidth: .infinity)
                    .background(tm.theme.colors.card.opacity(0.5))
            }
            
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Button(action: {
                    item.action()
                    isPresented = false
                }) {
                    Text(item.title)
                        .font(CGDKTokens.Font.body())
                        .foregroundStyle(item.style == .destructive ? tm.theme.colors.danger : tm.theme.colors.text)
                        .padding(CGDKTokens.Space.lg)
                        .frame(maxWidth: .infinity)
                        .background(tm.theme.colors.card)
                }
                .buttonStyle(PlainButtonStyle())
                
                if index < items.count - 1 {
                    CGDKDivider()
                }
            }
            
            CGDKSpacer(.sm)
            
            Button("取消") {
                isPresented = false
            }
            .font(CGDKTokens.Font.body())
            .foregroundStyle(tm.theme.colors.brand)
            .padding(CGDKTokens.Space.lg)
            .frame(maxWidth: .infinity)
            .background(tm.theme.colors.card)
        }
        .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.lg))
        .padding(CGDKTokens.Space.lg)
    }
}

// MARK: - Bottom Sheet
public struct CGDKBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    @EnvironmentObject var tm: CGDKThemeManager
    @State private var dragOffset: CGFloat = 0
    
    public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
                
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(tm.theme.colors.muted)
                        .frame(width: 36, height: 4)
                        .padding(.top, CGDKTokens.Space.sm)
                    
                    content
                        .padding(.top, CGDKTokens.Space.lg)
                }
                .background(tm.theme.colors.card)
                .clipShape(RoundedRectangle(cornerRadius: tm.theme.radius.xl, style: .continuous))
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 100 {
                                isPresented = false
                            }
                            dragOffset = 0
                        }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isPresented)
        .animation(.interactiveSpring(), value: dragOffset)
    }
}

// MARK: - Pull to Refresh
public struct CGDKRefreshableScrollView<Content: View>: View {
    let onRefresh: () async -> Void
    let content: Content
    
    public init(onRefresh: @escaping () async -> Void, @ViewBuilder content: () -> Content) {
        self.onRefresh = onRefresh
        self.content = content()
    }
    
    public var body: some View {
        ScrollView {
            content
        }
        .refreshable {
            await onRefresh()
        }
    }
}

// MARK: - View Extensions for UX Patterns
public extension View {
    func cgdkAlert(manager: CGDKAlertManager) -> some View {
        CGDKAlertHost(alertManager: manager) {
            self
        }
    }
    
    func cgdkActionSheet(
        isPresented: Binding<Bool>,
        title: String? = nil,
        items: [CGDKActionSheetItem]
    ) -> some View {
        overlay {
            if isPresented.wrappedValue {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isPresented.wrappedValue = false
                        }
                    
                    VStack {
                        Spacer()
                        CGDKActionSheet(isPresented: isPresented, title: title, items: items)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isPresented.wrappedValue)
            }
        }
    }
    
    func cgdkBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> SheetContent
    ) -> some View {
        overlay {
            CGDKBottomSheet(isPresented: isPresented, content: content)
        }
    }
}