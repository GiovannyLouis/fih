//
//  Obstacle.swift
//  fih
//
//  Created by Vrz on 14/05/26.
//

import Foundation

struct Obstacle: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let image: String
    let description: String
    let type: ObstacleType
}
