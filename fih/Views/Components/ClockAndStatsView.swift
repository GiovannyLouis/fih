//
//  ClockAndStatsView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 23/05/26.
//

import SwiftUI

struct ClockAndStatsView: View {
    
    let controller: InGameController
    
    private var clockText: String {
        let totalMinutes = Int(controller.timer.gameHoursElapsed * 60)
        let hour   = 9 + totalMinutes / 60
        let minute = totalMinutes % 60
        return String(format: "%02d:%02d", hour, minute)
    }
    
    var body: some View {
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
}

#Preview {
    //ClockAndStatsView()
}
