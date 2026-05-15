//
//  SelectShipPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

// MARK: - VIEW (Main Screen Updated)
struct SelectShipPage: View {
    
    @State private var shipController = ShipController()
    
    @Environment(AppStateManager.self) private var appState
        
    var body: some View {
        ZStack {
            // Background Color
            Color.white.ignoresSafeArea()
            
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
                    Text("Select Your Ship")
                        .font(.custom("Cause-Bold", size: 32))
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6))
                    
                    Spacer() // Pushes the next button to the far right
                    
                    // Right Arrow (Next Step: Select Equipment)
                    Button(action: {
                        appState.isMovingForward = true
                        appState.currentScreen = .selectEquipmentPage
                    }) {
                        Image(systemName: "chevron.right.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            // Turns gray if no ship is selected
                            .foregroundColor(appState.selectedShip != nil ? Color(red: 0.1, green: 0.1, blue: 0.6) : .gray)
                    }
                    .disabled(appState.selectedShip == nil)                }
                    .padding(.top, 32)
                
                Spacer() // Pushes the ship cards down to the middle
                
                // 2. MIDDLE: SHIP SELECTION CARDS
                HStack(spacing: 30) {
                    ForEach(shipController.availableShips) { ship in
                        ShipCardView(
                            ship: ship,
                            isSelected: appState.selectedShip == ship,
                            action: {
                                // Selects the ship (triggers the animation)
                                appState.selectedShip = ship
                                //shipController.selectedShip = ship
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer() // Pushes the cards up to center them perfectly
            }
        }
    }
}

#Preview {
    SelectShipPage()
        .environment(AppStateManager())
}
