//
//  EquipmentSlotView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SpriteKit

struct EquipmentSlotView: View {
    let iconName: String?
    
    var onRemove: (() -> Void)? = nil
    
    var bgScene: SKScene {
        let scene = CreamBackgroundScene()
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            ZStack {
                SpriteView(scene: bgScene, options: [.allowsTransparency])
                
                if let icon = iconName {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("color_dark_blue"))
                }
            }
            .frame(width: 60, height: 60)
            
            if iconName != nil {
                Button(action: {
                    onRemove?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white)) 
                }
                .offset(x: 8, y: -8)
            }
        }
    }
}

#Preview {
    // EquipmentSlotView()
}
