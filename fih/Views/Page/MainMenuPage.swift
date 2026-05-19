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
                    .font(.custom("cause-bold", size: 24))
                    .foregroundStyle(.colorDarkBlue)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                
                
                Button(action: {
                    appState.currentScreen = .weatherForecastPage
                }) {
                    ZStack {
                        Image("green_button")
                            .resizable()
                            .frame(width: 200, height: 60)
                        Text("Play")
                            .font(.custom("cause-bold", size: 36))
                            .foregroundStyle(.colorDarkBlue)
                    }
                }
                
                Button(action: {
                    appState.currentScreen = .fishAlbumPage
                }) {
                    ZStack {
                        Image("cream_button")
                            .resizable()
                            .frame(width: 160, height: 48)
                        Text("Collection")
                            .font(.custom("cause-bold", size: 20))
                            .foregroundStyle(.colorDarkBlue)
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
