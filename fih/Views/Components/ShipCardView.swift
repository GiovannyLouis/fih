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
    
    var bgScene: SKScene {
        let scene = CreamBackgroundScene()
        // We ensure the scene matches the SwiftUI frame exactly
        scene.size = CGSize(width: 200, height: 180)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) { // Reduced spacing from 15 to 8
                
                // 1. Ship Name with protection
                Text(ship.name)
                    .font(.custom("Cause-ExtraBold", size: 20))
                    .foregroundColor(Color("color_dark_blue"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7) // Shrinks font if name is too long
                
                // 2. Normalized Ship Image
                // This "box" is now identical for every boat
                Image(ship.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 60) // Fixed box for all ships
                    .padding(.vertical, 5)
                
                Spacer(minLength: 0) // Pushes stats to the bottom
                
                // 3. Stats Row
                HStack(spacing: 16) {
                    StatView(icon: "speedometer", iconColor: .black, value: "\(ship.maxSpeed)")
                    StatView(icon: "heart.fill", iconColor: .red, value: "\(ship.maxDurability)")
                    StatView(icon: "gearshape.fill", iconColor: .gray, value: "\(ship.equipmentSlots)")
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20) // Controlled vertical padding
            .frame(width: 200, height: 180)
//            .background(
//                SpriteView(scene: bgScene, options: [.allowsTransparency])
//                    .clipShape(RoundedRectangle(cornerRadius: 9)) // Mengunci background di dalam radius 8
//            )
//
//            // 2. PERBAIKAN OVERLAY: Gunakan strokeBorder, bukan stroke
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    // strokeBorder memaksa seluruh ketebalan 6px masuk ke dalam frame kartu,
//                    // sehingga tidak ada garis yang meluber keluar dan terpotong oleh parent layout
//                    .strokeBorder(isSelected ? Color("color_green") : Color.clear, lineWidth: 6)
//            )
            .background(
                Image(isSelected ? "card_background_cream_selected" : "card_background_cream")
                    .resizable()
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
