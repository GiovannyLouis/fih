//
//  ZoneTabView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 19/05/26.
//

import SwiftUI

struct ZoneTabView: View {
    let imageName: String // Sekarang kita meminta nama gambar asetnya
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                // Jika terpilih, ukurannya 70x70. Jika tidak, mengecil jadi 55x55
                .frame(width: isSelected ? 70 : 55, height: isSelected ? 70 : 55)
                // Jika tidak terpilih, dorong ke bawah agar terlihat seperti berada di belakang buku
                .offset(y: isSelected ? 0 : 15)
                .zIndex(isSelected ? 1 : 0) // Tab terpilih selalu berada di layer paling depan
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}
