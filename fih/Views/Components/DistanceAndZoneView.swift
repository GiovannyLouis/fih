//
//  DistanceAndZoneView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 24/05/26.
//

import SwiftUI

struct DistanceAndZoneView: View {
    
    let controller: InGameController
    
    private func getVisualProgressRatio(currentDistKm: Double) -> Double {
        let zoneMappings: [(distStartKm: Double, distEndKm: Double, visStart: Double, visEnd: Double)] = [
            (distStartKm: 0.0, distEndKm: 30.0, visStart: 0.1, visEnd: 0.20),
            (distStartKm: 30.0, distEndKm: 80.0, visStart: 0.20, visEnd: 0.43),
            (distStartKm: 80.0, distEndKm: 150.0, visStart: 0.43, visEnd: 0.679),
            (distStartKm: 150.0, distEndKm: 1000.0, visStart: 0.679, visEnd: 1.0)
        ]
        
        let safeDist = max(0.0, currentDistKm)
        
        for zone in zoneMappings {
            if safeDist >= zone.distStartKm && safeDist <= zone.distEndKm {
                let distRange = zone.distEndKm - zone.distStartKm
                let progressInZone = (safeDist - zone.distStartKm) / distRange
                
                let visRange = zone.visEnd - zone.visStart
                let finalVisualRatio = zone.visStart + (progressInZone * visRange)
                
                return finalVisualRatio
            }
        }
        return 1.0
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(String(format: "%.0f km", controller.distanceTravelledKm))
                .font(.custom("Cause-Bold", size: 16))
                .foregroundColor(Color("color_dark_blue"))
                .padding(.top, 15)
            
            VStack {
                // 💡 OUTLINE SEBAGAI JANGKAR UTAMA (LAYER ATAS)
                Image("zone_indicator_outline")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 86) // Mengunci tinggi di sini
                    .background(
                        // 💡 FILL SEKARANG DI JADIKAN BACKGROUND (LAYER BAWAH)
                        // GeometryReader di sini akan mengikuti ukuran pasti dari Gambar Outline di atasnya
                        GeometryReader { geometry in
                            let safeRatio = getVisualProgressRatio(currentDistKm: controller.distanceTravelledKm)
                            
                            Image("zone_indicator_fill")
                                .resizable()
                                // Paksa ukuran fill mengikuti lebar & tinggi outline secara absolut
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .mask(
                                    HStack(spacing: 0) {
                                        Rectangle()
                                            .frame(width: geometry.size.width * CGFloat(safeRatio))
                                        Spacer(minLength: 0)
                                    }
                                )
                                .animation(.linear(duration: 0.5), value: controller.distanceTravelledKm)
                        }
                    )
                
                Text(controller.currentZone?.name ?? "")
                    .font(.system(size: 10))
                    .foregroundColor(Color("color_dark_blue").opacity(0.6))
            }
        }
    }
}
