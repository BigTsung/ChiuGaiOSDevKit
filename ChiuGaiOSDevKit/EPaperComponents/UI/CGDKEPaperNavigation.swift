//
//  CGDKEPaperNavigation.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

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

#Preview {
    VStack(spacing: 20) {
        CGDKEPaperNavigation(currentPage: 0, totalPages: 3) { _ in }
        CGDKEPaperNavigation(currentPage: 1, totalPages: 5) { _ in }
        CGDKEPaperNavigation(currentPage: 2, totalPages: 4) { _ in }
    }
    .padding()
    .background(CGDKEPaperTokens.Color.paper)
}