//
//  SelectShipPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SpriteKit

// MARK: - VIEW (Main Screen Updated)
struct SelectShipPage: View {
    
    @State private var shipController = ShipController()
    
    @Environment(AppStateManager.self) private var appState
    @Environment(AudioManager.self) private var audio
    
    var fishBackgroundScene: SKScene {
        // This looks for FishBackground.sks, sees it is linked to FishBackgroundScene,
        // loads your fish, and triggers the didMove(to:) movement code!
        if let scene = SKScene(fileNamed: "FishBackground") {
            scene.scaleMode = .aspectFill
            return scene
        }
        return SKScene()
    }
        
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            // Background Color
            SpriteView(scene: fishBackgroundScene)
                .ignoresSafeArea() // Make sure the fish go behind the status bar
                .opacity(0.075)
            
            VStack {
                // 1. TOP NAVIGATION BAR
                HStack {
                    // Left Arrow (Back to Main Menu)
                    Button(action: {
                        appState.isMovingForward = false
                        audio.haptic(style: .light)
                        appState.currentScreen = .weatherForecastPage
                    }) {
                        Image("icon_back")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6))
                    }
                    
                    Spacer() // Pushes the back button to the far left
                    
                    // Title
                    Text("Select Your Ship")
                        .font(.custom("Cause-Bold", size: 32))
                        .foregroundColor(Color("color_dark_blue"))
                    
                    Spacer() // Pushes the next button to the far right
                    
                    
                }
                .padding(.top, 32)
                
                Spacer() // Pushes the ship cards down to the middle
                
                // 2. MIDDLE: SHIP SELECTION CARDS
                HStack(spacing: 20) {
                    ForEach(shipController.availableShips) { ship in
                        ShipCardView(
                            ship: ship,
                            isSelected: appState.selectedShip == ship,
                            action: {
                                // Selects the ship (triggers the animation)
                                audio.haptic(style: .light)
                                appState.selectedShip = ship
                                //shipController.selectedShip = ship
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer() // Pushes the cards up to center them perfectly
                
              
                // 3. Button next
                // Right Arrow (Next Step: Select Equipment)
                Button(action: {
                    appState.isMovingForward = true
                    audio.haptic(style: .medium)
                    audio.playSFX(filename: "play")
                    appState.currentScreen = .selectEquipmentPage
                }) {
                    ZStack {
                        Image(appState.selectedShip == nil ? "gray_button" : "green_button")
                            .resizable()
                            .frame(width: 180, height: 56)
                        
                        Text("Next")
                            .font(.custom("Cause-Bold", size: 32))
                            .foregroundColor(Color("color_dark_blue"))
                    }
                   
                }
                .padding(.bottom, 16)
                .disabled(appState.selectedShip == nil)
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    SelectShipPage()
        .environment(AppStateManager())
        .environment(AudioManager())
}
