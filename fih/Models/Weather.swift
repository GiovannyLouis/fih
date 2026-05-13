//
//  Weather.swift
//  fih
//
//  Created by Jose Putra Perdana Taneo on 13/05/26.
//

import Foundation

enum WeatherType: CaseIterable {
    case sunny
    case rainy
    case snowy
    case windy
    
    var displayName: String {
        switch self {
        case .sunny:
            return "Sunny"
        case .rainy:
            return "Rainy"
        case .snowy:
            return "Snowy"
        case .windy:
            return "Windy"
        }
    }
    
    var iconName: String {
        switch self {
        case .sunny:
            return "icon_sunny"
        case .rainy:
            return "icon_rainy"
        case .snowy:
            return "icon_snowy"
        case .windy:
            return "icon_windy"
        }
    }
}

struct DailyForecast {
    let predictedWeather: WeatherType
    let actualWeather: WeatherType
    let confidence: Int
}
