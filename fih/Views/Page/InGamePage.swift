//
//  InGamePage.swift
//  fih
//
//  Created by Muhammad Dzakki Abdullah on 13/05/26.
//

import SwiftUI
import SpriteKit
import SwiftData

struct InGamePage: View {
    
    let controller: InGameController
    
    @Environment(AppStateManager.self) private var appState
    @Environment(AudioManager.self) private var audio
    @Environment(\.modelContext) private var context
    
    @State private var playerController = PlayerController()
    
    
    @State private var scene: GameScene? = nil
    @State private var showShipPanel: Bool = false
    
    var body: some View {
        ZStack {
            
            // MARK: - GAME SCENE (background penuh)
            if let scene = scene {
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .ignoresSafeArea()
                    .blur(radius: showShipPanel ? 8 : 0)
                    .animation(.easeInOut(duration: 0.25), value: showShipPanel)
            } else {
                Color(red: 0.97, green: 0.97, blue: 0.97).ignoresSafeArea()
            }
            
            // MARK: - HUD (di atas game scene)
            VStack {
                HStack(alignment: .top) {
                    ClockAndStatsView(controller: controller)
                    //clockAndStats   // kiri: jam + health + speed
                    Spacer()
                    distanceAndZone // kanan: jarak + zona
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                Spacer()
            }
            
            // MARK: - EVENT POPUP
            VStack(spacing: 20) {
                // 1. Popup Ikan
                if controller.showCatchFishPopup {
                    HStack(spacing: 12) {
                        if let iconName = controller.latestCatchedFishIcon {
                            Image(iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 42)
                        }
                        Text(controller.latestFishMessage)
                            .font(.custom("Cause-Bold", size: 24))
                            .foregroundColor(Color("color_dark_blue"))
                    }
                    // Gunakan transisi asimetris mandiri untuk ikan
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    )
                    )
                }
                
                // 2. Popup Obstacle
                if controller.showObstaclePopup {
                    Text(controller.latestObstacleMessage)
                        .font(.custom("Cause-Bold", size: 24))
                        .foregroundColor(Color("color_dark_blue"))
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        )
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .ignoresSafeArea()
            .animation(.spring(response: 0.4), value: controller.showCatchFishPopup)
            .animation(.spring(response: 0.4), value: controller.showObstaclePopup)
    
            // MARK: - SHIP PANEL (muncul saat kapal di-tap)
            if showShipPanel {
                ShipPanelView(controller: controller, closePanel: closePanel)
            }
            
            // MARK: - RESULT OVERLAY (muncul saat ekspedisi selesai)
            if controller.isExpeditionOver {
                ResultOverlayView(controller: controller, playerController: playerController)
            }
        }
        .onAppear {
            audio.playBGM_Wave()
            if let weather = appState.currentForecast {
                audio
                    .playBGM_Game(
                        filename: weather.actualWeather.soundName,
                        volume: 1.0
                    )
            }
            controller.onPlaySFX = { filename in
                audio.playSFX(filename: filename, volume: 0.8)
            }
            controller.hapticStyle = { style in
                audio.haptic(style: style)
            }
            
            setupScene()
            controller.startExpedition()
        }
        .onDisappear {
            audio.stopBGM_Wave()
            audio.stopBGM_Game()
        }
        .onChange(of: controller.isExpeditionOver) { _, isOver in
            if isOver {
                controller.gameScene?.pauseGame()
            }
        }
        .statusBar(hidden: true)
    }
    
    // MARK: - Setup GameScene
    private func setupScene() {
        let s = GameScene(size: CGSize(width: 844, height: 390))
        s.scaleMode     = .aspectFill
        s.shipImageName = controller.selectedShip.imageName
        s.weather       = controller.actualWeather
        
        s.onShipTapped = { [controller] in
            withAnimation(.spring(response: 0.35)) { showShipPanel = true }
            s.pauseGame()
            controller.pauseExpedition()
        }
        
        s.onFishCaught = { [controller] fishName in
            controller.catchFish(fishName)
        }
        
        controller.gameScene = s
        scene = s
    }
    // MARK: - Distance + Zone (kanan atas)
    private var distanceAndZone: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(String(format: "%.0f km", controller.distanceTravelledKm))
                .font(.custom("Cause-Bold", size: 16))
                .foregroundColor(Color("color_dark_blue"))
                .padding(.top, 15)
            
            VStack() {
                Image("zone_indicator_outline")
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        GeometryReader { geometry in
                            
                            // 1. Hitung persentase perjalanan (Rasio 0.0 sampai 1.0)
                            // Pastikan Anda menyesuaikan 'targetDistanceKm' dengan variabel di controller Anda
                            let safeRatio = getVisualProgressRatio(currentDistKm: controller.distanceTravelledKm)
                            
                            Image("zone_indicator_fill")
                                .resizable()
                                .scaledToFit()
                                .mask(
                                    HStack(spacing: 0) {
                                        Rectangle()
                                            .frame(
                                                width: geometry.size.width * CGFloat(safeRatio)
                                            )
                                        Spacer(minLength: 0)
                                    }
                                )
                                // 3. Tambahkan animasi agar pengisian bar terlihat mulus seperti air mengalir
                                .animation(.linear(duration: 0.5), value: controller.distanceTravelledKm)
                        }
                    )
                    .frame(width: 200, height: 100)
                
                Text(controller.currentZone?.name ?? "")
                    .font(.system(size: 10))
                    .foregroundColor(
                        Color(red: 0.08, green: 0.18, blue: 0.45).opacity(0.6)
                    )
            }
        }
    }
    
    private var currentZoneNumber: Int {
        guard let zone = controller.currentZone else { return 0 }
        switch zone.name {
        case "Zone 1": return 1
        case "Zone 2": return 2
        case "Zone 3": return 3
        case "Zone 4": return 4
        default:       return 0
        }
    }
    
    // MARK: - Helper Pengukur Visual Zona
    private func getVisualProgressRatio(currentDistKm: Double) -> Double {
        // 1. Definisikan mapping jarak (Data) ke visual layar (Gambar)
        // Asumsi: Gambar dibagi 4 kotak sama besar (0.25, 0.50, 0.75, 1.0)
        let zoneMappings: [(distStartKm: Double, distEndKm: Double, visStart: Double, visEnd: Double)] = [
            
            // z/675
            // CONTOH: Zona 1 sangat panjang (0 - 50 km), mengambil 25% pertama lebar gambar
            (distStartKm: 0.0, distEndKm: 30.0, visStart: 0.0, visEnd: 0.16), // 109/725
            
            // CONTOH: Zona 2 sangat pendek (50 - 60 km), mengambil 25% kedua lebar gambar
            (distStartKm: 30.0, distEndKm: 80.0, visStart: 0.16, visEnd: 0.22), // 166/725
            
            // CONTOH: Zona 3 sedang (60 - 85 km), mengambil 25% ketiga lebar gambar
            (distStartKm: 80.0, distEndKm: 150.0, visStart: 0.22, visEnd: 0.25), // 186/725
            
            // CONTOH: Zona 4 pendek (85 - 100 km), mengambil 25% terakhir lebar gambar
            (distStartKm: 150.0, distEndKm: 1000.0, visStart: 0.25, visEnd: 1.0)
        ]
        
        let safeDist = max(0.0, currentDistKm) // Cegah nilai minus
        
        // 2. Cari kita sedang berada di zona yang mana
        for zone in zoneMappings {
            if safeDist >= zone.distStartKm && safeDist <= zone.distEndKm {
                
                // 3. Hitung persentase progress HANYA di dalam zona tersebut
                let distRange = zone.distEndKm - zone.distStartKm
                let progressInZone = (safeDist - zone.distStartKm) / distRange
                
                // 4. Terjemahkan ke persentase ukuran gambar
                let visRange = zone.visEnd - zone.visStart
                let finalVisualRatio = zone.visStart + (progressInZone * visRange)
                
                return finalVisualRatio
            }
        }
        
        // Jika jarak sudah melebihi batas akhir (misal > 100 km), bar otomatis penuh 100% (1.0)
        return 1.0
    }
    
    private func closePanel() {
        withAnimation(.spring(response: 0.35)) { showShipPanel = false }
        scene?.resumeGame()
        controller.resumeExpedition()
    }
}

#Preview {
    InGamePage(
        controller: InGameController(
            ship: Ship.allShips[0],
            equippedItems: [],
            actualWeather: .windy
        )
    )
    .environment(AppStateManager())
    .environment(AudioManager())
}
