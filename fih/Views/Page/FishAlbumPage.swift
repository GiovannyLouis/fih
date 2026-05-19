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
                
                // 2. MIDDLE: FISH BOOK & TABS
                ZStack(alignment: .top) {
                    
                    // 1. --- TAB ZONA DITARUH PALING ATAS KODE ---
                    // Karena ditaruh pertama, ini akan menjadi layer paling belakang!
                    HStack(spacing: 100) {
                        ZoneTab(imageName: "zone_1", isSelected: selectedZone == 1) {
                            selectedZone = 1
                            fishController.filterFishes(byZone: 1, context: context)}
                        ZoneTab(imageName: "zone_2", isSelected: selectedZone == 2) {
                            selectedZone = 2
                            fishController.filterFishes(byZone: 2, context: context)
                        }
                        ZoneTab(imageName: "zone_3", isSelected: selectedZone == 3) {
                            selectedZone = 3
                            fishController.filterFishes(byZone: 3, context: context) }
                        ZoneTab(imageName: "zone_4", isSelected: selectedZone == 4) {
                            selectedZone = 4 
                            fishController.filterFishes(byZone: 4, context: context) }
                    }
                    .padding(.top, 0)
                    
                    
                    // 2. --- BUKU BACKGROUND ---
                    // Digambar setelah Tab, sehingga akan MENUTUPI bagian bawah Tab yang turun (offset).
                    HStack(spacing: 0) {
                        Image("book_left")
                            .resizable()
                        
                        Image("book_right")
                            .resizable()
                    }
                    .frame(width: 725)
                    .padding(.top, 40)
                    
                    
                    // 3. --- ISI HALAMAN (KIRI & KANAN) ---
                    // Digambar terakhir, sehingga teks selalu ada di atas buku.
//                    HStack(spacing: 50) {
//                        
//                        // HALAMAN KIRI
//                        VStack(spacing: 5) {
//                            FishEntryView(isLocked: false, name: "Tuna", description: "Short explanation of the fish", icon: "fish_blue")
//                            FishEntryView(isLocked: true, name: "", description: "", icon: "")
//                            FishEntryView(isLocked: false, name: "Tuna 3", description: "Short explanation of the fish", icon: "fish_blue")
//                            Spacer()
//                        }
//                        .frame(width: 260)
//                        
//                        // HALAMAN KANAN
//                        VStack(spacing: 5) {
//                            FishEntryView(isLocked: true, name: "", description: "", icon: "")
//                            FishEntryView(isLocked: false, name: "Tuna 5", description: "Short explanation of the fish", icon: "fish_red", imageOnRight: true)
//                            FishEntryView(isLocked: true, name: "", description: "", icon: "")
//                            Spacer()
//                        }
//                        .frame(width: 260)
//                    }
//                    .padding(.top, 80)
                }
                .padding(.horizontal, 10)
                
                //Spacer() // Pushes the cards up to center them perfectly
                
              
            }
        }
    }
}

struct ZoneTab: View {
    let imageName: String // Sekarang kita meminta nama gambar asetnya
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                // Jika terpilih, ukurannya 70x70. Jika tidak, mengecil jadi 55x55
                .frame(width: isSelected ? 70 : 55, height: isSelected ? 70 : 55)
                // Jika tidak terpilih, dorong ke bawah agar terlihat seperti berada di belakang buku
                .offset(y: isSelected ? 0 : 15)
                .zIndex(isSelected ? 1 : 0) // Tab terpilih selalu berada di layer paling depan
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
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
