//
//  SelectEquipmentPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SpriteKit

struct SelectEquipmentPage: View {

    @State private var controller: EquipmentController = EquipmentController()
    @Environment(AppStateManager.self) private var appState
    @Environment(AudioManager.self) private var audio
    
    var equipmentCreamBackground: SKScene {
        if let scene = SKScene(fileNamed: "EquipmentCreamBackground") {
            scene.scaleMode = .aspectFill
            scene.backgroundColor = .clear
            return scene
        }
        return SKScene()
    }
    
    var bgScene: SKScene {
        let scene = CreamBackgroundScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var fishBackgroundScene: SKScene {
        if let scene = SKScene(fileNamed: "FishBackground") {
            scene.scaleMode = .aspectFill
            return scene
        }
        return SKScene()
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            // LAYER 1: Background Ikan Animasi
            SpriteView(scene: fishBackgroundScene, options: [.allowsTransparency])
                .ignoresSafeArea()
                .opacity(0.075)
            
//            SpriteView(scene: equipmentCreamBackground, options: [.allowsTransparency])
//                .ignoresSafeArea()
            
            // LAYER 2: Layout Utama
            HStack(spacing: 0) {
                
                // 1. KOLOM TOMBOL BACK
                VStack {
                    Button(action: {
                        appState.isMovingForward = false
                        audio.haptic(style: .light)
                        appState.currentScreen = .selectShipPage
                    }) {
                        Image("icon_back")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6))
                    }
                    Spacer()
                }
                .padding(.top, 32)
                .padding(.trailing, 32)
                
                // 2. PANEL EQUIPMENT LIST (Background Krem)
                VStack(spacing: 0) {
                    Text("Select Equipment")
                        .font(.custom("Cause-Bold", size: 32))
                        .foregroundColor(Color("color_dark_blue"))
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                    
                    ScrollView {
                        VStack(spacing: 5) {
                            ForEach(controller.availableEquipment) { item in
                                let isSelected = controller.equippedItems.contains(where: { $0.id == item.id })
                                
                                EquipmentRowView(item: item, isSelected: isSelected) {
                                    if let selectedShip = appState.selectedShip {
                                        audio.haptic(style: .light)
                                        audio.playSFX(filename: "tap", volume: 0.2)
                                        controller.toggleEquipment(item, maxEquipmentSlots: selectedShip.equipmentSlots)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(
                    Image("card_background_cream")
                        .resizable(
                            capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                            resizingMode: .stretch
                        )
                )
                .padding(.top, 4)
                
                if let selectedShip = appState.selectedShip {
                    VStack {
                        Spacer()
                        
                        // Ship Image
                        Image(selectedShip.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .frame(width: 200)
                        
                        // DYNAMIC EQUIPMENT SLOTS
                        HStack(spacing: 15) {
                            let slotCount = selectedShip.equipmentSlots
                            let equippedCount = controller.equippedItems.count
                            
                            if slotCount > 0 {
                                EquipmentSlotView(
                                    iconName: equippedCount > 0 ? controller.equippedItems[0].imageName : nil,
                                    onRemove: {
                                        if equippedCount > 0 {
                                            let itemToRemove = controller.equippedItems[0]
                                            audio.haptic(style: .light)
                                            audio.playSFX(filename: "tap", volume: 0.2)
                                            controller.toggleEquipment(itemToRemove, maxEquipmentSlots: slotCount)
                                        }
                                    }
                                )
                            }
                                                                                                    
                            if slotCount > 1 {
                                EquipmentSlotView(
                                    iconName: equippedCount > 1 ? controller.equippedItems[1].imageName : nil,
                                    onRemove: {
                                        if equippedCount > 1 {
                                            let itemToRemove = controller.equippedItems[1]
                                            audio.haptic(style: .light)
                                            audio.playSFX(filename: "tap", volume: 0.3)
                                            controller.toggleEquipment(itemToRemove, maxEquipmentSlots: slotCount)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        // Start Button
                        Button(action: {
                            appState.equippedItems = controller.equippedItems
                            if let ship = appState.selectedShip {
                                appState.inGameController = InGameController(
                                    ship: ship,
                                    equippedItems: controller.equippedItems,
                                    actualWeather: appState.currentForecast!.actualWeather
                                )
                            }
                            audio.playSFX(filename: "play", volume: 0.2)
                            audio.stopBGM_Menu()
                            audio.haptic(style: .medium)
                            appState.isMovingForward = true
                            appState.currentScreen = .inGamePage
                        }) {
                            ZStack {
                                Image("green_button")
                                    .resizable()
                                    .frame(width: 180, height: 56)
                                
                                Text("Start")
                                    .font(.custom("Cause-Bold", size: 32))
                                    .foregroundColor(Color("color_dark_blue"))
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity)
                    
                } else {
                    Spacer().frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    let dummyShip = Ship(name: "Cargo Ship", imageName: "ship_cargo", maxSpeed: 50, maxDurability: 800, equipmentSlots: 2, shipType: .cargoBoat)
    
    SelectEquipmentPage()
        .environment(AppStateManager())
        .environment(AudioManager())
}
