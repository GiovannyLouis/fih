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
    
    @State private var fishController = FishController()
    
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
            
            
            VStack (spacing: 15) {
                // 1. TOP NAVIGATION BAR (TETAP DIAM DI TEMPAT)
                HStack {
                    Button(action: {
                        appState.isMovingForward = false
                        appState.currentScreen = .weatherForecastPage
                    }) {
                        Image("icon_back")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6))
                    }
                    
                    Spacer()
                    
                    Text("Fish Collection")
                        .font(.custom("Cause-Bold", size: 32))
                        .foregroundColor(Color("color_dark_blue"))
                    
                    Spacer()
                }
                .padding(.top, 32)
                
                //Spacer()
                HStack(alignment: .top, spacing: 150) {
                    // Grup Kiri (Zone 1 & 2)
                    HStack(alignment: .top, spacing: 15) {
                        ZoneTabView(imageName: "zone_1", isSelected: selectedZone == 1) {
                            selectedZone = 1
                            fishController.filterFishes(byZone: 1, context: context)
                        }
                        ZoneTabView(imageName: "zone_2", isSelected: selectedZone == 2) {
                            selectedZone = 2
                            fishController.filterFishes(byZone: 2, context: context)
                        }
                    }

                    // Grup Kanan (Zone 3 & 4)
                    HStack(alignment: .top, spacing: 15) {
                        ZoneTabView(imageName: "zone_3", isSelected: selectedZone == 3) {
                            selectedZone = 3
                            fishController.filterFishes(byZone: 3, context: context)
                        }
                        ZoneTabView(imageName: "zone_4", isSelected: selectedZone == 4) {
                            selectedZone = 4
                            fishController.filterFishes(byZone: 4, context: context)
                        }
                    }
                }
                //.padding(.bottom, -240)
                
                Spacer()
            }
                    // 1. TAMBAHKAN OFFSET PADA BUKU SPRITEKIT
                   
                    
                    VStack {
                       
                        
                        
                        // 2. BUNGKUS TAB DAN KONTEN DALAM VSTACK BARU
//                        VStack(spacing: 0) {
//                            
//                            // --- TAB ZONA ---

//                            .padding(.bottom, -30)
//                            
//                            // --- ISI HALAMAN KIRI & KANAN ---
//                            HStack(spacing: 30) {
//                                
//                                // HALAMAN KIRI
//                                VStack(spacing: 5) {
//                                    FishEntryView(isLocked: false, name: "Tuna", description: "Short explanation of the fish", icon: "fish_blue")
//                                    FishEntryView(isLocked: true, name: "", description: "", icon: "")
//                                    FishEntryView(isLocked: false, name: "Tuna 3", description: "Short explanation of the fish", icon: "fish_blue")
//                                    Spacer()
//                                }
//                                .frame(width: 260)
//
//                                // HALAMAN KANAN
//                                VStack(spacing: 5) {
//                                    FishEntryView(isLocked: true, name: "", description: "", icon: "")
//                                    FishEntryView(isLocked: false, name: "Tuna 5", description: "Short explanation of the fish", icon: "fish_red", imageOnRight: true)
//                                    FishEntryView(isLocked: true, name: "", description: "", icon: "")
//                                    Spacer()
//                                }
//                                .frame(width: 260)
//                            }
//                        }
//                        // 3. BERIKAN OFFSET YANG SAMA AGAR TETAP PAS DENGAN BUKUNYA
//                        //.offset(y: -10)
//                        
//                        Spacer()
                    }
                }
        .onAppear {
            fishController.filterFishes(byZone: selectedZone, context: context)
        }
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
        .environment(AppStateManager())
}
