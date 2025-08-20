//
//  CGDKAnimations.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import SwiftUI

// MARK: - Animation Presets
public struct CGDKAnimations {
    public static let quick = Animation.easeInOut(duration: 0.15)
    public static let smooth = Animation.easeInOut(duration: 0.3)
    public static let gentle = Animation.easeInOut(duration: 0.5)
    public static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.7)
    public static let springy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    public static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.8)
}

// MARK: - Custom Transitions
public extension AnyTransition {
    static var cgdkSlideIn: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    static var cgdkSlideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
    
    static var cgdkFadeScale: AnyTransition {
        .opacity.combined(with: .scale(scale: 0.8))
    }
    
    static var cgdkPop: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.3).combined(with: .opacity),
            removal: .scale(scale: 1.2).combined(with: .opacity)
        )
    }
    
    static func cgdkFlip(axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 1, 0)) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: CGDKFlipModifier(axis: axis, angle: -90),
                identity: CGDKFlipModifier(axis: axis, angle: 0)
            ),
            removal: .modifier(
                active: CGDKFlipModifier(axis: axis, angle: 90),
                identity: CGDKFlipModifier(axis: axis, angle: 0)
            )
        )
    }
}

struct CGDKFlipModifier: ViewModifier {
    let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    let angle: Double
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: axis,
                perspective: 0.5
            )
    }
}

// MARK: - Animated View Modifiers
public struct CGDKPulseModifier: ViewModifier {
    @State private var isPulsing = false
    let minScale: CGFloat
    let maxScale: CGFloat
    let duration: Double
    
    public init(minScale: CGFloat = 0.95, maxScale: CGFloat = 1.05, duration: Double = 1.0) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? maxScale : minScale)
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}

public struct CGDKShakeModifier: ViewModifier {
    @State private var offset: CGFloat = 0
    let intensity: CGFloat
    let duration: Double
    
    public init(intensity: CGFloat = 10, duration: Double = 0.1) {
        self.intensity = intensity
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(x: offset)
    }
    
    public func shake() {
        let animation = Animation.easeInOut(duration: duration)
        withAnimation(animation) {
            offset = intensity
        }
        withAnimation(animation.delay(duration)) {
            offset = -intensity
        }
        withAnimation(animation.delay(duration * 2)) {
            offset = intensity / 2
        }
        withAnimation(animation.delay(duration * 3)) {
            offset = -intensity / 2
        }
        withAnimation(animation.delay(duration * 4)) {
            offset = 0
        }
    }
}

public struct CGDKBounceModifier: ViewModifier {
    @State private var scale: CGFloat = 1.0
    let intensity: CGFloat
    
    public init(intensity: CGFloat = 0.1) {
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
    }
    
    public func bounce() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
            scale = 1.0 + intensity
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                scale = 1.0
            }
        }
    }
}

public struct CGDKGlowModifier: ViewModifier {
    @State private var glowIntensity: Double = 0
    let color: Color
    let radius: CGFloat
    let isAnimated: Bool
    
    public init(color: Color = .blue, radius: CGFloat = 10, isAnimated: Bool = true) {
        self.color = color
        self.radius = radius
        self.isAnimated = isAnimated
    }
    
    public func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(isAnimated ? glowIntensity : 1.0), radius: radius)
            .onAppear {
                if isAnimated {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        glowIntensity = 1.0
                    }
                }
            }
    }
}

// MARK: - Animated Containers
public struct CGDKAnimatedContainer<Content: View>: View {
    let content: Content
    let animation: Animation
    @State private var isVisible = false
    
    public init(animation: Animation = CGDKAnimations.smooth, @ViewBuilder content: () -> Content) {
        self.animation = animation
        self.content = content()
    }
    
    public var body: some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.8)
            .animation(animation, value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}

public struct CGDKStaggeredContainer<Content: View>: View {
    let content: Content
    let delay: Double
    let stagger: Double
    @State private var isVisible = false
    
    public init(delay: Double = 0.1, stagger: Double = 0.1, @ViewBuilder content: () -> Content) {
        self.delay = delay
        self.stagger = stagger
        self.content = content()
    }
    
    public var body: some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(delay), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}

// MARK: - View Extensions
public extension View {
    func cgdkPulse(minScale: CGFloat = 0.95, maxScale: CGFloat = 1.05, duration: Double = 1.0) -> some View {
        modifier(CGDKPulseModifier(minScale: minScale, maxScale: maxScale, duration: duration))
    }
    
    func cgdkShake() -> some View {
        modifier(CGDKShakeModifier())
    }
    
    func cgdkBounce() -> some View {
        modifier(CGDKBounceModifier())
    }
    
    func cgdkGlow(color: Color = .blue, radius: CGFloat = 10, isAnimated: Bool = true) -> some View {
        modifier(CGDKGlowModifier(color: color, radius: radius, isAnimated: isAnimated))
    }
    
    func cgdkAnimatedEntry(animation: Animation = CGDKAnimations.smooth) -> some View {
        CGDKAnimatedContainer(animation: animation) {
            self
        }
    }
    
    func cgdkStaggeredEntry(delay: Double = 0.1, stagger: Double = 0.1) -> some View {
        CGDKStaggeredContainer(delay: delay, stagger: stagger) {
            self
        }
    }
    
    func cgdkPressAnimation(scale: CGFloat = 0.95) -> some View {
        scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: false)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                // This will be handled by the button itself
            }
        }
    }
    
    func cgdkHoverEffect(scale: CGFloat = 1.05) -> some View {
        scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.2), value: false)
    }
}

// MARK: - Animated Numbers
public struct CGDKAnimatedNumber: View {
    let value: Double
    let formatter: NumberFormatter
    @State private var displayValue: Double = 0
    
    public init(value: Double, formatter: NumberFormatter = NumberFormatter()) {
        self.value = value
        self.formatter = formatter
    }
    
    public var body: some View {
        Text(formatter.string(from: NSNumber(value: displayValue)) ?? "")
            .contentTransition(.numericText())
            .animation(.easeInOut(duration: 0.8), value: displayValue)
            .onAppear {
                displayValue = value
            }
            .onChange(of: value) { _, newValue in
                withAnimation(.easeInOut(duration: 0.8)) {
                    displayValue = newValue
                }
            }
    }
}

// MARK: - Loading Animations
public struct CGDKTypingIndicator: View {
    @State private var dotCount = 0
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 6, height: 6)
                    .scaleEffect(dotCount == index ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: dotCount
                    )
            }
        }
        .onAppear {
            dotCount = 1
        }
    }
}