//
//  CGDKNavigation.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI
import Foundation
import Combine

// MARK: - Navigation Destination Protocol
public protocol CGDKNavigationDestination: Hashable, Identifiable {
    var id: String { get }
    var title: String { get }
}

// MARK: - Navigation Coordinator
@MainActor
public final class CGDKNavigationCoordinator: ObservableObject {
    @Published public var navigationPath = NavigationPath()
    @Published public var presentedSheet: (any CGDKNavigationDestination)?
    @Published public var presentedFullScreenCover: (any CGDKNavigationDestination)?
    @Published public var alertItem: CGDKAlertData?
    
    private var navigationHistory: [any CGDKNavigationDestination] = []
    
    public init() {}
    
    // MARK: - Push Navigation
    public func push(_ destination: any CGDKNavigationDestination) {
        navigationPath.append(destination)
        navigationHistory.append(destination)
        CGDKLogDebug("Navigated to: \(destination.title)")
    }
    
    public func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
            if !navigationHistory.isEmpty {
                let destination = navigationHistory.removeLast()
                CGDKLogDebug("Popped from: \(destination.title)")
            }
        }
    }
    
    public func popToRoot() {
        navigationPath = NavigationPath()
        navigationHistory.removeAll()
        CGDKLogDebug("Popped to root")
    }
    
    public func popTo(_ destination: any CGDKNavigationDestination) {
        guard let index = navigationHistory.firstIndex(where: { $0.id == destination.id }) else {
            return
        }
        
        let itemsToRemove = navigationHistory.count - index - 1
        for _ in 0..<itemsToRemove {
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }
        
        navigationHistory = Array(navigationHistory.prefix(index + 1))
        CGDKLogDebug("Popped to: \(destination.title)")
    }
    
    // MARK: - Sheet Navigation
    public func presentSheet(_ destination: any CGDKNavigationDestination) {
        presentedSheet = destination
        CGDKLogDebug("Presented sheet: \(destination.title)")
    }
    
    public func dismissSheet() {
        if let sheet = presentedSheet {
            CGDKLogDebug("Dismissed sheet: \(sheet.title)")
        }
        presentedSheet = nil
    }
    
    // MARK: - Full Screen Cover Navigation
    public func presentFullScreenCover(_ destination: any CGDKNavigationDestination) {
        presentedFullScreenCover = destination
        CGDKLogDebug("Presented full screen cover: \(destination.title)")
    }
    
    public func dismissFullScreenCover() {
        if let cover = presentedFullScreenCover {
            CGDKLogDebug("Dismissed full screen cover: \(cover.title)")
        }
        presentedFullScreenCover = nil
    }
    
    // MARK: - Alert Navigation
    public func presentAlert(_ alert: CGDKAlertData) {
        alertItem = alert
        CGDKLogDebug("Presented alert: \(alert.title)")
    }
    
    public func dismissAlert() {
        alertItem = nil
    }
    
    // MARK: - Navigation State
    public var canGoBack: Bool {
        !navigationPath.isEmpty
    }
    
    public var currentDestination: (any CGDKNavigationDestination)? {
        navigationHistory.last
    }
    
    public func isCurrentDestination(_ destination: any CGDKNavigationDestination) -> Bool {
        currentDestination?.id == destination.id
    }
}

// MARK: - Deep Link Manager
@MainActor
public final class CGDKDeepLinkManager: ObservableObject {
    public static let shared = CGDKDeepLinkManager()
    
    @Published public var pendingDeepLink: CGDKDeepLink?
    
    private var coordinator: CGDKNavigationCoordinator?
    private var handlers: [String: (CGDKDeepLink) -> Bool] = [:]
    
    private init() {}
    
    public func setCoordinator(_ coordinator: CGDKNavigationCoordinator) {
        self.coordinator = coordinator
    }
    
    public func registerHandler(for scheme: String, handler: @escaping (CGDKDeepLink) -> Bool) {
        handlers[scheme] = handler
        CGDKLogDebug("Registered deep link handler for scheme: \(scheme)")
    }
    
    public func handle(_ url: URL) -> Bool {
        guard let deepLink = CGDKDeepLink(url: url) else {
            CGDKLogWarning("Failed to parse deep link: \(url)")
            return false
        }
        
        return handle(deepLink)
    }
    
    public func handle(_ deepLink: CGDKDeepLink) -> Bool {
        CGDKLogInfo("Handling deep link: \(deepLink.url)")
        
        // Try registered handlers first
        if let handler = handlers[deepLink.scheme] {
            if handler(deepLink) {
                return true
            }
        }
        
        // If no coordinator is available, store for later
        guard let coordinator = coordinator else {
            pendingDeepLink = deepLink
            return true
        }
        
        // Handle common deep link patterns
        return handleCommonPatterns(deepLink, coordinator: coordinator)
    }
    
    private func handleCommonPatterns(_ deepLink: CGDKDeepLink, coordinator: CGDKNavigationCoordinator) -> Bool {
        // Example: app://user/123
        if deepLink.host == "user", let userId = deepLink.pathComponents.first {
            // Navigate to user profile
            CGDKLogDebug("Navigating to user: \(userId)")
            // coordinator.push(UserProfileDestination(userId: userId))
            return true
        }
        
        // Example: app://settings
        if deepLink.host == "settings" {
            // Navigate to settings
            CGDKLogDebug("Navigating to settings")
            // coordinator.push(SettingsDestination())
            return true
        }
        
        return false
    }
    
    public func processPendingDeepLink() {
        guard let pendingLink = pendingDeepLink else { return }
        
        if handle(pendingLink) {
            pendingDeepLink = nil
        }
    }
}

// MARK: - Deep Link Model
public struct CGDKDeepLink {
    public let url: URL
    public let scheme: String
    public let host: String?
    public let pathComponents: [String]
    public let queryItems: [String: String]
    
    public init?(url: URL) {
        guard let scheme = url.scheme else { return nil }
        
        self.url = url
        self.scheme = scheme
        self.host = url.host
        
        // Parse path components
        let pathString = url.path
        self.pathComponents = pathString.components(separatedBy: "/").filter { !$0.isEmpty }
        
        // Parse query items
        var queryDict: [String: String] = [:]
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for item in queryItems {
                queryDict[item.name] = item.value
            }
        }
        self.queryItems = queryDict
    }
}

// MARK: - Navigation View Wrapper
public struct CGDKNavigationWrapper<Content: View>: View {
    @StateObject private var coordinator = CGDKNavigationCoordinator()
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            content
                .environmentObject(coordinator)
                .sheet(isPresented: Binding(
                    get: { coordinator.presentedSheet != nil },
                    set: { if !$0 { coordinator.dismissSheet() } }
                )) {
                    if let destination = coordinator.presentedSheet {
                        Text("Sheet: \(destination.title)")
                    }
                }
                .fullScreenCover(isPresented: Binding(
                    get: { coordinator.presentedFullScreenCover != nil },
                    set: { if !$0 { coordinator.dismissFullScreenCover() } }
                )) {
                    if let destination = coordinator.presentedFullScreenCover {
                        Text("Full Screen: \(destination.title)")
                    }
                }
                .alert(item: $coordinator.alertItem) { alert in
                    // Handle alert presentation
                    if let secondaryButton = alert.secondaryButton {
                        return Alert(
                            title: Text(alert.title),
                            message: alert.message.map(Text.init),
                            primaryButton: .default(Text(alert.primaryButton.title), action: alert.primaryButton.action),
                            secondaryButton: .cancel(Text(secondaryButton.title), action: secondaryButton.action)
                        )
                    } else {
                        return Alert(
                            title: Text(alert.title),
                            message: alert.message.map(Text.init),
                            dismissButton: .default(Text(alert.primaryButton.title), action: alert.primaryButton.action)
                        )
                    }
                }
        }
        .onAppear {
            CGDKDeepLinkManager.shared.setCoordinator(coordinator)
            CGDKDeepLinkManager.shared.processPendingDeepLink()
        }
    }
}

// MARK: - Navigation Helpers
public struct CGDKBackButton: View {
    @EnvironmentObject private var coordinator: CGDKNavigationCoordinator
    @EnvironmentObject private var tm: CGDKThemeManager
    
    private let title: String?
    private let action: (() -> Void)?
    
    public init(title: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action?()
            coordinator.pop()
        }) {
            HStack(spacing: CGDKTokens.Space.xs) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                
                if let title = title {
                    Text(title)
                        .font(CGDKTokens.Font.body())
                }
            }
            .foregroundStyle(tm.theme.colors.brand)
        }
        .disabled(!coordinator.canGoBack)
    }
}

public struct CGDKCloseButton: View {
    @EnvironmentObject private var coordinator: CGDKNavigationCoordinator
    @EnvironmentObject private var tm: CGDKThemeManager
    
    private let action: (() -> Void)?
    
    public init(action: (() -> Void)? = nil) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action?()
            coordinator.dismissSheet()
            coordinator.dismissFullScreenCover()
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(tm.theme.colors.text)
                .padding(CGDKTokens.Space.sm)
                .background(tm.theme.colors.muted.opacity(0.2))
                .clipShape(Circle())
        }
    }
}

// MARK: - Tab Navigation Support
public enum CGDKTab: String, CaseIterable {
    case home = "home"
    case search = "search"
    case favorites = "favorites"
    case profile = "profile"
    
    public var title: String {
        switch self {
        case .home: return "首頁"
        case .search: return "搜尋"
        case .favorites: return "收藏"
        case .profile: return "個人資料"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .favorites: return "heart"
        case .profile: return "person"
        }
    }
}

@MainActor
public final class CGDKTabCoordinator: ObservableObject {
    @Published public var selectedTab: CGDKTab = .home
    @Published public var tabBadges: [CGDKTab: Int] = [:]
    
    public init() {}
    
    public func selectTab(_ tab: CGDKTab) {
        selectedTab = tab
        CGDKLogDebug("Selected tab: \(tab.title)")
    }
    
    public func setBadge(for tab: CGDKTab, count: Int) {
        if count > 0 {
            tabBadges[tab] = count
        } else {
            tabBadges.removeValue(forKey: tab)
        }
    }
    
    public func clearBadge(for tab: CGDKTab) {
        tabBadges.removeValue(forKey: tab)
    }
    
    public func getBadgeCount(for tab: CGDKTab) -> Int {
        return tabBadges[tab] ?? 0
    }
}

// MARK: - View Extensions
public extension View {
    func cgdkNavigationDestination<Destination: CGDKNavigationDestination, Content: View>(
        for destination: Destination.Type,
        @ViewBuilder content: @escaping (Destination) -> Content
    ) -> some View {
        navigationDestination(for: destination) { destination in
            content(destination)
        }
    }
    
    func cgdkBackButton(title: String? = nil, action: (() -> Void)? = nil) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CGDKBackButton(title: title, action: action)
            }
        }
    }
    
    func cgdkCloseButton(action: (() -> Void)? = nil) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                CGDKCloseButton(action: action)
            }
        }
    }
}