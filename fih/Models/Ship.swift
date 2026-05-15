//
//  Ship.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import Foundation

// MARK: - Ship Model
struct Ship: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
    let minSpeed: Int = 10
    let maxSpeed: Int
    let maxDurability: Int
    let equipmentSlots: Int
    let shipType: ShipType
}

// MARK: - Pre-defined Ship Data
/// to initialize available ship data to play

extension Ship {
    static let allShips: [Ship] = [
        Ship(
            name: "Speed Boat",
            imageName: "ship_speedboat",
            maxSpeed: 500,
            maxDurability: 100,
            equipmentSlots: 1,
            shipType: .speedBoat
        ),
        Ship(
            name: "Fishing Boat",
            imageName: "ship_fishingboat",
            maxSpeed: 200,
            maxDurability: 300,
            equipmentSlots: 1,
            shipType: .fishingBoat
        ),
        Ship(
            name: "Cargo Ship",
            imageName: "ship_cargoboat",
            maxSpeed: 100,
            maxDurability: 800,
            equipmentSlots: 2,
            shipType: .cargoBoat
        )
    ]
    
}

