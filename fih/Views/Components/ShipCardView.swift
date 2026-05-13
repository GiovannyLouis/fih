//
//  ShipCardView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

// MARK: - VIEW (Ship Card)
struct ShipCardView: View {
    let ship: Ship
    let isSelected: Bool
    let action: () -> Void // The action to run when tapped
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                // Ship Name
                Text(ship.name)
                    .font(.custom("Cause-ExtraBold", size: 21))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.6)) // Dark Navy Blue
                
                // Ship Image
                // NOTE: Replace the systemName with Image(ship.imageName) when you add your real assets
                Image(systemName: "sailboat.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .foregroundColor(.cyan)
                    .padding(.vertical, 10)
                
                // Stats (Using SF Symbols to match your design)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "speedometer")
                        Text("\(ship.maxSpeed)")
                    }
                    HStack {
                        Image(systemName: "heart")
                        Text("\(ship.maxDurability)")
                    }
                    HStack {
                        Image(systemName: "wrench.and.screwdriver")
                        Text("\(ship.equipmentSlots)")
                    }
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
            }
            .padding()
            .frame(width: 160, height: 260)
            .background(Color(red: 1.0, green: 0.98, blue: 0.9)) // Light yellow background
            .cornerRadius(10)
            // Add the blue border from your design
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.1, green: 0.1, blue: 0.6), lineWidth: isSelected ? 4 : 2)
            )
            // This is the magic part: Scales the card up by 10% if selected!
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default button flashing
    }
}

#Preview {
    //ShipCardView()
}
