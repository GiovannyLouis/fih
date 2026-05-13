//
//  PlayingPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 13/05/26.
//

import SwiftUI

struct InGamePage: View {
    
    let controller: InGameController
    
    @Environment(AppStateManager.self) private var appState
        
    var body: some View {
        ZStack {
            VStack {
                Text("Start Game with \(controller.selectedShip.name) and \(controller.equippedItems.count) items!")
                ForEach(controller.equippedItems) { item in
                    Text(item.name)
                }
                
                // pasang spritekit gamescene disini
            }
            .padding()
        }
    }
}

#Preview {
    //PlayingPage()
}
