//
//  WeatherForecastPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SpriteKit
import SwiftData
import SwiftUI

struct WeatherForecastPage: View {
    @Environment(AppStateManager.self) private var appState
    @Environment(AudioManager.self) private var audio
    @Environment(\.modelContext) private var context

    @State private var controller: WeatherController = WeatherController()
    @State private var showGuide: Bool = false
    @State private var playerController = PlayerController()

    
    var fishBackgroundScene: SKScene {
        if let scene = SKScene(fileNamed: "FishBackground") {
            scene.scaleMode = .aspectFill
            return scene
        }
        return SKScene()
    }

    var body: some View {
        ZStack {
            
            SpriteView(
                scene: fishBackgroundScene,
                options: [.allowsTransparency]
            )
            .ignoresSafeArea()
            .opacity(0.075)
            
            VStack {
                HStack(spacing: 8) {
//                    Spacer()
                    Button(action: {
                        appState.isMovingForward = false
                        appState.currentScreen = .mainMenuPage
                        print("Go back to main screen")
                    }) {
                        Image("icon_back")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
//                    .padding(.leading, 64)
                    
                    
                    Spacer()
                    
                    Text("Tomorrow's Weather Forecast")
                        .font(.custom("cause-bold", size: 32))
                        .foregroundColor(.colorDarkBlue)
                    
                    Spacer()
                    
                    ObstacleInfoButton(showGuide: $showGuide, currentDay: playerController.currentDays, audioController: audio, description: "View your weather's obstacle here")
                    
                    
                }
//                .border(.black)
                .padding(.top, 32)
                
                Spacer()
                
                // MARK: Weather Card
                Image("frame_weather")
                    .resizable(
                            capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                            resizingMode: .stretch
                    )
                    .frame(width: 800, height: 256)
                    .scaleEffect(0.5)
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
                    audio.playSFX(filename: "play")
                    audio.haptic(style: .light)
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
                if let forecast = appState.currentForecast {
                    audio
                        .playBGM_Game(
                            filename: forecast.predictedWeather.soundName,
                            volume: 1.0
                        )
                }
            }
            .onDisappear {
                audio.stopBGM_Game()
            }
//            if showGuide {
//                ObstacleInfoView {
//                    showGuide = false
//                    print("Close guide")
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .transition(.identity)
//                .ignoresSafeArea()
//            }
        }
        .onAppear {
            playerController.getDays(context: context)
        }
        .fullScreenCover(isPresented: $showGuide.animation(.none)) {
            ObstacleInfoView {
                var t = Transaction()
                t.disablesAnimations = true
                withTransaction(t) {
                    showGuide = false
                }
            }
            .presentationBackground(.clear)
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .border(.black)
//        .frame(width: .infinity, height: .infinity)
//        .ignoresSafeArea()
    }
}

#Preview {
    WeatherForecastPage()
        .environment(AppStateManager())
        .environment(AudioManager())
}
