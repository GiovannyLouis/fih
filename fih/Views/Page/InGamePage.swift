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
                    Spacer()
                    DistanceAndZoneView(controller: controller)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                Spacer()
            }
            .padding(12)
            .ignoresSafeArea()
            
            
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
                audio.playBGM_Game(
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
            equippedItems: [.allEquipment[2]],
            actualWeather: .rainy
        )
    )
    .environment(AppStateManager())
    .environment(AudioManager())
}
