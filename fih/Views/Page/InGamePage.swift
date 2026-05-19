////
////  PlayingPage.swift
////  PilihKapal
////
////  Created by Satriya Handha Wibowo on 13/05/26.
////
//
//import SwiftUI
//import SpriteKit
//
//struct InGamePage: View {
//    let controller: inGameController
//
//    @Environment(AppStateManager.self) private var appState
//    @State private var scene : GameScene? = nil
//    @State private var showShipPanel: Bool = false
//
//    var body: some View {
//        ZStack {
//            if let scene = scene {
//                SpriteView(scene: scene, options: [.allowsTransparency])
//                    .ignoresSafeArea()
//                    .blur(radius: showShipPanel ? 8 : 0)
//                    .animation (.easeInOut(duration: 0.25), value: showShipPanel)
//            } else {
//                Color(red: 0.97, green: 0.97, blue: 0.97).ignoresSafeArea()
//            }
//            VStack {
//                HStack (alignment : .top){
//                    clockAndStats
//                    Spacer()
//                    distanceAndZone
//                }
//                .padding(.horizontal, 16)
//                .padding(.top, 12)
//                Spacer()
//
//            }
//        }
//    }
//}
//
//#Preview {
//    InGamePage()
//        .environment(AppStateManager())
//}


//
//  InGamePage.swift
//  fih
//
//  Created by Muhammad Dzakki Abdullah on 13/05/26.
//

import SwiftUI
import SpriteKit

struct InGamePage: View {

    let controller: InGameController

    @Environment(AppStateManager.self) private var appState

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
            if controller.showEventPopup {
                VStack {
                    Spacer()
                    Text(controller.latestEventMessage)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 9)
                        .background(Color.black.opacity(0.72))
                        .cornerRadius(18)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.spring(response: 0.4), value: controller.showEventPopup)
            }

            // MARK: - SHIP PANEL (muncul saat kapal di-tap)
            if showShipPanel {
                shipPanel
            }

            // MARK: - RESULT OVERLAY (muncul saat ekspedisi selesai)
            if controller.isExpeditionOver {
                resultOverlay
            }
        }
        .onAppear {
            setupScene()
            controller.startExpedition()
        }
        .statusBar(hidden: true)
    }

    // MARK: - Setup GameScene
    // Dibuat satu kali di onAppear, disimpan ke @State
    // Semua callback disambungkan di sini — GameScene tidak import controller

    private func setupScene() {
        let s = GameScene(size: CGSize(width: 844, height: 390))
        s.scaleMode     = .aspectFill
        s.shipImageName = controller.selectedShip.imageName

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
        HStack(alignment: .center, spacing: 10) {
            ZStack {
                Circle()
                    .stroke(
                        Color(red: 0.08, green: 0.18, blue: 0.45).opacity(0.15),
                        lineWidth: 4
                    )
                    .frame(width: 64, height: 64)

                Circle()
                    .trim(from: 0, to: controller.timer.progress)
                    .stroke(
                        Color(red: 0.08, green: 0.18, blue: 0.45),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 64, height: 64)
                    .rotationEffect(.degrees(-90)) // mulai dari atas
                    .animation(.linear(duration: 1), value: controller.timer.progress)

                // Titik kecil di ujung progress arc
                Circle()
                    .fill(Color(red: 0.08, green: 0.18, blue: 0.45))
                    .frame(width: 8, height: 8)
                    .offset(y: -32)
                    .rotationEffect(.degrees(-90 + controller.timer.progress * 360))
                    .animation(.linear(duration: 1), value: controller.timer.progress)

                Text(clockText)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.45))
            }
            .frame(width: 64, height: 64)

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
                            Image("health_frame")
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
                                            .frame(width: geometry.size.width * (CGFloat(currentZoneNumber) / 4.0))
                                        Spacer(minLength: 0)
                                    }
                                )
                        }
                    )
                    .frame(width: 200, height: 100)
                
                Text(controller.currentZone?.name ?? "")
                    .font(.system(size: 10))
                    .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.45).opacity(0.6))
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

    // MARK: - Ship Panel (pause + info)

    private var shipPanel: some View {
        ZStack {
            // Tap di luar panel → tutup panel
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { closePanel() }

            VStack(spacing: 0) {
                // Handle bar
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 10)

                Text(controller.selectedShip.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.45))
                    .padding(.bottom, 16)

                HStack(alignment: .top, spacing: 20) {

                    // Kolom kiri: Equipment
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Equipment", systemImage: "wrench.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.45))

                        if controller.equippedItems.isEmpty {
                            Text("None").font(.caption).foregroundColor(.gray)
                        } else {
                            ForEach(controller.equippedItems) { item in
                                HStack(spacing: 6) {
                                    Image(systemName: equipmentIcon(item.type))
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .background(Color(red: 0.08, green: 0.18, blue: 0.45))
                                        .cornerRadius(5)
                                    Text(item.name)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.45))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()

                    // Kolom kanan: Catch log
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Catch (\(controller.catchLog.count))", systemImage: "fish.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.45))

                        if controller.catchLog.isEmpty {
                            Text("No fish yet").font(.caption).foregroundColor(.gray)
                        } else {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 3) {
                                    ForEach(Array(controller.catchLog.enumerated()), id: \.offset) { _, fish in
                                        Text("• \(fish)")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.45))
                                    }
                                }
                            }
                            .frame(maxHeight: 110)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)

                Divider().padding(.vertical, 14)

                // Buttons
                HStack(spacing: 12) {
                    // Resume
                    Button(action: { closePanel() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "play.fill")
                            Text("Resume").fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame (height: 44)
                        .background(Color(red: 0.08, green: 0.18, blue: 0.45))
                        .cornerRadius(22)
                    }

                    // Go Home (abort)
                    Button(action: {
                        closePanel()
                        // Delay supaya panel selesai animasi tutup dulu
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            controller.abortExpedition()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "house.fill")
                            Text("Go Home").fontWeight(.semibold)
                        }
                        .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.45))
                        .frame(maxWidth: .infinity)
                        .frame (height: 44)
                        .background(Color.yellow)
                        .cornerRadius(22)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(.horizontal, 32)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private func closePanel() {
        withAnimation(.spring(response: 0.35)) { showShipPanel = false }
        scene?.resumeGame()               // SpriteKit resume
        controller.resumeExpedition()    // timer + movement + event jalan lagi
    }

    private func equipmentIcon(_ type: EquipmentType) -> String {
        switch type {
        case .shield:          return "shield.fill"
        case .rocketThrusters: return "bolt.fill"
        case .predatorBait:    return "fish"
        case .scarecrow:       return "bird.fill"
        case .guardianAngel:   return "sparkles"
        case .luckyHat:        return "hat.widebrim"
        case .soulEater:       return "heart.fill"
        }
    }

    // MARK: - Result Overlay

    private var resultOverlay: some View {
        ZStack {
            Color.black.opacity(0.72).ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: controller.expeditionResults == .shipDestroyed
                      ? "xmark.octagon.fill" : "checkmark.seal.fill")
                    .font(.system(size: 56))
                    .foregroundColor(controller.expeditionResults == .shipDestroyed
                                     ? .red : Color(red: 0.15, green: 0.75, blue: 0.35))

                Text(resultTitle)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)

                Text(resultSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)

                if controller.expeditionResults != .shipDestroyed && !controller.catchLog.isEmpty {
                    VStack(spacing: 5) {
                        Text("🐟 \(controller.catchLog.count) fish saved")
                            .font(.headline).foregroundColor(.cyan)
                        ForEach(Array(controller.catchLog.prefix(5).enumerated()), id: \.offset) { _, fish in
                            Text("• \(fish)").font(.caption).foregroundColor(.white.opacity(0.85))
                        }
                        if controller.catchLog.count > 5 {
                            Text("+ \(controller.catchLog.count - 5) more")
                                .font(.caption).foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }

                // Kembali ke pilih kapal
                // InGamePage yang handle navigasi — bukan controller
                Button(action: {
                    appState.currentScreen = .selectShipPage
                }) {
                    Text("New Expedition")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 48)
                        .background(Color(red: 0.08, green: 0.18, blue: 0.45))
                        .cornerRadius(24)
                }
                .padding(.top, 4)
            }
            .padding(36)
        }
        .transition(.opacity)
        .animation(.easeIn(duration: 0.3), value: controller.isExpeditionOver)
    }

    private var resultTitle: String {
        switch controller.expeditionResults {
        case .shipDestroyed: return "Shipwrecked!"
        case .safeReturn:    return "Safe Return!"
        case .timeUp:        return "Time's Up!"
        case .inProgress:    return ""
        }
    }

    private var resultSubtitle: String {
        switch controller.expeditionResults {
        case .shipDestroyed: return "Your ship sank.\nAll fish were lost."
        case .safeReturn:    return "You returned safely with your catch."
        case .timeUp:        return "The fishing day is over."
        case .inProgress:    return ""
        }
    }
}
