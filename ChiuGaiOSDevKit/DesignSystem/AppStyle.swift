//
//  AppStyle.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI
public struct CGDKAppStyle: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .formStyle(.grouped)
            .toolbarTitleDisplayMode(.inline)
    }
}
public extension View { func cgdkAppStyle() -> some View { modifier(CGDKAppStyle()) } }
