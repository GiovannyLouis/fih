//
//  WeatherForecastPage.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

struct WeatherForecastPage: View {
    let controller: WeatherController

    
    var body: some View {
        VStack {
            if let forecast = controller.todayForecast{
                Text(forecast.predictedWeather.displayName)
            }
        }
        .onAppear {
            if controller.todayForecast == nil {
                controller.generateTomorrowWeather()
            }
        }
    }
}
//
//#Preview {
//    WeatherForecastPage(controller: WeatherController())
//}
