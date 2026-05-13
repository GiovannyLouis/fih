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
    var currentScreen: GameScreen = .weatherForecastPage
    
}
