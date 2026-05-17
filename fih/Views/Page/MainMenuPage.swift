//
//  MainMenuPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

struct MainMenuPage: View {
    @Environment(AppStateManager.self) private var appState
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Image("background_mainScreen")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fit)
            
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
