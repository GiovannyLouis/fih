//
//  FishAlbumPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SpriteKit

struct FishAlbumPage: View {
    
    @State private var fishController = FishController()
    
    @Environment(AppStateManager.self) private var appState
    
    @State private var selectedZone: Int = 1
    
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
                        appState.currentScreen = .weatherForecastPage
                    }) {
                        Image("icon_back")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6))
                    }
                    
                    Spacer() // Pushes the back button to the far left
                    
                    // Title
                    Text("Fish Album")
                        .font(.custom("Cause-Bold", size: 32))
                        .foregroundColor(Color("color_dark_blue"))
                    
                    Spacer() // Pushes the next button to the far right
                    
                    
                }
                .padding(.top, 32)
                
                Spacer() // Pushes the ship cards down to the middle
                
                // 2. MIDDLE: SHIP SELECTION CARDS
                ZStack(alignment:.top) {
                    Image("book_page") // Replace with your book PNG name
                                            .resizable()
                                            //.scaledToFit()
                                            .frame(width: 600) // Adjust based on your iPad/iPhone target
                                            .padding(.top, 30)
                    
                    HStack(spacing: 60) {
                                            ZoneTab(title: "1st\nZONE", isSelected: selectedZone == 1) { selectedZone = 1 }
                                            ZoneTab(title: "2nd\nZONE", isSelected: selectedZone == 2) { selectedZone = 2 }
                                            ZoneTab(title: "3rd\nZONE", isSelected: selectedZone == 3) { selectedZone = 3 }
                                            ZoneTab(title: "4th\nZONE", isSelected: selectedZone == 4) { selectedZone = 4 }
                                        }
                                        .padding(.top, 0) // Tabs sit at the very top
//                    ForEach(shipController.availableShips) { ship in
//                        ShipCardView(
//                            ship: ship,
//                            isSelected: appState.selectedShip == ship,
//                            action: {
//                                // Selects the ship (triggers the animation)
//                                appState.selectedShip = ship
//                                //shipController.selectedShip = ship
//                            }
//                        )
//                    }
                }
                .padding(.horizontal, 10)
                
                Spacer() // Pushes the cards up to center them perfectly
                
              
            }
        }
    }
}

struct ZoneTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image("yellow_tag_asset") // Replace with your yellow tag PNG
                    .resizable()
                    .scaledToFill()
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 60, height: isSelected ? 80 : 60) // Taller if selected
            .offset(y: isSelected ? 0 : 10) // Push down if unselected to look like it's behind
            .zIndex(isSelected ? 1 : 0) // Bring selected tab to front
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FishEntryView: View {
    let isLocked: Bool
    let name: String
    let description: String
    let icon: String
    var imageOnRight: Bool = false
    
    var body: some View {
        Group {
            if isLocked {
                // LOCKED STATE
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.6))
                    
                    VStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                        Text("You haven't caught this fish yet.")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .italic()
                    }
                }
                .frame(height: 80)
            } else {
                // UNLOCKED STATE
                HStack {
                    if !imageOnRight { FishImage(icon: icon) }
                    
                    VStack(alignment: imageOnRight ? .trailing : .leading) {
                        Text(name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        Text(description)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if imageOnRight { FishImage(icon: icon) }
                }
                .frame(height: 80)
            }
        }
    }
}

// Tiny helper for the fish icon circle
struct FishImage: View {
    let icon: String
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.green, lineWidth: 3)
                .frame(width: 60, height: 60)
            Image(icon) // Use your fish icon asset
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    FishAlbumPage()
}
