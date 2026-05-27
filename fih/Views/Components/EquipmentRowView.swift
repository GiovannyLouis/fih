//
//  EquipmentRowView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SpriteKit

struct EquipmentRowView: View {
    let item: Equipment
    let isSelected: Bool
    let action: () -> Void
        
    var body: some View {
        Button(action: action) {
            HStack {
                // Temporary SF Symbol until you add your real icons
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundColor(isSelected ? .yellow : .gray)
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.custom("Cause-Extrabold", size: 16))
                        .foregroundColor(Color("color_dark_blue"))
                    Text(item.description)
                        .font(.custom("patrickhand-regular", size: 14))
                        .foregroundColor(Color("color_dark_blue"))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .padding()
            .frame(width: 300, height: 90)
            .background(
                Image("card_background_white")
                    .resizable(
                            capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                            resizingMode: .stretch
                    )
                    .frame(width: 600, height: 180)
                    .scaleEffect(0.5)
                    .frame(width: 300, height: 90)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    // Gunakan strokeBorder agar garisnya menggambar ke arah dalam frame
                    .strokeBorder(isSelected ? Color("color_green") : Color.clear, lineWidth: 4)
                    .padding(-1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    // EquipmentRowView()
}
