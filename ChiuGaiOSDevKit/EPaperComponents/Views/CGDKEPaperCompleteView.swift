//
//  CGDKEPaperCompleteView.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

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