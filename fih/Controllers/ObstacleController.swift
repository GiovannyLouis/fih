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
        
        switch obstacleType {
            
        case .albatros:
            if !gameController.catchLog.isEmpty {
                if let randomIndex = gameController.catchLog.indices.randomElement() {
                    let stolenFish = gameController.catchLog.remove(at: randomIndex)
                    gameController.showEvent("\(obstacleType.displayName) stole your \(stolenFish)!")
                }
            } else {
                gameController.showEvent("\(obstacleType.displayName) swooped, but no fish to steal!")
            }
            
        case .iceberg:
            var hpLoss: Double = 0
            var speedLoss: Double = 0
            
            switch ship.shipType {
            case .speedBoat:
                hpLoss = 30; speedLoss = 30
            case .fishingBoat:
                hpLoss = 20; speedLoss = 20
            case .cargoBoat:
                hpLoss = 15; speedLoss = 10
            }
            
            gameController.applyDamage(hpLoss)
            gameController.currentSpeed = max(Double(ship.minSpeed), gameController.currentSpeed - speedLoss)
            gameController.showEvent("\(obstacleType.displayName)! -\(Int(hpLoss)) HP, -\(Int(speedLoss)) Speed")
            
        case .lightning:
            gameController.applyDamage(40)
            gameController.showEvent("\(obstacleType.displayName)! -40 HP")
            
        case .tornado:
            let distance = Bool.random() ? 10.0 : -10.0
            gameController.distanceTravelledKm = max(0, gameController.distanceTravelledKm + distance)
            
            let directionText = distance > 0 ? "forward" : "backward"
            gameController.showEvent("\(obstacleType.displayName)! Thrown 10km \(directionText)")
            
        case .predator:
            let damage = Double(ship.maxDurability) * 0.20
            gameController.applyDamage(damage)
            gameController.showEvent("\(obstacleType.displayName)! -\(Int(damage)) HP")
            
        case .shipFailure:
            // Simply trigger the boolean. moveShip() will handle the continuous decay.
            if !gameController.isEngineFailing {
                gameController.isEngineFailing = true
                gameController.showEvent("\(obstacleType.displayName)! Speed is dropping...")
            }
        }
    }
}
