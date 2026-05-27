//
//  ObstacleInfoButton.swift
//  fih
//
//  Created by Jose Putra Perdana Taneo on 27/05/26.
//

import SwiftUI

struct ObstacleInfoButton: View {
    // 1. A Binding allows this component to change the state variable of the parent screen
    @Binding var showGuide: Bool
    
    // 2. Read-only inputs passed from the parent screen's state
    let currentDay: Int
    let audioController: AudioManager // Replace with your exact Audio class type
    let description: String
    
    var body: some View {
        Button(action: {
            var t = Transaction()
            t.disablesAnimations = true
            withTransaction(t) {
                showGuide = true
            }
            print("Obstacle Button Current Day: \(currentDay)")
            audioController.playSFX(filename: "tap")
        }) {
            Image("icon_guide")
                .resizable()
                .frame(width: 40, height: 40)
                .blinking(currentDay: currentDay) // Using the refactored integer parameter
        }
        .opacity(showGuide ? 0 : 1)
        .overlay(
            Group {
                    if currentDay <= 2 {
                        Text(description)
                            .font(.custom("patrickhand-regular", size: 16))
                            .foregroundStyle(.colorDarkBlue)
                            .lineHeight(.tight)
                            .multilineTextAlignment(.trailing)
                            .offset(y: 32)
                            .frame(width: 140, alignment: .topTrailing)
                            .fixedSize(horizontal: true, vertical: false)
                            .blinking(currentDay: currentDay)
                            .opacity(showGuide ? 0 : 1)
                    }
                },
                alignment: .bottomTrailing
        )
    }
}
