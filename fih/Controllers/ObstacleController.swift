//
//  ObstacleController.swift
//  fih
//
//  Created by Vrz on 14/05/26.
//

import Foundation
import UIKit

@Observable
class ObstacleController {
    static func applyEffects(obstacleType: ObstacleType, to gameController: InGameController) async {
        let ship = gameController.selectedShip
        let equipment = gameController.equippedItems
        
        var damage: Double = 0
        var speedPenalty: Double = 0
        var teleportDistance: Double = 0
        var shouldStealFish = false
        var shouldKrakenAttack = false
        var speedText = ""
        var shieldtext = ""
        
        switch obstacleType {
        case .albatros, .albatrosSteal:
            gameController.onPlaySFX?("albatros_steal")
            shouldStealFish = true
            
        case .iceberg:
            gameController.gameScene?.handleIcebergAnimation()
            
            try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
            gameController.onPlaySFX?("glacier")
            gameController.hapticStyle?(.heavy)
            switch ship.shipType {
            case .speedBoat:    damage = 30; speedPenalty = 30
            case .fishingBoat:  damage = 20; speedPenalty = 20
            case .cargoBoat:    damage = 15; speedPenalty = 10
            }
            gameController.gameScene?.shakeScreen(intensity: "heavy")
            
        case .lightning:
            gameController.onPlaySFX?("thunder")
            gameController.hapticStyle?(.heavy)
            gameController.gameScene?.handleLightningAnimation()
            damage = 40
            
        case .tornado:
            gameController.onPlaySFX?("tornado")
            gameController.hapticStyle?(.heavy)
            var distance = 0.0
            gameController.gameScene?.handleTornadoAnimation()
            switch ship.shipType {
            case .speedBoat:    distance = 10.0
            case .fishingBoat:  distance = 7.0
            case .cargoBoat:    distance = 3.0
            }
            teleportDistance = Bool.random() ? distance : -(distance)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                gameController.distanceTravelledKm = max(0, gameController.distanceTravelledKm + teleportDistance)
                gameController.gameScene?.shakeScreen(intensity: "heavy")
                let dir = teleportDistance > 0 ? "forward" : "backward"
                gameController.triggerObstaclePopUp("Tornado threw you \(Int(distance))km \(dir)!")
            }
            
        case .predator, .predatorBaited:
            gameController.onPlaySFX?("kraken")
            shouldKrakenAttack = true
            
        case .shipFailure:
            // Simply trigger the boolean. moveShip() will handle the continuous decay.
            if !gameController.isEngineFailing {
                gameController.onPlaySFX?("engine_fail")
                gameController.hapticStyle?(.heavy)
                gameController.isEngineFailing = true
                gameController.gameScene?.handleEngineFailureAnimation()
                gameController.triggerObstaclePopUp("\(obstacleType.displayName)! Speed is dropping...")
            }
            return
        }
        
        if shouldKrakenAttack {
            if equipment.contains(where: { $0.type == .predatorBait}) {
                damage = 0
                gameController.gameScene?.handlePredatorAnimation(isAttacking: false)
                
                try? await Task.sleep(nanoseconds: UInt64(1.0 * 1_000_000_000))

                gameController.hapticStyle?(.light)
                gameController.triggerObstaclePopUp("Predator took the bait and left!")
            } else {
                gameController.gameScene?.handlePredatorAnimation(isAttacking: true)
                
                try? await Task.sleep(nanoseconds: UInt64(1.0 * 1_000_000_000))
                
                damage = Double(ship.maxDurability) * 0.2
                gameController.gameScene?.shakeScreen(intensity: "heavy")
                gameController.hapticStyle?(.heavy)
            }
        }
        
        // Apply Speed Drop
        if speedPenalty > 0 {
            gameController.currentSpeed = max(Double(ship.minSpeed), gameController.currentSpeed - speedPenalty)
            speedText = " Speed reduced by \(Int(speedPenalty))!"
        }
        
        if damage > 0 {
            if gameController.guardianAngelHitsRemaining > 0 && equipment.contains(where: { $0.type == .guardianAngel }) {
                damage = 0
                gameController.guardianAngelHitsRemaining -= 1
                gameController.triggerObstaclePopUp("Guardian Angel blocked the hit! (\(gameController.guardianAngelHitsRemaining) left)")
                gameController.gameScene?.equipmentVisual(.guardianAngel)
                gameController.onPlaySFX?("angel")
                if gameController.guardianAngelHitsRemaining == 0 {
                    gameController.triggerObstaclePopUp("Your Guardian Angel has broken!")
                }
            } else if equipment.contains(where: { $0.type == .shield }) {
                damage *= 0.7
                gameController.gameScene?.equipmentVisual(.shield)
                shieldtext = " Shield reduced the damage!"
            }
            
            if damage > 0 {
                gameController.currentHealth = max(0, gameController.currentHealth - damage)
                gameController.triggerObstaclePopUp("\(obstacleType.displayName), -\(Int(damage.rounded())) HP!\(shieldtext)\(speedText)")
                if gameController.currentHealth <= 0 {
                    gameController.endExpedition(result: .shipDestroyed)
                }
            }
        }
        
        // Apply Fish Theft
        if shouldStealFish {
            if let randomIndex = gameController.catchLog.indices.randomElement() {
                if equipment.contains(where: { $0.type == .scarecrow }) {
                    gameController.gameScene?.handleAlbatrosAnimation(isStealing: false, isScarecrow: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        gameController.triggerObstaclePopUp("Scarecrow scared the albatros away!")
                    }
                } else {
                    let stolenFish = gameController.catchLog.remove(at: randomIndex)
                    gameController.gameScene?.handleAlbatrosAnimation(isStealing: true, isScarecrow: false)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        gameController.triggerObstaclePopUp("Albatros stole your \(stolenFish.name)!")
                    }
                }
            } else {
                gameController.gameScene?.handleAlbatrosAnimation(isStealing: false, isScarecrow: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    gameController.triggerObstaclePopUp("Albatros circled, but you have no fish!")
                }
            }
        }
    }
}
