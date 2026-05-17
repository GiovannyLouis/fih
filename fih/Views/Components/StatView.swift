//
//  StatView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 16/05/26.
//

import SwiftUI

struct StatView: View {
    let icon: String
    let iconColor: Color
    let value: String
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
                .foregroundStyle(Color(iconColor))
            Text(value)
                .font(.custom("Cause-ExtraBold", size:16))
        }
    }
}

#Preview {
    StatView(icon: "heart.fill", iconColor: .red, value: "0")
}
