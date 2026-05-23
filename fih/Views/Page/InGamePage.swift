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
                    clockAndStats   // kiri: jam + health + speed
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
                //resultOverlay
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
    
    // MARK: - Jam + Health + Speed (kiri atas)
    private var clockAndStats: some View {
        HStack(alignment: .center, spacing: 15) {
            
            // Jam
            ZStack {
                let angleInDegrees = 90.0 - (180.0 * controller.timer.progress)
                let angleInRadians = angleInDegrees * .pi / 180.0
                
                let radius: CGFloat = 43.0
                
                Image("indicator_line")
                    .resizable()
                    .frame(width: 43, height: 86)
                    .offset(x: 21.5)
                
                Image("indicator_dot")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .offset(
                        x: radius * cos(angleInRadians),
                        y: -radius * sin(angleInRadians)
                    )
                    .animation(
                        .linear(duration: 1),
                        value: controller.timer.progress
                    )
                
                Text(clockText)
                    .font(.custom("Cause-Extrabold", size: 24))
                    .foregroundColor(Color("color_dark_blue"))
                    .offset(x: -12)
            }
            .frame(width: 86, height: 86)
            
            // Health bar and speed
            VStack(alignment: .leading, spacing: 6) {
                
                // Health bar
                HStack(spacing: 6) {
                    ZStack {
                        Image("icon_health")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    
                    ZStack(alignment: .leading) {
                        let maxHealth: Double = Double(controller.selectedShip.maxDurability)
                        let healthRatio = max(0, controller.currentHealth / maxHealth)
                        
                        
                        // LAYER 1 (Bawah): Aset Isi (Fill)
                        Image("health_frame_fill")
                            .resizable()
                            .frame(width: 110, height: 40)
                            .mask(
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .frame(width: 110 * healthRatio)
                                    Spacer(minLength: 0)
                                }
                            )
                            .animation(.easeInOut(duration: 0.3), value: controller.currentHealth)
                         
                        Image("health_frame_outline")
                            .resizable()
                            .frame(width: 110, height: 40)
                        
                        Text("\(Int(controller.currentHealth))")
                            .frame(width: 110)
                            .font(.custom("Cause-Bold", size: 16))
                            .foregroundColor(Color("color_dark_blue"))
                    }
                }
            
                
                // Speed
                HStack(spacing: 6) {
                    ZStack {
                        Image("icon_speed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    Text(String(format: "%.0f knots", controller.currentSpeed))
                        .font(.custom("Cause-Bold", size: 16))
                        .foregroundColor(Color("color_dark_blue"))
                }
            }
        }
    }
    
    private var clockText: String {
        let totalMinutes = Int(controller.timer.gameHoursElapsed * 60)
        let hour   = 9 + totalMinutes / 60
        let minute = totalMinutes % 60
        return String(format: "%02d:%02d", hour, minute)
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
                            Image("zone_indicator_fill")
                                .resizable()
                                .scaledToFit()
                                .mask(
                                    HStack(spacing: 0) {
                                        Rectangle()
                                            .frame(
                                                width: geometry.size
                                                    .width * (
                                                        CGFloat(
                                                            currentZoneNumber
                                                        ) / 4.0
                                                    )
                                            )
                                        Spacer(minLength: 0)
                                    }
                                )
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
