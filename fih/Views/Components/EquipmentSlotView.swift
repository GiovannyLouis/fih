//
//  EquipmentSlotView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

import SwiftUI
import SpriteKit

struct EquipmentSlotView: View {
    let iconName: String? // Nil means the slot is empty
    
    var bgScene: SKScene {
        let scene = CardBackgroundScene()
        // We ensure the scene matches the SwiftUI frame exactly
        scene.size = CGSize(width: 60, height: 60)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            // REMOVED: RoundedRectangle() that was painting the box black
            
            if let icon = iconName {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("color_dark_blue"))
            }
        }
        // Set the size directly on the container ZStack
        .frame(width: 60, height: 60)
        // Attach your 9-sliced SpriteKit view underneath
        .background (
            SpriteView(scene: bgScene, options: [.allowsTransparency])
        )
    }
}

#Preview {
    // EquipmentSlotView()
}
