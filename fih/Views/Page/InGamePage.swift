//
//  PlayingPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 13/05/26.
//

import SwiftUI

struct InGamePage: View {
    
    @State private var controller: InGameController = InGameController()
    
//    init(ship: Ship, equippedItems: [Equipment]) {
//        self._controller = State(initialValue: InGameController(ship: ship, equippedItems: equippedItems))
//    }
    
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
                
                // pasang spritekit gamescene disini
            }
            .padding()
        }
    }
}

#Preview {
    //PlayingPage()
}
