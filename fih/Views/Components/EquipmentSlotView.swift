//
//  EquipmentSlotView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

struct EquipmentSlotView: View {
    let iconName: String? // Nil means the slot is empty
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 1.0, green: 0.98, blue: 0.9))
                .frame(width: 60, height: 60)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            
            if let _ = iconName { // When you have real images, use: let icon = iconName
                Image(systemName: "shield.fill") // Replace with Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    // EquipmentSlotView()
}
