//
//  GameScene.swift
//  fih
//
//  Created by Vrz on 12/05/26.
//

import SpriteKit

class GameScene: SKScene {
    
    var onShipTapped: (() -> Void)?
    
    var onFishCaught: ((String) -> Void)?
    
    private var shipNode: SKSpriteNode!
    
    private var seaY: CGFloat {size.height * 0.42}
    private var shipY: CGFloat {seaY + 60}
    private var fishMinY: CGFloat {size.height * 0.05}
    private var fishMaxY: CGFloat {seaY - 15}
    private var skyMinY: CGFloat {seaY + 100}
    private var skyMaxY: CGFloat {size.height * 0.92}
    
    var shipImageName: String = "ship_fishingboat"
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        setupSea()
        setupShip()
        setupClouds()
        setupSeabirds()
    }
    
    private func setupSea() {
        
    }
    private func setupShip() {
    }
    private func setupClouds() {
        
    }
    private func setupSeabirds() {
        
    }
    
    func spawnFishVisual (_ fishName : String) {
        let assetName = "fish_\(fishName.lowercased())"
        let fish = SKSpriteNode (imageNamed: assetName)
        fish.size = CGSize(width: 55, height: 38)
        fish.name = fishName
        fish.zPosition = 5
        
        let startY = CGFloat.random(in: fishMinY...fishMaxY)
        fish.position = CGPoint(x: size.width + 60, y: startY)
        addChild(fish)
        
        let duration = Double.random(in: 5...9)
        
        let shipX = size.width * 0.28
        let totalDist = size.width + 60 + abs(shipX)
        let distToShip = size.width + 60 + shipX
        let timeToShip = (distToShip / totalDist) * duration
        
        fish.run (.sequence([
            SKAction.moveTo(x: -80, duration: duration),
            SKAction.removeFromParent()
        ]))
        
        let catchTrigger = SKAction.run { [weak self, weak fish] in
            guard let self = self, let fish = fish, fish.parent != nil else { return }
            self.onFishCaught?(fish.name ?? fishName)  // → InGameController.catchFish()
//            self.showCatchEffect(at: fish.position)     // bintang efek
            fish.removeFromParent()
        }
        fish.run(.sequence([
            .wait(forDuration: timeToShip),
            catchTrigger
        ]), withKey: "catchCheck")
    }
    
    func pauseGame() {
        self.isPaused = true
    }
    
    func resumeGame() {
        self.isPaused = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let tapped = nodes(at: location)
        let shipTapped = tapped.contains { $0 == shipNode || $0.parent == shipNode }
        
        if shipTapped {
            onShipTapped?()
        }
    }
}
