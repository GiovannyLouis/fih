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
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            ZStack {
                if let icon = iconName {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("color_dark_blue"))
                }
            }
            .frame(width: 60, height: 60)
            .background(
                Image("card_background_white")
                    .resizable(
                            capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                            resizingMode: .stretch
                    )
                    .frame(width: 60, height: 60)
                    .scaleEffect(0.5)
                    .frame(width: 30, height: 30)
            )
            
            if iconName != nil {
                Button(action: {
                    onRemove?()
                }) {
                    Image("icon_close_red")
                        .resizable()
                        .frame(width: 25, height: 25)
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
