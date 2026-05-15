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
    
    var bgScene: SKScene {
        let scene = CardBackgroundScene()
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
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6))
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
                HStack(spacing: 12) {
                    StatView(icon: "speedometer", value: "\(ship.maxSpeed)")
                    StatView(icon: "heart", value: "\(ship.maxDurability)")
                    StatView(icon: "wrench.and.screwdriver", value: "\(ship.equipmentSlots)")
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 20) // Controlled vertical padding
            .frame(width: 200, height: 180)
            .background(
                SpriteView(scene: bgScene, options: [.allowsTransparency])
            )
            .scaleEffect(isSelected ? 1.05 : 1.0) // Slightly smaller scale for safety
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    // ShipCardView()
}
