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
                        appState.currentScreen = .weatherForecastPage
                    }) {
                        Image(systemName: "chevron.left.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6))
                    }
                    
                    Spacer() // Pushes the back button to the far left
                    
                    // Title
                    Text("Select Your Ship")
                        .font(.custom("Cause-Bold", size: 38))
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6))
                    
                    Spacer() // Pushes the next button to the far right
                    
                    // Right Arrow (Next Step: Select Equipment)
                    Button(action: {
                        if let selectedShip = shipController.selectedShip {
                            // ubah state appstate menjadi selectEquipmentPage
                            appState.currentScreen = .selectEquipmentPage(ship: selectedShip)
                        }
                    }) {
                        Image(systemName: "chevron.right.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            // Turns gray if no ship is selected
                            .foregroundColor(shipController.selectedShip != nil ? Color(red: 0.1, green: 0.1, blue: 0.6) : .gray)
                    }
                    .disabled(shipController.selectedShip == nil)                }
                .padding(.horizontal, 40) // Gives the buttons some breathing room from the screen edges
                .padding(.top, 20)
                
                Spacer() // Pushes the ship cards down to the middle
                
                // 2. MIDDLE: SHIP SELECTION CARDS
                HStack(spacing: 30) {
                    ForEach(shipController.availableShips) { ship in
                        ShipCardView(
                            ship: ship,
                            isSelected: shipController.selectedShip == ship,
                            action: {
                                // Selects the ship (triggers the animation)
                                shipController.selectedShip = ship
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
