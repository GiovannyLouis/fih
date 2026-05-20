//
//  ObstacleController.swift
//  fih
//
//  Created by Vrz on 14/05/26.
//

import Foundation

@Observable
class ObstacleController {
    static func applyEffects(obstacleType: ObstacleType, to gameController: InGameController) {
        let ship = gameController.selectedShip
        let equipment = gameController.equippedItems
        
        var damage: Double = 0
        var speedPenalty: Double = 0
        var teleportDistance: Double = 0
        var shouldStealFish = false
        
        switch obstacleType {
        case .albatros:
            shouldStealFish = true
        
        case .iceberg:
            switch ship.shipType {
            case .speedBoat:    damage = 30; speedPenalty = 30
            case .fishingBoat:  damage = 20; speedPenalty = 20
            case .cargoBoat:    damage = 15; speedPenalty = 10
            }
            
        case .lightning:
            damage = 40
            
        case .tornado:
            teleportDistance = Bool.random() ? 10.0 : -10.0
            
        case .predator:
            damage = Double(ship.maxDurability) * 0.2
            
        case .shipFailure:
            // Simply trigger the boolean. moveShip() will handle the continuous decay.
            if !gameController.isEngineFailing {
                gameController.isEngineFailing = true
                gameController.showEvent("\(obstacleType.displayName)! Speed is dropping...")
            }
            return
        }
                
        // SCARE CROW vs Albatross
        if obstacleType == .albatros && equipment.contains(where: { $0.type == .scarecrow }) {
            shouldStealFish = false
            gameController.showEvent("Scarecrow protected your fish!")
        }
        
        // PREDATOR BAIT vs Predator
        if obstacleType == .predator && equipment.contains(where: { $0.type == .predatorBait }) {
            damage = 0
            gameController.showEvent("Predator took the bait and left!")
        }
        
        // SHIELD (Reduces any incoming damage by 30%)
        if damage > 0 && equipment.contains(where: { $0.type == .shield }) {
            damage *= 0.7
            // Optional: add a small visual cue that shield worked
        }
        
        // GUARDIAN ANGEL (Blocks all damage, loses a stack)
        if damage > 0 && gameController.guardianAngelHitsRemaining > 0 && equipment.contains(where: { $0.type == .guardianAngel }) {
            damage = 0
            gameController.guardianAngelHitsRemaining -= 1
            gameController.showEvent("Guardian Angel blocked the hit! (\(gameController.guardianAngelHitsRemaining) left)")
            
            if gameController.guardianAngelHitsRemaining == 0 {
                gameController.showEvent("Your Guardian Angel has broken!")
            }
        }

        // Resolution: Apply final values to game state
        
        // Apply Damage
        if damage > 0 {
            gameController.currentHealth = max(0, gameController.currentHealth - damage)
            gameController.showEvent("\(obstacleType.displayName)! -\(Int(damage)) HP")
            if gameController.currentHealth <= 0 {
                gameController.endExpedition(result: .shipDestroyed)
            }
        }
        
        // Apply Speed Drop
        if speedPenalty > 0 {
            gameController.currentSpeed = max(Double(ship.minSpeed), gameController.currentSpeed - speedPenalty)
            gameController.showEvent("Speed reduced by \(Int(speedPenalty))!")
        }
        
        // Apply Teleport
        if teleportDistance != 0 {
            gameController.distanceTravelledKm = max(0, gameController.distanceTravelledKm + teleportDistance)
            let dir = teleportDistance > 0 ? "forward" : "backward"
            gameController.showEvent("Tornado threw you 10km \(dir)!")
        }
        
        // Apply Fish Theft
        if shouldStealFish {
            if let randomIndex = gameController.catchLog.indices.randomElement() {
                let stolen = gameController.catchLog.remove(at: randomIndex)
                gameController.showEvent("Albatross stole your \(stolen)!")
            } else {
                gameController.showEvent("Albatross circled, but you have no fish!")
            }
        }
    }
}
