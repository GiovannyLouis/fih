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
                 .frame(width: 65, height: 65)
                 .frame(width: 65, height: isSelected ? 65 : 45, alignment: .top)
                 .clipped()
                 .zIndex(isSelected ? 1 : 0) // Tab terpilih selalu berada di layer paling depan
         }
         .buttonStyle(PlainButtonStyle())
     }
}
