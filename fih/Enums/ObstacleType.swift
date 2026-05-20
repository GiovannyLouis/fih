//
//  ObstacleType.swift
//  fih
//
//  Created by Vrz on 14/05/26.
//

import Foundation

enum ObstacleType {
    case albatros
    case albatrosSteal
    case iceberg
    case lightning
    case tornado
    case predator
    case shipFailure
    
    var displayName: String {
        switch self {
        case .albatros, .albatrosSteal: return "Albatros"
        case .iceberg: return "Iceberg"
        case .lightning: return "Lightning Strike"
        case .tornado: return "Tornado"
        case .predator: return "Predator Fish"
        case .shipFailure: return "Engine Failure"
    }
}
}
