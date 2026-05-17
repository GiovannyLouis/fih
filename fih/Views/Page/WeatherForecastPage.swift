//
//  WeatherForecastPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

struct WeatherForecastPage: View {
    @Environment(AppStateManager.self) private var appState
    @State private var controller: WeatherController = WeatherController()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
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
                
                if let forecast = appState.currentForecast {
                    Image(forecast.predictedWeather.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                    
                    Spacer()
                    
                    HStack {
                        Text("\(forecast.confidence)%")
                            .font(.custom("patrickhand-regular", size: 32))
                            .foregroundStyle(.colorDarkBlue)
                        Text("\(forecast.predictedWeather.displayName)")
                            .font(.custom("patrickhand-regular", size: 32))
                            .foregroundStyle(.colorDarkBlue)
                    }
                    .padding(.bottom, 28)
                } else {
                    ProgressView("Calibrating Forecast...")
                }
                
                
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
