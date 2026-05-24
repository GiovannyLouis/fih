//
//  SettingsPage.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 21/05/26.
//

import SwiftUI
import SpriteKit
import SwiftData

struct SettingsPage: View {
    
    @State private var playerController = PlayerController()
    @Environment(AppStateManager.self) private var appState
    @Environment(\.modelContext) private var context
        
    // State untuk memunculkan pop-up peringatan sebelum menghapus data
    @State private var showResetAlert: Bool = false
    
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
            // LAYER 1: Background Color & Ikan
            SpriteView(scene: fishBackgroundScene)
                .ignoresSafeArea()
                .opacity(0.075)
            
            // LAYER 2: Navigation bar & Konten Settings
            VStack {
                // 1. TOP NAVIGATION BAR
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
                    
                    Text("Game Settings")
                        .font(.custom("Cause-Bold", size: 32))
                        .foregroundColor(Color("color_dark_blue"))
                    
                    Spacer()
                    
                    // Spacer transparan agar teks judul benar-benar di tengah layar
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.top, 32)
                //.padding(.horizontal, 48)
                
                // 2. KARTU SETTINGS UTAMA
                ZStack {
                    // Background Kertas Krem
                    Image("card_background_cream")
                        .resizable(
                            capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                            resizingMode: .stretch 
                        )
                        .frame(width: 900, height: 520)
                        .scaleEffect(0.5)
                        .frame(width: 450, height: 260)
                    
                    HStack(spacing: 30) {
                        
                        // --- KOLOM KIRI: STATISTIK PERMAINAN ---
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // Info 1: Days Aboard
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total days aboard")
                                    .font(.custom("Cause-Bold", size: 16))
                                    .foregroundColor(Color("color_dark_blue"))
                                
                                // Ganti .totalDays dengan variabel yang benar di PlayerController Anda
                                Text("\(playerController.currentDays) days")
                                    .font(.custom("Cause-Bold", size: 28))
                                    .foregroundColor(Color("color_dark_blue"))
                            }
                            
                            // Info 2: Unlocked Fish
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total unlocked fish")
                                    .font(.custom("Cause-Bold", size: 16))
                                    .foregroundColor(Color("color_dark_blue"))
                                
                                // Ganti angka ini dengan variabel yang benar di PlayerController Anda
                                Text("\(playerController.totalUnlockedFish)/24")
                                    .font(.custom("Cause-Bold", size: 28))
                                    .foregroundColor(Color("color_dark_blue"))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)
                        
                        
                        // --- KOLOM KANAN: DANGER ZONE (RESET) ---
                        VStack(spacing: 16) {
                            Text("Are you sure want to reset the data?")
                                .font(.custom("Cause-Extrabold", size: 16))
                                .foregroundColor(Color("color_dark_blue"))
                                .multilineTextAlignment(.center)
                                .frame(width: 200)
                            
                            // Tombol Reset Merah
                            Button(action: {
                                showResetAlert = true
                            }) {
                                ZStack {
                                    Image("red_button")
                                        .resizable()
                                        .frame(width: 150, height: 45)
                                    Text("Reset Data")
                                        .font(.custom("cause-bold", size: 16))
                                        .foregroundStyle(.colorDarkBlue)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.trailing, 40)

                        
                    }
                    .frame(width: 450, height: 260)
                }
                
                Spacer()
            }
        }
        // ALERT KONFIRMASI RESET
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset All Progress?"),
                message: Text("This action cannot be undone. You will lose all your days aboard and your fish collection."),
                primaryButton: .destructive(Text("Reset")) {
                    // TODO: Panggil fungsi dari PlayerController Anda untuk mereset SwiftData di sini
                    playerController.resetData(context: context)
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            playerController.getDays(context: context)
            playerController.getTotalUnlockedFish(context: context)
        }
    }
}

#Preview {
    SettingsPage()
        .environment(AppStateManager())
}
