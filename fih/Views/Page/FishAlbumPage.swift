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
                
                // 2. Tab Zone 1 s/d 4
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
               
                
               
                
                // 3. Isi card ikan bagian kiri dan kanan
                
                HStack(spacing: 45) {
                    Spacer()
                    // Halaman kiri
                    VStack {
                        ForEach(0..<fishController.leftPageFishes.count, id: \.self) { index in
                            // 2. Ambil data ikan berdasarkan indeksnya saat ini
                            let fish = fishController.leftPageFishes[index]
                            
                            FishEntryView(
                                isLocked: !fish.isUnlocked,
                                name: fish.name,
                                description: fish.info,
                                icon: fish.iconName
                            )
                            .padding(.vertical, index == 1 ? 2 : 0)
                        }
                        Spacer()
                    }
                    
                    
                    // Halaman kanan
                    VStack {
                        ForEach(0..<fishController.rightPageFishes.count, id: \.self) { index in
                            // 2. Ambil data ikan berdasarkan indeksnya saat ini
                            let fish = fishController.rightPageFishes[index]
                            
                            FishEntryView(
                                isLocked: !fish.isUnlocked,
                                name: fish.name,
                                description: fish.info,
                                icon: fish.iconName
                            )
                            .padding(.vertical, index == 1 ? 2 : 0)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                
                
                Spacer()
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
    
    // Warna biru gelap khusus untuk teks dan ikon agar sesuai dengan tema gambar
    let darkBlueTheme = Color(red: 0.1, green: 0.1, blue: 0.5)
    
    var body: some View {
        HStack(spacing: 15) {
            
            // Gambar Ikan
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 55, height: 55)
                // (Opsional) Jika Anda ingin ikan yang terkunci berwarna hitam pekat (siluet):
                // .colorMultiply(isLocked ? .black : .white)
            
            VStack(alignment: .leading) {
                // Teks Nama (Disembunyikan jadi ??? jika terkunci)
                Text(isLocked ? "???" : name)
                    .font(.custom("Cause-Extrabold", size: 16))
                    .foregroundColor(darkBlueTheme)
                
                // Teks Deskripsi
                Text(isLocked ? "You haven't caught this fish yet" : description)
                    .font(.custom("Patrickhand-Regular", size: 16))
                    .foregroundColor(darkBlueTheme)
            }
            
            Spacer()
        }
        .padding(.horizontal, 5)
        .frame(width: 230, height: 55)
        
        // KUNCI UTAMANYA DI SINI:
        // Jika isLocked = true, transparansi seluruh baris menjadi 30% (0.3).
        // Jika isLocked = false, transparansi kembali 100% (1.0).
        .opacity(isLocked ? 0.3 : 1.0)
    }
}

//struct FishEntryView: View {
//    let isLocked: Bool
//    let name: String
//    let description: String
//    let icon: String
//    var imageOnRight: Bool = false
//    
//    // Warna biru gelap khusus untuk teks dan ikon agar sesuai dengan tema gambar
//    let darkBlueTheme = Color(red: 0.1, green: 0.1, blue: 0.5)
//    
//    var body: some View {
//        Group {
//            if isLocked {
//                // --- LOCKED STATE BARU ---
//                HStack(spacing: 15) {
//                    
//                    // Ikon Gembok
//                    // Jika Anda memiliki aset gambar gembok sendiri (seperti di desain),
//                    // ganti baris ini menjadi: Image("nama_aset_gembok_anda")
//                    Image(systemName: "lock")
//                        .font(.system(size: 50, weight: .bold))
//                        .foregroundColor(darkBlueTheme)
//                        .frame(width: 40)
//                    
//                    Text("You have not caught\nthis fish yet")
//                        .font(.system(size: 15, weight: .bold))
//                        .foregroundColor(darkBlueTheme)
//                        //.multilineTextAlignment(.center)
//                    
//                        //Spacer()
//                }
//                .padding(.horizontal, 15)
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color(red: 0.82, green: 0.82, blue: 0.82)) // Abu-abu terang
//                )
//                // Menambahkan garis tepi (outline) pada kotak terkunci
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(darkBlueTheme.opacity(0.6), lineWidth: 2)
//                )
//                
//            } else {
//                // --- UNLOCKED STATE BARU ---
//                HStack(spacing: 15) {
//                    
//                    // Gambar Ikan Langsung (tanpa lingkaran hijau)
//                   
//                    Image(icon)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 60, height: 60)
//                    
//                    
//                    VStack(alignment: .leading) {
//                        Text(name)
//                            .font(.custom("Cause-Extrabold", size: 16))
//                            .foregroundColor(darkBlueTheme)
//                        
//                        Text(description)
//                            .font(.custom("Patrickhand-Regular", size: 16))
//                            .foregroundColor(darkBlueTheme) // Ubah warna jadi biru
//                    }
//                    
//                    Spacer()
//                }
//                .padding(.horizontal, 5)
//
//            }
//
//        }                .frame(width: 225, height: 60)
//
//    }
//}

#Preview {
    FishAlbumPage()
        .environment(AppStateManager())
}
