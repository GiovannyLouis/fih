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
    private var seaNode: SKSpriteNode!
    
    private var seaY: CGFloat {size.height * 0.42}
    private var shipY: CGFloat {seaY}
    private var fishMinY: CGFloat {size.height * 0.05}
    private var fishMaxY: CGFloat {seaY - 15}
    private var skyMinY: CGFloat {seaY + 100}
    private var skyMaxY: CGFloat {size.height * 0.92}
    
    var shipImageName: String = "ship_fishingboat"
    var seaImageName: String = "ocean"
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        setupSea()
        setupShip()
        setupClouds()
        setupSeabirds()
    }
    
    private func setupSea() {
        let seaTexture = SKTexture(imageNamed: "ocean")
        let seaWidth = seaTexture.size().width
        let duration: TimeInterval = 4.0

        for i in 0..<4 {
            let seaNode = SKSpriteNode(texture: seaTexture)
            seaNode.zPosition = 6

            let initialX = CGFloat(i) * seaWidth
            seaNode.position = CGPoint(x: initialX, y: 100)
            
            addChild(seaNode)

            let moveLeft = SKAction.moveBy(x: -seaWidth, y: 0, duration: duration)
            let resetPosition = SKAction.moveBy(x: seaWidth, y: 0, duration: 0)
            // Gabungkan dalam sequence dan jalankan selamanya
            let endlessSequence = SKAction.sequence([moveLeft, resetPosition])
            seaNode.run(SKAction.repeatForever(endlessSequence))
        }
    }
    private func setupShip() {
        shipNode = SKSpriteNode(imageNamed: shipImageName)
        shipNode.yScale = 0.1
        shipNode.xScale = 0.1
        
        var finalShipY = shipY
        
        if shipImageName == "ship_fishingboat" {
            finalShipY = shipY + 20
        }
        if shipImageName == "ship_speedboat" {
            finalShipY = shipY - 15
        }
        shipNode.position = CGPoint(x: size.width * 0.28, y: finalShipY)
        shipNode.zPosition = 5
        shipNode.name = "ship"
        addChild(shipNode)
        
        let up   = SKAction.moveBy(x: 0, y: 6, duration: 1.3)
        let down = SKAction.moveBy(x: 0, y: -6, duration: 1.3)
        up.timingMode = .easeInEaseOut
        down.timingMode = .easeInEaseOut
        shipNode.run(SKAction.repeatForever(.sequence([up, down])))
    }
    
    private func setupClouds() {
        
    }
    private func setupSeabirds() {
        
    }
    
    func spawnFishVisual (_ fishName : String) {
        let assetName = "fish_\(fishName.lowercased())"
        let fish = SKSpriteNode (imageNamed: assetName)
        fish.size = CGSize(width: 100, height: 50)
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
