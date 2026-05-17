//
//  Equipment.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import Foundation

// MARK: - Equipment Model
struct Equipment: Identifiable, Equatable {
    let id = UUID() // Required for SwiftUI lists
    let name: String
    let imageName: String
    let description: String
    let type: EquipmentType // Used by GameScene to apply the actual effect
}

// MARK: - Pre-defined Equipment Data
/// to initialize available equipment data to play

extension Equipment {
    static let allEquipment: [Equipment] = [
        Equipment(name: "Shield", imageName: "gearshape.fill", description: "Minimize incoming damage by -30%", type: .shield),
        Equipment(name: "Rocket Thrusters", imageName: "heart.fill", description: "Increase speed, 25% (?)", type: .rocketThrusters),
        Equipment(name: "Predator Bait", imageName: "bird.fill", description: "Bait the predators away", type: .predatorBait),
        Equipment(name: "Scarecrow", imageName: "plus.circle.fill", description: "Scare the albatros", type: .scarecrow),
        Equipment(name: "Guardian Angel", imageName: "pencil.circle.fill", description: "Block any first 3 hits, then breaks permanently", type: .guardianAngel),
        Equipment(name: "Lucky Hat", imageName: "graduationcap.fill", description: "It seems like it boosts your luck (hell nah it doesn't)", type: .luckyHat),
        Equipment(name: "Soul Eater", imageName: "theatermasks.fill", description: "For every fish caught, heals 3% max boat health", type: .soulEater)
    ]
}
