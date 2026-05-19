//
//  MainMenuPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI
import SpriteKit

struct MainMenuPage: View {
    @Environment(AppStateManager.self) private var appState
    
    var mainMenuScene: SKScene {
        // This looks for FishBackground.sks, sees it is linked to FishBackgroundScene,
        // loads your fish, and triggers the didMove(to:) movement code!
        if let scene = SKScene(fileNamed: "MainScreen") {
            scene.scaleMode = .aspectFill
            return scene
        }
        return SKScene()
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: mainMenuScene)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("DAY 1")
                    .font(.custom("cause-bold", size: 20))
                    .foregroundStyle(Color(red: 0.1, green: 0.3, blue: 0.5))
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                
                
                Button(action: {
                    appState.currentScreen = .weatherForecastPage
                }) {
                    ZStack {
                        Image("play_button")
                        Text("Play")
                            .font(.custom("cause-bold", size: 36))
                            .foregroundStyle(Color(red: 0.1, green: 0.3, blue: 0.5))
                    }
                }
                
                Button(action: {
                    appState.currentScreen = .fishAlbumPage
                }) {
                    ZStack {
                        Image("collection_button")
                        Text("Collection")
                            .font(.custom("cause-bold", size: 20))
                            .foregroundStyle(Color(red: 0.1, green: 0.3, blue: 0.5))
                    }
                }
                .padding(.top, -12)
                
                Spacer()


            }
                
        }
    }
}

#Preview {
    MainMenuPage()
        .environment(AppStateManager())
}
