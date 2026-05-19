//
//  FishCardView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 20/05/26.
//

import SwiftUI

struct FishCardView: View {
    let isLocked: Bool
    let name: String
    let description: String
    let icon: String
    var imageOnRight: Bool = false
    
    // Warna biru gelap khusus untuk teks dan ikon agar sesuai dengan tema gambar
    let darkBlueTheme = Color(red: 0.1, green: 0.1, blue: 0.5)
    
    var body: some View {
        Group {
            if isLocked {
                // --- LOCKED STATE BARU ---
                HStack(spacing: 15) {
                    Image(systemName: "lock")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(darkBlueTheme)
                        .frame(width: 40)
                    
                    Text("You have not caught\nthis fish yet")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(darkBlueTheme)
                        //.multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.82, green: 0.82, blue: 0.82)) // Abu-abu terang
                )
                // Menambahkan garis tepi (outline) pada kotak terkunci
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(darkBlueTheme.opacity(0.6), lineWidth: 2)
                )
                
            } else {
                // --- UNLOCKED STATE BARU ---
                HStack(spacing: 15) {
                    
                    // Gambar Ikan Langsung (tanpa lingkaran hijau)
                   
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                    
                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.custom("Cause-Extrabold", size: 16))
                            .foregroundColor(darkBlueTheme)
                        
                        Text(description)
                            .font(.custom("Patrickhand-Regular", size: 10))
                            .foregroundColor(darkBlueTheme) // Ubah warna jadi biru
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 5)

            }

        }
        .frame(width: 225, height: 60)
    }
}

#Preview {
    // FishCardView()
}
