//
//  SelectEquipmentPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

struct SelectEquipmentPage: View {

    @State private var controller: EquipmentController = EquipmentController()
    
    @Environment(AppStateManager.self) private var appState
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            HStack(spacing: 0) {
                // LEFT SIDE: Equipment List
                VStack(spacing: 0) {
                    // Header Area
                    HStack {
                        // 2. FIXED: Use appState to go back, not dismiss() or onBack
                        Button(action: {
                            appState.currentScreen = .selectShipPage
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.gray.opacity(0.3))
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        VStack {
                            Text("Select Equipment")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                            Text("Choose your equipments wisely")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    Divider().padding(.horizontal, 40)
                    
                    // Scrollable List
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(controller.availableEquipment) { item in
                                let isSelected = controller.equippedItems.contains(where: { $0.id == item.id })
                                
                                EquipmentRowView(item: item, isSelected: isSelected) {
                                    controller.toggleEquipment(item)
                                }
                            }
                        }
                        .padding(20)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 1.0, green: 0.98, blue: 0.9)) // Light yellow background
                
                if let selectedShip = appState.selectedShip {
                    // RIGHT SIDE: Ship Preview & Slots
                    VStack {
                        Spacer()
                        
                        // Ship Image
                        Image(selectedShip.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                        
                        // DYNAMIC EQUIPMENT SLOTS (No ForEach Approach!)
                        HStack(spacing: 15) {
                            
                            let slotCount = selectedShip.equipmentSlots
                            let equippedCount = controller.equippedItems.count
                            
                            // Slot 1
                            if slotCount > 0 {
                                EquipmentSlotView(iconName: equippedCount > 0 ? controller.equippedItems[0].imageName : nil)
                            }
                            
                            // Slot 2
                            if slotCount > 1 {
                                EquipmentSlotView(iconName: equippedCount > 1 ? controller.equippedItems[1].imageName : nil)
                            }
                            
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        // Start Button
                        // menyimpan kapal beserta equipment nya agar dapat dibawa ke ingame
                        // mengubah state currentScreen menjadi InGamePage
                        Button(action: {
                            appState.currentScreen = .inGamePage
                        }) {
                            Text("Start")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 50)
                                .background(Color.green)
                                .cornerRadius(25)
                        }
                        .padding(.bottom, 30)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    let dummyShip = Ship(name: "Cargo Ship", imageName: "ship_cargo", maxSpeed: 50, maxDurability: 800, equipmentSlots: 2, shipType: .cargoBoat)
    
    SelectEquipmentPage()
        .environment(AppStateManager())
}
