//
//  WeatherController.swift
//  fih
//
//  Created by Jose Putra Perdana Taneo on 13/05/26.
//

import Foundation

@Observable
class WeatherController {
    var todayForecast: DailyForecast?
    
    func generateTomorrowWeather() {
        // Roll base confidence and predicted weather
        let confidenceScore = Int.random(in: 50...90)
        let predicted = WeatherType.allCases.randomElement()!
        
        let actual: WeatherType
        let weatherCalculation = Int.random(in: 1...100)
        
        // Determine actual weather
        if weatherCalculation <= confidenceScore {
            // Prediction correct
            actual = predicted
        } else {
            // Prediction false
            var otherWeathers = WeatherType.allCases
            otherWeathers.removeAll { $0 == predicted }
            actual = otherWeathers.randomElement()!
        }
        
        // Save the actual weather
        todayForecast = DailyForecast(
            predictedWeather: predicted,
            actualWeather: actual,
            confidence: confidenceScore
        )
        print("Predicts: \(predicted.displayName) (\(confidenceScore)% confidence)")
        print("Reality: \(actual.displayName) (\(weatherCalculation) points)")
    }
    
    // MARK: - Handshakes for the Team
    func getCurrentActualWeather() -> WeatherType {
            // If something goes wrong, default to Cerah
        return todayForecast?.actualWeather ?? .sunny
        }
}
