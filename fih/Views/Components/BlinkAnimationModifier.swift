//
//  BlinkAnimationModifier.swift
//  fih
//
//  Created by Jose Putra Perdana Taneo on 27/05/26.
//

import SwiftUI

struct BlinkAnimationModifier: ViewModifier {
    @State private var isVisible = true
    let duration: Double
    let currentDay: Int
    
    private var shouldBlink: Bool {
        currentDay <= 2
    }

    func body(content: Content) -> some View {
        content
            .opacity(shouldBlink ? (isVisible ? 1.0 : 0.2) : 1.0)
            .onAppear {
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    isVisible = false
                }
            }
            .onChange(of: currentDay) {
                print("Blink Modifier Current Day: \(currentDay)")
            }
    }
}

extension View {
    func blinking(duration: Double = 0.6, currentDay: Int) -> some View {
        self.modifier(BlinkAnimationModifier(duration: duration, currentDay: currentDay))
    }
}
