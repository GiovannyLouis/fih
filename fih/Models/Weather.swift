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
    
    var particleData: [(fileName: String, spawn: ParticleSpawnPosition)] {
        switch self {
        case .sunny:
            return [("SunnyCloudParticle.sks", .rightEdge), ("BirdParticle.sks", .rightEdge)]
        case .rainy:
            return [("RainyCloudParticle.sks", .rightEdge), ("RainParticle.sks", .top)]
        case .snowy:
            return [("SnowyCloudParticle.sks", .rightEdge), ("SnowParticle.sks", .top)]
        case .windy:
            return [("WindyCloudParticle.sks", .rightEdge), ("WindyCloudParticle2.sks", .rightEdge)]
        }
    }
    
    var soundName: String {
        switch self {
        case .sunny:
            return "sunny"
        case .rainy:
            return "rain"
        case .snowy:
            return "snow_bg"
        case .windy:
            return "wind_background"
        }
    }
}

struct DailyForecast: Identifiable, Equatable{
    let id = UUID()
    let predictedWeather: WeatherType
    let actualWeather: WeatherType
    let confidence: Int
}

enum ParticleSpawnPosition {
    case rightEdge
    case top
}
