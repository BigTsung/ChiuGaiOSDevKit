//
//  Toast.swift
//  ChiuGaDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI
import Combine   // ✅ Swift 6 必須

@MainActor
public final class CGDKToastCenter: ObservableObject {
    @Published public var message: String? = nil
    public init() {}
    public func show(_ msg: String) {
        message = msg
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [weak self] in
            self?.message = nil
        }
    }
}

public struct CGDKToastHost<Content: View>: View {
    @ObservedObject var center: CGDKToastCenter
    let content: Content
    public init(center: CGDKToastCenter, @ViewBuilder content: ()->Content) {
        self.center = center; self.content = content()
    }
    public var body: some View {
        ZStack {
            content
            if let m = center.message {
                Text(m).font(CGDKTokens.Font.caption())
                    .padding(.horizontal, CGDKTokens.Space.xl)
                    .padding(.vertical, CGDKTokens.Space.sm)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .padding(.top, 40)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: center.message)
    }
}
