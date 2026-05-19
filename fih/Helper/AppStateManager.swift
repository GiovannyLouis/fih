//
//  AppStateManager.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

@Observable
class AppStateManager {
    
    // enum currentScreen untuk mengatur screen apa yang muncul berdasarkan statenya, state awal diset di SelectShipPage
    var currentScreen: GameScreen = .fishAlbumPage
    
    var isMovingForward: Bool = true
    
    var selectedShip: Ship?
    
    var equippedItems: [Equipment] = []
    
    // variable menyimpan weather prediction
    var currentForecast: DailyForecast? = nil
    var inGameController: InGameController? = nil
    
    func resetForecast() {
        currentForecast = nil
    }
    
    // function sementara untuk reset forecast kalau fishing selesai
    func endExpedition() {
        resetForecast()
        currentScreen = .mainMenuPage
    }
    
}
