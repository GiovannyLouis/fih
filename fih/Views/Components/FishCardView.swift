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
    let darkBlueTheme = Color("color_dark_blue")
    
    var body: some View {
        Group {
            if isLocked {
                // --- LOCKED STATE BARU ---
                HStack(spacing: 5) {
                    Image("icon_lock")
                        .resizable()
                        .scaledToFit()
                    
                    Text("You have not caught\nthis fish yet")
                        .font(.custom("cause-extrabold", size: 15))
                        .foregroundColor(darkBlueTheme)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .frame(width: 223, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.82, green: 0.82, blue: 0.82)) // Abu-abu terang
                )
                
                
            } else {
                // --- UNLOCKED STATE BARU ---
                HStack(spacing: 5) {
                    
                    // Gambar Ikan Langsung (tanpa lingkaran hijau)
                   
                    Image(icon)
                        .resizable()
                        .scaledToFit()                    
                    
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
                .frame(width: 223, height: 60)

            }

        }
        
    }
}

#Preview {
    // FishCardView()
}
