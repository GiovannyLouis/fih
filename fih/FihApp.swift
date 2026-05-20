//
//  PilihKapalApp.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SwiftData

@main
struct FihApp: App {
    
    @State var appState = AppStateManager()
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Player.self)
            PlayerController.seedInitialData(context: container.mainContext)
            
        } catch {
            fatalError("Gagal menginisialisasi ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            GameRouterView()
                // inject appstate ke environment supaya semua page bisa akses data yang sama dan state selalu sama
                .environment(appState)
                
        }
        .modelContainer(container)
    }
}
