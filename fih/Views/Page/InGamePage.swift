//
//  PlayingPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 13/05/26.
//

import SwiftUI

struct InGamePage: View {
    @Environment(AppStateManager.self) private var appState
        
    var body: some View {
        ZStack {
            VStack {
                if let selectedShip = appState.selectedShip {
                    Text("Start Game with \(selectedShip.name) ")
                }
                
                Text("Using \(appState.equippedItems.count) items!")
                ForEach(appState.equippedItems) { item in
                    Text(item.name)
                }
                
                if let currentForecast = appState.currentForecast {
                    Text("Reality: \(currentForecast.actualWeather.displayName)")
                }
                
                // pasang spritekit gamescene disini
            }
            .padding()
        }
    }
}

#Preview {
    InGamePage()
        .environment(AppStateManager())
}
