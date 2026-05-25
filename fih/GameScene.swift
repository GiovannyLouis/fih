//
//  GameScene.swift
//  fih
//
//  Created by Vrz on 12/05/26.
//

import SpriteKit

class GameScene: SKScene {
    
    var onShipTapped: (() -> Void)?
    
    var onFishCaught: ((Fish) -> Void)?
    
    var weather: WeatherType = .sunny
    
    private var shipNode: SKSpriteNode!
    private var seaNode: SKSpriteNode!
    private var mainCamera: SKCameraNode!
    
    // ADD THIS: Keep track of nodes that should be affected by ship speed
    private var speedAffectedNodes: [SKNode] = []
    
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
        
        mainCamera = SKCameraNode()
        // Center the camera
        mainCamera.position = CGPoint(x: size.width / 2, y: size.height / 2)
        self.camera = mainCamera
        addChild(mainCamera)
    }
    
    // ADD THIS: Method to synchronize visual speed
    func updateVisualSpeed(currentSpeed: Double, maxSpeed: Double) {
        let ratio = CGFloat(currentSpeed / maxSpeed)
        let multiplier = ratio * ratio
        
        // Update all registered nodes (waves, etc.)
        for node in speedAffectedNodes {
            node.speed = multiplier
        }
        
        // Optionally slow down the ship's bobbing animation too
        shipNode.speed = max(multiplier, 0.2)
    }
    
    private func setupSea() {
        let seaTexture = SKTexture(imageNamed: "ocean")
        let seaNode = SKSpriteNode(texture: seaTexture)
        seaNode.setScale(0.5)
        let seaWidth = SKSpriteNode(texture: seaTexture).size.width * 0.5 - 3 // Corrected for scale 0.5
        let duration: TimeInterval = 4.0

        for i in 0..<8 {
            let seaNode = SKSpriteNode(texture: seaTexture)
            seaNode.zPosition = 2
            let initialX = CGFloat(i) * seaWidth
            seaNode.position = CGPoint(x: initialX, y: 100)
            seaNode.setScale(0.5)
        
            let rectSize = CGSize(width: 500, height: 200)
            let underSeaRect = SKShapeNode(rectOf: rectSize)
            underSeaRect.fillColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            underSeaRect.strokeColor = .clear
            underSeaRect.zPosition = 1
            underSeaRect.position = CGPoint(x: seaWidth / 2, y: -100)
            seaNode.addChild(underSeaRect)
            addChild(seaNode)
            
            // ADD THIS: Add to the tracking array
            speedAffectedNodes.append(seaNode)

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
            finalShipY = shipY + 10
        }
        if shipImageName == "ship_speedboat" {
            finalShipY = shipY - 25
        }
        if shipImageName == "ship_cargoboat" {
            finalShipY = shipY - 11
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
                    emitter.speed = shipNode.speed
                    speedAffectedNodes.append(emitter)
                    addChild(emitter)
                }
            }
    }
    
    private func setupSeabirds() {
        
    }
    
    // 1. Ubah parameter menjadi objek Fish
    func spawnFishVisual(fish: Fish) {
        
        // 2. Ubah nama variabel SKSpriteNode menjadi 'fishNode' agar tidak bentrok
        let fishNode = SKSpriteNode(imageNamed: fish.iconName)
        fishNode.size      = CGSize(width: 50, height: 50)
        fishNode.name      = fish.name
        fishNode.zPosition = 4
     
        // Spawn dari kanan layar
        let startY = CGFloat.random(in: fishMinY...fishMaxY)
        fishNode.position  = CGPoint(x: size.width + 60, y: startY)
        addChild(fishNode)
        
        // ADD THIS: New objects should inherit the current speed of the scene
        // We use the shipNode's current speed as a reference
        fishNode.speed = shipNode.speed
     
        let duration   = Double.random(in: 5...9)
     
        // FIX: posisi X kapal = size.width * 0.28 dari kiri
        // distToShip = jarak dari spawn point ke kapal
        let shipX      = size.width * 0.28
        let spawnX     = size.width + 60.0
        let distToShip = spawnX - shipX                    // selisih dari spawn ke kapal
        let totalDist  = spawnX + 80.0                     // total jarak sampai keluar layar kiri
        let timeToShip = (distToShip / totalDist) * duration
     
        // Action gerak ke kiri sampai keluar layar
        fishNode.run(.sequence([
            SKAction.moveTo(x: -80, duration: duration),
            SKAction.removeFromParent()
        ]))
     
        // Saat sampai di posisi kapal → tangkap
        // 3. Masukkan 'fishNode' ke dalam penangkapan weak (closure)
        let catchTrigger = SKAction.run { [weak self, weak fishNode] in
            guard let self = self,
                  let fishNode = fishNode,
                  fishNode.parent != nil else { return }
     
            // 4. Teruskan objek 'fish' (dari parameter fungsi) secara utuh!
            self.onFishCaught?(fish)
            
            self.showCatchEffect(at: fishNode.position)
            fishNode.removeFromParent()
        }
     
        fishNode.run(.sequence([
            .wait(forDuration: timeToShip),
            catchTrigger
        ]), withKey: "catchCheck")
    }
    
//    func spawnFishVisual(iconName: String, fishName: String) {
//        let fish = SKSpriteNode(imageNamed: iconName)
//        fish.size      = CGSize(width: 50, height: 25)
//        fish.name      = fishName
//        fish.zPosition = 3
//     
//        // Spawn dari kanan layar
//        let startY = CGFloat.random(in: fishMinY...fishMaxY)
//        fish.position  = CGPoint(x: size.width + 60, y: startY)
//        addChild(fish)
//     
//        let duration   = Double.random(in: 5...9)
//     
//        // FIX: posisi X kapal = size.width * 0.28 dari kiri
//        // distToShip = jarak dari spawn point ke kapal
//        let shipX      = size.width * 0.28
//        let spawnX     = size.width + 60.0
//        let distToShip = spawnX - shipX                    // selisih dari spawn ke kapal
//        let totalDist  = spawnX + 80.0                     // total jarak sampai keluar layar kiri
//        let timeToShip = (distToShip / totalDist) * duration
//     
//        // Action gerak ke kiri sampai keluar layar
//        fish.run(.sequence([
//            SKAction.moveTo(x: -80, duration: duration),
//            SKAction.removeFromParent()
//        ]))
//     
//        // Saat sampai di posisi kapal → tangkap
//        let catchTrigger = SKAction.run { [weak self, weak fish] in
//            guard let self = self,
//                  let fish = fish,
//                  fish.parent != nil else { return }
//     
//            self.onFishCaught?(fish.name ?? fishName)
//            self.showCatchEffect(at: fish.position)
//            fish.removeFromParent()
//        }
//     
//        fish.run(.sequence([
//            .wait(forDuration: timeToShip),
//            catchTrigger
//        ]), withKey: "catchCheck")
//    }
    
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
    
    func spawnObstacleVisual(_ type: ObstacleType) {
        switch type {
        case .albatros, .albatrosSteal:
            handleAlbatrosAnimation(isStealing: type == .albatrosSteal)

        case .lightning:
            handleLightningAnimation()

        case .tornado:
            handleTornadoAnimation()

        case .iceberg:
            handleIcebergAnimation()
            
        case .predator, .predatorBaited:
            handlePredatorAnimation(isAttacking: type == .predator)

        default:
            break
        }
    }
    
    private func handleAlbatrosAnimation(isStealing: Bool) {
        // 1. Prepare Textures (The Ping-Pong Pattern: 1 -> 2 -> 3 -> 2)
        let emptyBase = [
            SKTexture(imageNamed: "obs_albatros_empty_1"),
            SKTexture(imageNamed: "obs_albatros_empty_2"),
            SKTexture(imageNamed: "obs_albatros_empty_3")
        ]
        // Construct the 1,2,3,2 sequence
        let emptyTextures = [emptyBase[0], emptyBase[1], emptyBase[2], emptyBase[1]]
        
        let fishBase = [
            SKTexture(imageNamed: "obs_albatros_fish_1"),
            SKTexture(imageNamed: "obs_albatros_fish_2"),
            SKTexture(imageNamed: "obs_albatros_fish_3")
        ]
        // Construct the 1,2,3,2 sequence
        let fishTextures = [fishBase[0], fishBase[1], fishBase[2], fishBase[1]]
        
        // 2. Setup Bird Node
        let bird = SKSpriteNode(texture: emptyTextures[0])
        bird.setScale(0.2)
        bird.zPosition = 12
        bird.position = CGPoint(x: size.width + 50, y: skyMaxY)
        bird.speed = shipNode.speed
        addChild(bird)
        
        // 3. Flapping Animation (Time per frame set to 0.15 for smoother look)
        let flapEmpty = SKAction.repeatForever(SKAction.animate(with: emptyTextures, timePerFrame: 0.15))
        let flapFish = SKAction.repeatForever(SKAction.animate(with: fishTextures, timePerFrame: 0.15))
        bird.run(flapEmpty, withKey: "flapAction")
        
        // 4. Movement Logic (The Dive)
        let shipPos = shipNode.position
        let diveTarget = CGPoint(x: shipPos.x, y: shipPos.y + 15)
        let exitTarget = CGPoint(x: -100, y: skyMaxY)
        
        let dive = SKAction.move(to: diveTarget, duration: 1.5)
        dive.timingMode = .easeIn
        
        let grabFish = SKAction.run { [weak bird] in
            if isStealing {
                bird?.removeAction(forKey: "flapAction")
                bird?.run(flapFish, withKey: "flapAction")
            } else {
                let scarecrow = SKSpriteNode(imageNamed: "icon_scarecrow")
                scarecrow.position = CGPoint(x: shipPos.x, y: shipPos.y)
                scarecrow.setScale(0.1) // Start small for the "pop"
                scarecrow.alpha = 0
                scarecrow.zPosition = 11
                scarecrow.speed = self.shipNode.speed
                self.addChild(scarecrow)
                
                let popIn = SKAction.group([
                    SKAction.scale(to: 0.4, duration: 0.3),
                    SKAction.fadeIn(withDuration: 0.2),
                    SKAction.moveBy(x: 0, y: 20, duration: 0.3)
                ])
                popIn.timingMode = .easeOut
                
                let fadeOut = SKAction.group([
                    SKAction.fadeOut(withDuration: 0.5),
                    SKAction.moveBy(x: 0, y: 10, duration: 0.5)
                ])
                
                scarecrow.run(.sequence([
                    popIn,
                    .wait(forDuration: 0.8),
                    fadeOut,
                    .removeFromParent()
                ]))
            }
        }
        
        let flyAway = SKAction.move(to: exitTarget, duration: 1.8)
        flyAway.timingMode = .easeOut
        
        bird.run(.sequence([
            dive,
            grabFish,
            flyAway,
            .removeFromParent()
        ]))
    }
    
    private func handleLightningAnimation() {
        let bolt1 = SKTexture(imageNamed: "obs_lightning_1")
        let bolt2 = SKTexture(imageNamed: "obs_lightning_2")
        let bolt3 = SKTexture(imageNamed: "obs_lightning_3")
        
        let lightningNode = SKSpriteNode(texture: bolt1)
        lightningNode.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        // Make it follow the ship's current position
        lightningNode.position = shipNode.position
        lightningNode.zPosition = 15
        lightningNode.setScale(0.8) // Made it a bit bigger
        lightningNode.speed = shipNode.speed
        addChild(lightningNode)
        
        // Create a more violent flicker
        let flicker = SKAction.animate(with: [bolt1, bolt2, bolt3, bolt2, bolt1], timePerFrame: 0.04)
        let vanish = SKAction.removeFromParent()
        
        // FLASH: Add it to the camera so it covers the screen even if the camera shakes
        let flash = SKSpriteNode(color: .white, size: self.size)
        flash.zPosition = 100
        flash.alpha = 0
        mainCamera.addChild(flash) // flash is now child of camera
        
        let flashIn = SKAction.fadeAlpha(to: 0.8, duration: 0.02)
        let flashOut = SKAction.fadeOut(withDuration: 0.2)
        
        // Execute
        lightningNode.run(.sequence([flicker, vanish]))
        flash.run(.sequence([flashIn, flashOut, .removeFromParent()]))
        shakeScreen(intensity: "light")
    }
    
    private func handleTornadoAnimation() {
        let tornado = SKSpriteNode(imageNamed: "obs_tornado")
        tornado.setScale(0.5)
        tornado.position = CGPoint(x: size.width + 100, y: seaY + 50)
        tornado.zPosition = 8
        tornado.speed = shipNode.speed
        addChild(tornado)
        
        let rotate = SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 0.2))
        let move = SKAction.moveTo(x: -100, duration: 5.0)
        
        tornado.run(rotate)
        tornado.run(.sequence([move, .removeFromParent()]))
    }
    
    private func handleIcebergAnimation() {
        let iceberg = SKSpriteNode(imageNamed: "obs_iceberg")
        iceberg.setScale(0.3)
        iceberg.position = CGPoint(x: size.width + 100, y: seaY - 20)
        iceberg.zPosition = 1 // Behind the ship/sea
        //iceberg.speed = shipNode.speed
        addChild(iceberg)
        
        // Icebergs move slow and heavy
        let move = SKAction.moveTo(x: -100, duration: 5.0)
        iceberg.run(.sequence([move, .removeFromParent()]))
    }
    
    private func handlePredatorAnimation(isAttacking: Bool) {
        let shipPos = shipNode.position
        
        // Helper to create a tentacle
        func createTentacle(isLeft: Bool) -> SKSpriteNode {
            let sideStr = isLeft ? "left" : "right"
            // Start with the 'Lean' asset
            let tentacle = SKSpriteNode(imageNamed: "obs_kraken_\(sideStr)_1")
            tentacle.setScale(0.6)
            tentacle.zPosition = 1
            tentacle.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            let sideOffset: CGFloat = isAttacking ? (isLeft ? -120 : 120) : (isLeft ? -180 : 180)
            tentacle.position = CGPoint(x: shipPos.x + sideOffset, y: seaY - 300)
            
            return tentacle
        }
        
        let krakenHead = SKSpriteNode(imageNamed: isAttacking ? "obs_kraken_head_grumpy" : "obs_kraken_head_smile")
        krakenHead.setScale(0.4)
        krakenHead.zPosition = 1 // Slightly behind the tentacles
        krakenHead.position = CGPoint(x: isAttacking ? shipPos.x + 240 : shipPos.x + 200, y: seaY - 140)

        let leftTentacle = createTentacle(isLeft: true)
        let rightTentacle = createTentacle(isLeft: false)
        
        krakenHead.speed = shipNode.speed
        leftTentacle.speed = shipNode.speed
        rightTentacle.speed = shipNode.speed
        addChild(krakenHead)
        addChild(leftTentacle)
        addChild(rightTentacle)
        
        let headRise = SKAction.moveBy(x: 0, y: 120, duration: 0.6)
        headRise.timingMode = .easeOut

        let headWait = SKAction.wait(forDuration: isAttacking ? 1.2 : 0.4)

        let headSink = SKAction.moveBy(x: 0, y: -250, duration: 0.6)
        headSink.timingMode = .easeIn
        
        krakenHead.run(.sequence([
            headRise,
            headWait,
            headSink,
            .removeFromParent()
        ]))

        if isAttacking {
            // --- ATTACK: Rise -> Lean Back -> Slap -> Sink ---
            func runAttack(node: SKSpriteNode, isLeft: Bool) {
                let s = isLeft ? "left" : "right"
                let leanAngle: CGFloat = isLeft ? .pi/20 : -.pi/20
                
                let riseAndLean = SKAction.group([
                    SKAction.moveBy(x: 0, y: 160, duration: 0.8),
                    SKAction.rotate(toAngle: leanAngle, duration: 0.8)
                ])
                riseAndLean.timingMode = .easeOut
                
                let switchToSlap = SKAction.setTexture(SKTexture(imageNamed: "obs_kraken_\(s)_2"))
                
                let slap = SKAction.group([
                    SKAction.rotate(toAngle: -leanAngle, duration: 0.2),
                    SKAction.scale(to: 0.5, duration: 0.2)
                ])
                slap.timingMode = .easeIn
                
                let sink = SKAction.moveBy(x: 0, y: -250, duration: 0.5)
                sink.timingMode = .easeIn

                node.run(.sequence([
                    riseAndLean,
                    .wait(forDuration: 0.1), // Moment of tension
                    switchToSlap,
                    slap,
                    .wait(forDuration: 0.4),
                    sink,
                    .removeFromParent()
                ]))
            }
            
            runAttack(node: leftTentacle, isLeft: true)
            runAttack(node: rightTentacle, isLeft: false)

        } else {
            // --- BAITED: Rise & Grab centrally in one fluid motion ---
            let bait = SKSpriteNode(imageNamed: "icon_predator_bait")
            bait.setScale(0.3)
            bait.position = CGPoint(x: shipPos.x, y: seaY - 20)
            bait.alpha = 0
            bait.zPosition = 1
            bait.speed = shipNode.speed
            addChild(bait)

            func runBaited(node: SKSpriteNode, isLeft: Bool) {
                let s = isLeft ? "left" : "right"
                let grabAngle: CGFloat = isLeft ? -.pi/5 : .pi/5
                let moveInX: CGFloat = isLeft ? 60 : -60
                
                // Switch to Asset 2 almost immediately for a reaching look
                let switchToReach = SKAction.setTexture(SKTexture(imageNamed: "obs_kraken_\(s)_1"))
                
                let grabMotion = SKAction.group([
                    SKAction.moveBy(x: moveInX, y: 140, duration: 0.8),
                    SKAction.rotate(toAngle: grabAngle, duration: 0.8)
                ])
                grabMotion.timingMode = .easeInEaseOut
                
                let sink = SKAction.moveBy(x: 0, y: -300, duration: 0.6)
                
                node.run(.sequence([
                    switchToReach,
                    grabMotion,
                    .wait(forDuration: 0.1),
                    sink,
                    .removeFromParent()
                ]))
            }

            bait.run(.sequence([
                .wait(forDuration: 0.3),
                .group([.moveBy(x: 0, y: 10, duration: 0.3), .fadeIn(withDuration: 0.3)]),
                .wait(forDuration: 0.3),
                .group([.moveBy(x: 0, y: -120, duration: 0.3), .fadeOut(withDuration: 0.3)]),
                .removeFromParent()
            ]))
            
            runBaited(node: leftTentacle, isLeft: true)
            runBaited(node: rightTentacle, isLeft: false)
        }
    }
    
    func shakeScreen(intensity: String) {
        var shake: SKAction!
        switch intensity {
        case "heavy":
            let shakeAmount: CGFloat = 8
            let shakeWait = 0.03
            let shakeAction = SKAction.sequence([
                .moveBy(x: shakeAmount, y: -shakeAmount, duration: shakeWait),
                .moveBy(x: -shakeAmount * 2, y: shakeAmount * 2, duration: shakeWait),
                .moveBy(x: shakeAmount, y: -shakeAmount, duration: shakeWait),
            ])
            shake = shakeAction
        case "light":
            let shakeAmount: CGFloat = 4
            let shakeWait = 0.02
            let shakeAction = SKAction.sequence([
                .moveBy(x: shakeAmount, y: -shakeAmount, duration: shakeWait),
                .moveBy(x: -shakeAmount * 2, y: shakeAmount * 2, duration: shakeWait),
                .moveBy(x: shakeAmount, y: -shakeAmount, duration: shakeWait),
                .moveBy(x: shakeAmount, y: shakeAmount, duration: shakeWait),
                .moveBy(x: -shakeAmount, y: -shakeAmount, duration: shakeWait)
            ])
            shake = shakeAction
        default:
            shake = SKAction.sequence([])
        }
        
        mainCamera.run(shake)
        
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
