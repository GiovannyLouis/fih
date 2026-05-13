//
//  PilihKapalApp.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

@main
struct FihApp: App {
    
    @State var appState = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            GameRouterView()
                // inject appstate ke environment supaya semua page bisa akses data yang sama dan state selalu sama
                .environment(appState)
        }
    }
}
