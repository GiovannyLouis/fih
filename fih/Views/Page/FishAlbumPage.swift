//
//  FishAlbumPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SpriteKit
import SwiftData

struct FishAlbumPage: View {
    
    @State private var playerController = PlayerController()
    
    @Environment(AppStateManager.self) private var appState
    
    @Environment(\.modelContext) private var context
    
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
    
    var fishBook: SKScene {
        if let scene = SKScene(fileNamed: "FishBook") {
            scene.scaleMode = .aspectFill
            scene.backgroundColor = .clear
            return scene
        }
        return SKScene()
    }
    
    var body: some View {
        ZStack {
            // Background Color Layer 1
            SpriteView(scene: fishBackgroundScene)
                .ignoresSafeArea()
                .opacity(0.075)
                    
            // Book Page Layer 2
            SpriteView(scene: fishBook, options: [.allowsTransparency])
                .ignoresSafeArea()
            
            // Isi card ikan bagian kiri dan kanan Layer 3
            
            HStack(spacing: 45) {
                Spacer()
                // Halaman kiri
                VStack {
                    ForEach(0..<playerController.leftPageFishes.count, id: \.self) { index in
                        // 2. Ambil data ikan berdasarkan indeksnya saat ini
                        let fish = playerController.leftPageFishes[index]

                        FishCardView(
                            isLocked: !fish.isUnlocked,
                            name: fish.name,
                            description: fish.info,
                            icon: fish.iconName
                        )
                        .padding(.vertical, index == 1 ? 8 : 0)
                    }
                    Spacer()
                }


                // Halaman kanan
                VStack {
                    ForEach(0..<playerController.rightPageFishes.count, id: \.self) { index in
                        // 2. Ambil data ikan berdasarkan indeksnya saat ini
                        let fish = playerController.rightPageFishes[index]

                        FishCardView(
                            isLocked: !fish.isUnlocked,
                            name: fish.name,
                            description: fish.info,
                            icon: fish.iconName
                        )
                        .padding(.vertical, index == 1 ? 8 : 0)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 150)
            
            
            // Navigation bar & Tab zone Layer 4
            VStack (spacing: 15) {
                // 1. TOP NAVIGATION BAR (TETAP DIAM DI TEMPAT)
                HStack {
                    Button(action: {
                        appState.isMovingForward = false
                        appState.currentScreen = .mainMenuPage
                    }) {
                        Image("icon_close")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    
                    Spacer()
                    
                    Text("Fish Collection")
                        .font(.custom("Cause-Bold", size: 32))
                        .foregroundColor(Color("color_dark_blue"))
                    
                    Spacer()
                    
                    Button(action: {
                        appState.currentScreen = .settingsPage
                    }) {
                        Image("icon_settings")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    
                }
                .padding(.top, 32)
                
                // 2. Tab Zone 1 s/d 4
                HStack(alignment: .top, spacing: 150) {
                    // Grup Kiri (Zone 1 & 2)
                    HStack(alignment: .top, spacing: 15) {
                        ZoneTabView(imageName: "zone_1", isSelected: selectedZone == 1) {
                            selectedZone = 1
                            playerController.filterFishes(byZone: 1, context: context)
                        }
                        ZoneTabView(imageName: "zone_2", isSelected: selectedZone == 2) {
                            selectedZone = 2
                            playerController.filterFishes(byZone: 2, context: context)
                        }
                    }

                    // Grup Kanan (Zone 3 & 4)
                    HStack(alignment: .top, spacing: 15) {
                        ZoneTabView(imageName: "zone_3", isSelected: selectedZone == 3) {
                            selectedZone = 3
                            playerController.filterFishes(byZone: 3, context: context)
                        }
                        ZoneTabView(imageName: "zone_4", isSelected: selectedZone == 4) {
                            selectedZone = 4
                            playerController.filterFishes(byZone: 4, context: context)
                        }
                    }
                }
               
                Spacer()
            }
            
            
            
        }
        .onAppear {
            playerController.filterFishes(byZone: selectedZone, context: context)
        }
    }
}

#Preview {
    FishAlbumPage()
        .environment(AppStateManager())
}
