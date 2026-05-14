//
//  GameRouterView.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

import SwiftUI

/// view untuk mengarahkan ke halaman/page terkait sesuai dengan state nya sekarang
struct GameRouterView: View {
    
    // pakai appstatemanager (global variabel, semua halaman bs akses)
    @Environment(AppStateManager.self) private var appState
    
    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .fishAlbumPage:
                FishAlbumPage()
                
            case .mainMenuPage:
                MainMenuPage()
            
            case .weatherForecastPage:
                WeatherForecastPage()
            
            case .selectShipPage:
                SelectShipPage()
                
            case .selectEquipmentPage:
                SelectEquipmentPage()
                
            case .inGamePage:
                InGamePage()
                
            }
        }
        // Adds a nice crossfade animation when switching screens
        .animation(.easeInOut, value: appState.currentScreen)
    }
}

#Preview {
    GameRouterView()
        .environment(AppStateManager())
}
