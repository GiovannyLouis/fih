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
    
    var weather: WeatherType = .sunny
    
    private var shipNode: SKSpriteNode!
    private var seaNode: SKSpriteNode!
    
    private var seaY: CGFloat {size.height * 0.42}
    private var shipY: CGFloat {seaY}
    private var fishMinY: CGFloat {size.height * 0.05}
    private var fishMaxY: CGFloat {seaY * 0.5}
    private var skyMinY: CGFloat {seaY + 100}
    private var skyMaxY: CGFloat {size.height * 0.92}
    
    var shipImageName: String = "ship_fishingboat"
    var seaImageName: String = "ocean"
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        setupSea()
        setupShip()
        setupClouds(weather: weather)
        setupSeabirds()
    }
    
    private func setupSea() {
        let seaTexture = SKTexture(imageNamed: "ocean")
        let seaWidth = seaTexture.size().width - 6
        let duration: TimeInterval = 4.0

        for i in 0..<4 {
            let seaNode = SKSpriteNode(texture: seaTexture)
            seaNode.zPosition = 2
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
        if shipImageName == "ship_cargoboat" {
            finalShipY = shipY - 5
        }
        shipNode.position = CGPoint(x: size.width * 0.28, y: finalShipY)
        shipNode.zPosition = 1
        shipNode.name = "ship"
        addChild(shipNode)
        
        let up   = SKAction.moveBy(x: 0, y: 6, duration: 1.3)
        let down = SKAction.moveBy(x: 0, y: -6, duration: 1.3)
        up.timingMode = .easeInEaseOut
        down.timingMode = .easeInEaseOut
        shipNode.run(SKAction.repeatForever(.sequence([up, down])))
    }
    
    private func setupClouds(weather: WeatherType) {
        for data in weather.particleData {
                
                if let emitter = SKEmitterNode(fileNamed: data.fileName) {
                    
                    switch data.spawn {
                    case .rightEdge:
                        emitter.position = CGPoint(x: frame.width + 20, y: frame.height - 100)
                        
                    case .top:
                        emitter.position = CGPoint(x: (frame.width / 2)+30, y: frame.height + 20)
                        emitter.particlePositionRange = CGVector(dx: frame.width, dy: 0)
                        emitter.zPosition = 4
                    }
                    
                    emitter.targetNode = self
                    addChild(emitter)
                }
            }
    }
    
    private func setupSeabirds() {
        
    }
    
    func spawnFishVisual(iconName: String, fishName: String) {
        let fish = SKSpriteNode(imageNamed: iconName)
        fish.size      = CGSize(width: 50, height: 25)
        fish.name      = fishName
        fish.zPosition = 3
     
        // Spawn dari kanan layar
        let startY = CGFloat.random(in: fishMinY...fishMaxY)
        fish.position  = CGPoint(x: size.width + 60, y: startY)
        addChild(fish)
     
        let duration   = Double.random(in: 5...9)
     
        // FIX: posisi X kapal = size.width * 0.28 dari kiri
        // distToShip = jarak dari spawn point ke kapal
        let shipX      = size.width * 0.28
        let spawnX     = size.width + 60.0
        let distToShip = spawnX - shipX                    // selisih dari spawn ke kapal
        let totalDist  = spawnX + 80.0                     // total jarak sampai keluar layar kiri
        let timeToShip = (distToShip / totalDist) * duration
     
        // Action gerak ke kiri sampai keluar layar
        fish.run(.sequence([
            SKAction.moveTo(x: -80, duration: duration),
            SKAction.removeFromParent()
        ]))
     
        // Saat sampai di posisi kapal → tangkap
        let catchTrigger = SKAction.run { [weak self, weak fish] in
            guard let self = self,
                  let fish = fish,
                  fish.parent != nil else { return }
     
            self.onFishCaught?(fish.name ?? fishName)
            self.showCatchEffect(at: fish.position)
            fish.removeFromParent()
        }
     
        fish.run(.sequence([
            .wait(forDuration: timeToShip),
            catchTrigger
        ]), withKey: "catchCheck")
    }
    
    private func showCatchEffect(at position: CGPoint) {
        for _ in 0..<5 {
            let star        = SKShapeNode(circleOfRadius: 4)
            star.fillColor  = .yellow
            star.strokeColor = .clear
            star.position   = position
            star.zPosition  = 10
            addChild(star)
     
            let dx = CGFloat.random(in: -25...25)
            let dy = CGFloat.random(in: 10...35)
            star.run(.sequence([
                .group([
                    .moveBy(x: dx, y: dy, duration: 0.5),
                    .fadeOut(withDuration: 0.5)
                ]),
                .removeFromParent()
            ]))
        }
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
