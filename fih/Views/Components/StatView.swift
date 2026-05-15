//
//  StatView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 16/05/26.
//

import SwiftUI

struct StatView: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(value)
        }
    }
}

#Preview {
    StatView(icon: "heart.fill", value: "0")
}
