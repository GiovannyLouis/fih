//
//  EquipmentSlotView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

struct EquipmentSlotView: View {
    let iconName: String?
    var onRemove: (() -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                Image("card_background_cream")
                    .resizable(
                        capInsets: EdgeInsets(top: 70, leading: 70, bottom: 70, trailing: 70),
                        resizingMode: .stretch
                    )
                    .frame(width: 130, height: 130)
                    .scaleEffect(0.5)
                    .frame(width: 65, height: 65)
                
                if let icon = iconName {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
                } else {
                    Image(systemName: "square.dashed")
                        .font(.system(size: 26))
                        .foregroundColor(Color("color_dark_blue").opacity(0.25))
                }
            }
            .frame(width: 65, height: 65)
            
            // Tombol hanya muncul jika onremove diberikan tidak nil
            if let onRemoveAction = onRemove, iconName != nil {
                Button(action: {
                    onRemoveAction()
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
