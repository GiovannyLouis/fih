//
//  ShipCardView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SpriteKit

// MARK: - VIEW (Ship Card)
struct ShipCardView: View {
    let ship: Ship
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isFloating: Bool = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                
                Text(ship.name)
                    .font(.custom("Cause-ExtraBold", size: 20))
                    .foregroundColor(Color("color_dark_blue"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
               
                Image(ship.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 60)
                    .padding(.vertical, 5)
                
                Spacer(minLength: 0)
                
                // 3. Stats Row
                HStack(spacing: 16) {
                    StatView(icon: "icon_speed", value: "\(ship.maxSpeed)")
                    StatView(icon: "icon_health", value: "\(ship.maxDurability)")
                    StatView(icon: "icon_equipment", value: "\(ship.equipmentSlots)")
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .frame(width: 200, height: 180)
            .background(
                Image("card_background_cream")
                    .resizable(
                        capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                        resizingMode: .stretch // Can also be .tile
                    )
                    .frame(width: 400, height: 360)
                    .scaleEffect(0.5)
                    .frame(width: 200, height: 180)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color("color_green") : Color.clear, lineWidth: 8)
                    .padding(-6)
            )
            .offset(y: isFloating ? -2 : 2)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                    isFloating = true
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    // ShipCardView()
}
