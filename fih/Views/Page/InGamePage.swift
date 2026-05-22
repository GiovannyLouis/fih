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
    @State private var activeTooltipIndex: Int? = nil
    
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
                        .transition(
                            .move(edge: .bottom).combined(with: .opacity)
                        )
                }
                .animation(
                    .spring(response: 0.4),
                    value: controller.showEventPopup
                )
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
        HStack(alignment: .center, spacing: 10) {
            let angleInRadians = (
                -90 + 360 * controller.timer.progress
            ) * .pi / 180
            
            // Jam
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
                    .animation(
                        .linear(duration: 1),
                        value: controller.timer.progress
                    )
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
                        
                        let maxHealth: Double = Double(controller.selectedShip.maxDurability) // Ganti dengan
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
                        
                        // LAYER 2 (Tengah): Aset Outline (Statis / Tidak berubah ukuran)
                        Image("health_frame_outline") // TODO: Ganti dengan nama aset bingkai Anda
                            .resizable()
                            .frame(width: 110, height: 40)
                        
                        // LAYER 3 (Atas): Teks Angka Health
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
    
    
    // MARK: - Ship Panel (pause + info)
    private var shipPanel: some View {
        ZStack {
            // Tap di luar panel → tutup panel
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { closePanel() }
            
            // Kumpulan Komponen UI
            VStack(spacing: 16) { // Jarak antar kotak atas dan bawah
                
                // --- COMPONENT 3 (Di dalamnya sudah ada C1, C2, dan Tombol Play) ---
                component3_ExpeditionBox
                
                // --- COMPONENT 4 & TOMBOL HOME ---
                component4_FinishEarlyBox
            }
        }
    }
    
    // MARK: - COMPONENT 1: Kapal & Equipment
    private var component1_ShipDetails: some View {
        VStack(
            spacing: 0
        ) { // Ubah ke 0 agar spacing vertikal murni diatur frame
            Text(controller.selectedShip.name)
                .font(.custom("Cause-Bold", size: 24))
                .foregroundColor(Color("color_dark_blue"))
                .padding(.bottom, 8)
            
            HStack(spacing: 12) {
                // Kotak-kotak Equipment
                VStack(spacing: 8) {
                    ForEach(
                        0..<max(controller.selectedShip.equipmentSlots, 2),
                        id: \.self
                    ) { index in
                        equipmentSlot(index: index)
                    }
                }
                .zIndex(1)
                
                Spacer(minLength: 0)
                
                // Gambar Kapal
                Image(controller.selectedShip.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 70)
                Spacer()
            }
            .padding(.horizontal, 4)
            .frame(
                maxHeight: .infinity
            ) // Memaksa konten HStack mengambil sisa ruang box biru
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        ) // KUNCI: Mengikuti batas parent
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background (
            Image("card_background_cream")
                .resizable()
        )
    }
    
    // MARK: - COMPONENT 2: Fish Collected
    private var component2_FishCollected: some View {
        VStack(spacing: 0) { // Ubah ke 0 agar simetris dengan Component 1
            Text("Fish Collected")
                .font(.custom("Cause-Bold", size: 24))
                .foregroundColor(Color("color_dark_blue"))
                .padding(.bottom, 8)
            
            if controller.catchLog.isEmpty {
                Text("No fish yet...")
                    .font(.caption)
                    .foregroundColor(Color("color_dark_blue").opacity(0.5))
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                let groupedFish = Dictionary(
                    grouping: controller.catchLog,
                    by: { $0.name
                    })
                let sortedKeys = groupedFish.keys.sorted()
                
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 8) {
                        ForEach(sortedKeys, id: \.self) { fishName in
                            if let sampleFish = groupedFish[fishName]?.first,
                               let fishCount = groupedFish[fishName]?.count {
                                
                                HStack(spacing: 12) {
                                    // Icon Ikan
                                    Image(sampleFish.iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                    
                                    // Nama Ikan
                                    Text(fishName)
                                        .font(.custom("Cause-Bold", size: 16))
                                        .foregroundColor(
                                            Color("color_dark_blue")
                                        )
                                    
                                    Spacer()
                                    
                                    // 💡 LANGKAH 3: Tampilkan Jumlah Ikan di sisi kanan sebelum Spacer
                                    Text("\(fishCount)")
                                        .font(
                                            .custom("Cause-Bold", size: 16)
                                        ) // Menggunakan font game Anda agar serasi
                                        .foregroundColor(
                                            Color("color_dark_blue")
                                        )
                                        .padding(.trailing, 4)
                                }
                            }
                        }
                    }
                    .padding(.trailing, 8)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        ) // KUNCI: Mengikuti batas parent
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background (
            Image("card_background_cream")
                .resizable()
        )
    }
    
    // MARK: - COMPONENT 3: Expedition Details (Wrapper C1 & C2)
    private var component3_ExpeditionBox: some View {
        ZStack(alignment: .top) {
            
            // LAYER 1 (PALING BELAKANG): Kotak Krem & Isinya
            ZStack(alignment: .trailing) {
                
                // Background Kertas Krem
                Image("card_background_cream")
                    .resizable()
                
                // Konten (C1 & C2)
                HStack(spacing: 36) {
                    component1_ShipDetails
                    component2_FishCollected
                }
                .padding(.leading, 48)
                .padding(.trailing, 48)
                .padding(
                    .top,
                    48
                ) // Ditambah sedikit agar tulisan size 30 di dalam tidak menabrak judul atas
                .padding(.bottom, 24)
                
                // Tombol Play (Melayang di kanan kotak)
                Button(action: { closePanel() }) {
                    Image("button_play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                }
                .offset(x: 36)
            }
            // 💡 KUNCI FIX UTAMA: Kunci frame pembungkus luar ZStack-nya di sini setelah padding top selesai dihitung!
            .frame(width: 700, height: 250)
            .padding(.top, 24)
            
            // LAYER 2 (PALING DEPAN): Judul Melayang
            Text("Expedition Details")
                .font(.custom("Cause-Bold", size: 28))
                .foregroundColor(Color("color_dark_blue"))
                .padding(.horizontal, 36)
                .padding(.vertical, 2)
                .background(
                    Image("cream_button")
                        .resizable()
                        .frame(width: 420, height: 60)
                    //Capsule().fill(Color(red: 0.98, green: 0.97, blue: 0.91))
                )
                //
        }
        .padding(.top, 28)
    }
    
    // MARK: - COMPONENT 4: Finish Early Box
    private var component4_FinishEarlyBox: some View {
        // SAMA SEPERTI C3, MENGGUNAKAN ZSTACK AGAR TOMBOL BEBAS MELAYANG
        ZStack {
            
            // LAYER 1: Background Kertas Krem
            Image("card_background_cream")
                .resizable()
                .frame(width: 700, height: 80)
            
            // LAYER 2: Teks
            HStack {
                Text("Finish early to save your ship and secure your fish")
                    .font(.custom("Cause-Bold", size: 16))
                    .foregroundColor(Color("color_dark_blue"))
                Spacer()
            }
            .padding(.horizontal, 48)
            .frame(width: 700, height: 80)
            
            // LAYER 3: Tombol Home Melayang (Tarik ke kanan)
            HStack {
                Spacer()
                Button(action: {
                    closePanel()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        controller.abortExpedition()
                    }
                }) {
                    Image("button_home")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
                .offset(x: 32) // Geser ke luar kotak separuh badannya
            }
            .frame(width: 700, height: 80)
        }
    }
    
    // MARK: - Equipment slot helper
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
                
                // Gambar Equipment
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
        .overlay(
            Group {
                if index < controller.equippedItems.count && activeTooltipIndex == index {
                    let item = controller.equippedItems[index]
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.name)
                            .font(.custom("Cause-Bold", size: 14))
                            .foregroundColor(Color("color_dark_blue"))
                        
                        Text(item.description)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("color_dark_blue").opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(width: 180, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("color_dark_blue"), lineWidth: 2))
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 4)
                    )
                    // Menggeser pop-up ke kanan kotak equipment
                    .offset(x: 135)
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                }
            }
        )
        .onTapGesture {
            if index < controller.equippedItems.count {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    // Toggle logika
                    if activeTooltipIndex == index {
                        activeTooltipIndex = nil
                    } else {
                        activeTooltipIndex = index
                    }
                }
            }
        }
        .zIndex(activeTooltipIndex == index ? 100 : 0)
    }
    
    private func closePanel() {
        activeTooltipIndex = nil
        withAnimation(.spring(response: 0.35)) { showShipPanel = false }
        scene?.resumeGame()
        controller.resumeExpedition()
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
                // Background blur/dim
                Color.black.opacity(0.55).ignoresSafeArea()
                // Card
                VStack(spacing: 0) {

                    // MARK: - Title
                    Text(resultTitle.uppercased())
                        .font(.custom("Cause-Bold", size: 28))
                        .foregroundColor(Color("color_dark_blue"))
                        .padding(.top, 28)
                        .padding(.bottom, 20)

                    // MARK: - Divider
                    Rectangle()
                        .fill(Color("color_dark_blue").opacity(0.2))
                        .frame(height: 1)
                        .padding(.horizontal, 24)

                    // MARK: - Fish List
                    if controller.expeditionResults != .shipDestroyed && !controller.catchLog.isEmpty {
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(Array(controller.catchLog.enumerated()), id: \.offset) { _, fish in
                                    HStack(spacing: 12) {
                                        Image(fish.iconName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 44, height: 30)
                                        Text(fish.name)
                                            .font(.custom("Cause-Bold", size: 16))
                                            .foregroundColor(Color("color_dark_blue"))
                                        Spacer()
                                    }
                                    .padding(.horizontal, 28)
                                }
                            }
                            .padding(.vertical, 16)
                        }
                        .frame(height: 200)

                    } else if controller.expeditionResults == .shipDestroyed {
                        // Ship destroyed — tampilkan pesan
                        VStack(spacing: 8) {
                            Text(resultSubtitle)
                                .font(.custom("Cause-Bold", size: 16))
                                .foregroundColor(Color("color_dark_blue").opacity(0.6))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 28)
                        }
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)

                    } else {
                        // No fish
                        Text("No fish collected.")
                            .font(.custom("Cause-Bold", size: 16))
                            .foregroundColor(Color("color_dark_blue").opacity(0.4))
                            .frame(height: 200)
                    }

                    // MARK: - Return to Home Button
                    Button(action: {
                        playerController.incrementDays(context: context)
                        playerController.collectFish(context: context, catchFish: controller.catchLog)
                        appState.currentScreen = .mainMenuPage
                        appState.resetForecast()
                    }) {
                        Text("Return to Home")
                            .font(.custom("Cause-Bold", size: 18))
                            .foregroundColor(Color("color_dark_blue"))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(
                                Image("green_button")
                                    .resizable()
                                    .scaledToFill()
                            )
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 28)
                }
                .frame(width: 560)
                .background(
                    Image("card_background_cream")
                        .resizable()
                        .scaledToFill()
                )
                .cornerRadius(16)
                .padding(.bottom, 50)
                .padding(.top, 70)
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
