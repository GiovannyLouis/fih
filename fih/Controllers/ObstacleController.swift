//
//  ObstacleController.swift
//  fih
//
//  Created by Vrz on 14/05/26.
//

import Foundation

@Observable
class ObstacleController {
    var obstacles: Obstacle
    
    let ship: Ship
    
    init(obstacles: Obstacle, ship: Ship) {
        self.obstacles = obstacles
        self.ship = ship
    }
    
    func effects(obstacle: Obstacle) {
        switch obstacle.type {
        case .albatros:
        case .iceberg:
        case .lightning:
        case .tornado:
        case .predator:
        case .shipFailure:
        }
    }
}
