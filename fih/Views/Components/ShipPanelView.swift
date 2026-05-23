//
//  ShipPanelView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 23/05/26.
//

import SwiftUI

struct ShipPanelView: View {
    
    let controller: InGameController
    let closePanel: () -> Void
    @State private var activeTooltipIndex: Int? = nil
    
    var body: some View {
        ZStack {
            // Tap di luar panel → tutup panel
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { closePanel() }
            
            // Kumpulan Komponen UI
            VStack(spacing: 4) { // Jarak antar kotak atas dan bawah
                
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
                        
                        // 1. Cek apakah slot ini ada isinya atau kosong
                        let isEquipped = index < controller.equippedItems.count
                        let item = isEquipped ? controller.equippedItems[index] : nil
                        
                        // 2. Panggil View eksternal Anda (onRemove dikosongkan agar tombol merah hilang)
                        EquipmentSlotView(
                            iconName: item?.imageName,
                            onRemove: nil
                        )
                        // 3. Tempelkan modifier overlay & tap gesture khusus untuk InGamePage
                        .overlay(
                            Group {
                                // Tampilkan Tooltip hanya jika ada item dan sedang aktif
                                if let validItem = item, activeTooltipIndex == index {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(validItem.name)
                                            .font(.custom("Cause-Bold", size: 14))
                                            .foregroundColor(Color("color_dark_blue"))
                                        
                                        Text(validItem.description)
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
                                    .offset(x: 135)
                                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                                }
                            }
                        )
                        .onTapGesture {
                            // Tap hanya berfungsi jika ada itemnya
                            if isEquipped {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
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
            .padding(.vertical, 4)
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
                    .resizable(
                            capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                            resizingMode: .stretch
                    )
                    .frame(width: 1400, height: 550)
                    .scaleEffect(0.5)
                    .frame(width: 700, height: 275)
                    
                
                // Konten (C1 & C2)
                HStack(spacing: 36) {
                    component1_ShipDetails
                    component2_FishCollected
                }
                .padding(.leading, 50)
                .padding(.trailing, 50)
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
            .frame(width: 700, height: 275)
            .padding(.top, 16)
            
            // LAYER 2 (PALING DEPAN): Judul Melayang
            Text("Expedition Details")
                .font(.custom("Cause-Bold", size: 28))
                .foregroundColor(Color("color_dark_blue"))
                .padding(.horizontal, 36)
                .padding(.vertical, 2)
                .background(
                    Image("cream_button")
                        .resizable(
                                capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                                resizingMode: .stretch
                        )
                        .frame(width: 840, height: 40)
                        .scaleEffect(0.5)
                        .frame(width: 420, height: 20)
                )
                //
        }
        .padding(.top, 32)
    }
    
    // MARK: - COMPONENT 4: Finish Early Box
    private var component4_FinishEarlyBox: some View {
        // SAMA SEPERTI C3, MENGGUNAKAN ZSTACK AGAR TOMBOL BEBAS MELAYANG
        ZStack {
            
            // LAYER 1: Background Kertas Krem
            Image("card_background_cream")
                .resizable(
                        capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                        resizingMode: .stretch
                )
                .frame(width: 1400, height: 160)
                .scaleEffect(0.5)
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
}

#Preview {
    ShipPanelView(
        controller: InGameController(
            ship: Ship.allShips[0], // Sesuaikan dengan cara Anda memanggil dummy ship
            equippedItems: [],
            actualWeather: .windy
        ),
        closePanel: {
            print("Tombol close ditekan dari preview")
        }
    )
}
