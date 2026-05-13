//
//  EquipmentRowView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

struct EquipmentRowView: View {
    let item: Equipment
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Temporary SF Symbol until you add your real icons
                Image(systemName: "shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(isSelected ? .yellow : .gray)
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : Color(red: 0.1, green: 0.3, blue: 0.5))
                    Text(item.description)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.6) : Color.blue.opacity(0.1))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    // EquipmentRowView()
}
