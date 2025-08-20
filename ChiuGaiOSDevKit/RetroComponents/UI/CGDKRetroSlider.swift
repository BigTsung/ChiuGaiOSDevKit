//
//  CGDKRetroSlider.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Retro Slider
public struct CGDKRetroSlider: View {
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let label: String?
    private let width: CGFloat
    private let colors: CGDKRetroTokens.RetroColors
    
    public init(
        _ label: String? = nil,
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...100,
        width: CGFloat = 200,
        colorScheme: CGDKRetroTokens.ColorScheme = .classic
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.width = width
        self.colors = CGDKRetroTokens.Color.colors(for: colorScheme)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.xs) {
            if let label = label {
                HStack {
                    Text(label)
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(colors.textMuted)
                    
                    Spacer()
                    
                    Text("\(Int(value))")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(colors.text)
                }
            }
            
            HStack(spacing: 0) {
                Text("[")
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(colors.border)
                
                GeometryReader { geometry in
                    let sliderWidth = geometry.size.width
                    let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
                    let handlePosition = sliderWidth * progress
                    
                    ZStack(alignment: .leading) {
                        // 軌道
                        Rectangle()
                            .fill(colors.borderLight)
                            .frame(height: 2)
                        
                        // 滑塊
                        Text("■")
                            .font(CGDKRetroTokens.Font.body())
                            .foregroundStyle(colors.accent)
                            .offset(x: handlePosition - 6)
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { dragValue in
                                let newProgress = max(0, min(1, dragValue.location.x / sliderWidth))
                                value = range.lowerBound + newProgress * (range.upperBound - range.lowerBound)
                            }
                    )
                }
                .frame(width: width, height: 20)
                
                Text("]")
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(colors.border)
            }
        }
    }
}