//
//  WeatherForecastPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SpriteKit
import SwiftUI

struct WeatherForecastPage: View {
    @Environment(AppStateManager.self) private var appState
    @State private var controller: WeatherController = WeatherController()
    
    var fishBackgroundScene: SKScene {
        if let scene = SKScene(fileNamed: "FishBackground") {
            scene.scaleMode = .aspectFill
            return scene
        }
        return SKScene()
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            SpriteView(
                scene: fishBackgroundScene,
                options: [.allowsTransparency]
            )
            .ignoresSafeArea()
            .opacity(0.075)
            
            VStack {
                HStack {
                    Button(action: {
                        appState.isMovingForward = false
                        appState.currentScreen = .mainMenuPage
                        print("Go back to main screen")
                    }) {
                        Image("icon_back")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    
                    Spacer()
                    
                    Text("Tomorrow's Weather Forecast")
                        .font(.custom("cause-bold", size: 32))
                        .foregroundColor(.colorDarkBlue)
                    
                    Spacer()
                    
                    Button(action: {
                        appState.isMovingForward = true
                        appState.currentScreen = .selectShipPage
                        print("Go to select ship screen")
                    }) {
                        Image("icon_back")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .rotationEffect(Angle(degrees: 180))
                    }
                }
                .padding(.top, 32)
                
                Spacer()
                
                // MARK: Weather Card
                SpriteView(scene: WeatherCardScene(
                    size: CGSize(width: 320, height: 140),
                    textureName: "frame_normal.png",
                    cornerInset: 12),
                           options: [.allowsTransparency])
                .frame(width: 400, height: 128)
                .overlay(
                    ZStack(alignment: .leading) {
                        if let forecast = appState.currentForecast {
                            // Weather Icon
                            Image(forecast.predictedWeather.iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 210, height: 210)
                                .offset(x: -130)
                            
                            // Forecast Text
                            HStack(spacing: 8) {
                                Text("\(forecast.confidence)%")
                                    .font(
                                        .custom("patrickhand-regular", size: 36)
                                    )
                                    .foregroundStyle(.colorDarkBlue)

                                Text("\(forecast.predictedWeather.displayName)")
                                    .font(
                                        .custom("patrickhand-regular", size: 36)
                                    )
                                    .foregroundStyle(.colorDarkBlue)
                            }
                            .padding(.leading, 120)
                                
                        } else {
                            ProgressView("Calibrating Forecast...")
                                .padding(.vertical, 16)
                        }
                    }
                )
                .padding(.top, 16)
                    
                Spacer()
                
                Button(action: {
                    appState.currentScreen = .selectShipPage
                }) {
                    ZStack {
                        Image("green_button")
                            .resizable()
                            .frame(width: 200, height: 56)
                        Text("Next")
                            .font(.custom("Cause-Bold", size: 32))
                            .foregroundColor(Color("color_dark_blue"))
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
            }
            .onAppear {
                if appState.currentForecast == nil {
                    controller.generateTomorrowWeather()
                    appState.currentForecast = controller.todayForecast
                }
            }
        }
    }
}

#Preview {
    WeatherForecastPage()
        .environment(AppStateManager())
}
