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
import SwiftData

struct InGamePage: View {

    let controller: InGameController

    @Environment(AppStateManager.self) private var appState
    
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
        HStack(alignment: .center, spacing: 10) {
            let angleInRadians = (-90 + 360 * controller.timer.progress) * .pi / 180
            ZStack {
                Image("indicator_line")
                    .resizable()
                    .frame(width: 64, height: 100)

                Image("indicator_dot")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .offset(
                        x: 32 * cos(angleInRadians),
                        y: 50 * sin(angleInRadians)
                    )
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

                // MARK: - Panel utama
                ZStack {
                    // Background asset
                    Image("card_background_cream")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                        .padding(.horizontal,10)

                    VStack(spacing: 0) {

                        // Title
                        Text("Expedition Details")
                            .font(.custom("Cause-Bold", size: 20))
                            .foregroundColor(Color("color_dark_blue"))
                            .padding(.horizontal, 28)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color("card_background_cream"))
                                    .overlay(Capsule().stroke(Color("color_dark_blue"), lineWidth: 2.5))
                            )
                            .padding(.top, 14)
                            .padding(.bottom, 10)

                        HStack(alignment: .top, spacing: 0) {

                            // MARK: - Kiri: Equipment slots + kapal
                            HStack(spacing: 12) {

                                // Equipment slots (kotak-kotak)
                                VStack(spacing: 8) {
                                    ForEach(0..<max(controller.selectedShip.equipmentSlots, 2), id: \.self) { index in
                                        equipmentSlot(index: index)
                                    }
                                }

                                // Gambar kapal
                                Image(controller.selectedShip.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)

                            // Divider vertikal
                            Rectangle()
                                .fill(Color("color_dark_blue"))
                                .frame(width: 2)
                                .padding(.vertical, 8)

                            // MARK: - Kanan: Fish Collected
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Fish Collected")
                                    .font(.custom("Cause-Bold", size: 16))
                                    .foregroundColor(Color("color_dark_blue"))
                                    .frame(maxWidth: .infinity, alignment: .center)

                                if controller.catchLog.isEmpty {
                                    Text("No fish yet...")
                                        .font(.caption)
                                        .foregroundColor(Color("color_dark_blue").opacity(0.4))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.top, 20)
                                } else {
                                    ScrollView(showsIndicators: true) {
                                        VStack(spacing: 6) {
                                            ForEach(Array(controller.catchLog.enumerated()), id: \.offset) { _, fish in
                                                HStack(spacing: 10) {
                                                    Image(fish.iconName)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 48, height: 32)
                                                    Text(fish.name)
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundColor(Color("color_dark_blue"))
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxHeight: 160)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 12)
                        }
                        .padding(.bottom, 12)
                    }
                }
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("color_dark_blue"), lineWidth: 2.5)
                )
                .padding(.horizontal, 16)

                // MARK: - Bottom bar
                HStack(spacing: 0) {
                    Text("Finish early to save your ship and secure your fish")
                        .font(.custom("Cause-Bold", size: 14))
                        .foregroundColor(Color("color_dark_blue"))
                        .padding(.leading, 20)
                        .padding(.vertical, 14)

                    Spacer()

                    // Tombol Home merah
                    Button(action: {
                        closePanel()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            controller.abortExpedition()
                        }
                    }) {
                        Image("button_home")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                    .padding(.trailing, 10)
                    .padding(.vertical, 15)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.97, green: 0.93, blue: 0.78))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("color_dark_blue"), lineWidth: 2.5)
                        )
                )
                .padding(.horizontal, 16)
                .padding(.top, 6)
            }

            // MARK: - Tombol Resume (teal, floating di kanan luar panel)
            HStack {
                Spacer()
                VStack {
                    Button(action: { closePanel() }) {
                        Image("button_play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 2, y: 3)
                    }
                    .padding(100)
                    .position(x: 730, y: 180)
                }
            }
        }
    }
    // MARK: - Equipment slot helper
    // Dipakai di shipPanel — satu kotak equipment
    private func equipmentSlot(index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.93, green: 0.91, blue: 0.82))
                .frame(width: 65, height: 65)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("color_dark_blue"), lineWidth: 2)
                )

            if index < controller.equippedItems.count {
                let item = controller.equippedItems[index]
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46, height: 46)
            } else {
                // Slot kosong
                Image(systemName: "square.dashed")
                    .font(.system(size: 26))
                    .foregroundColor(Color("color_dark_blue").opacity(0.25))
            }
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
                            Text("• \(fish.name)").font(.caption).foregroundColor(.white.opacity(0.85))
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
                    playerController.incrementDays(context: context)
                    playerController.collectFish(context: context, catchFish: controller.catchLog)
                    appState.currentScreen = .mainMenuPage
                    appState.resetForecast()
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

#Preview {
    InGamePage(controller: InGameController(ship: Ship.allShips[0], equippedItems: [], actualWeather: .sunny))
        .environment(AppStateManager())
}
