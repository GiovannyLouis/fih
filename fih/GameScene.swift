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
    
    private func setupSea() {
        let seaTexture = SKTexture(imageNamed: "ocean")
        let seaWidth = seaTexture.size().width - 6
        let duration: TimeInterval = 4.0

        for i in 0..<4 {
            let seaNode = SKSpriteNode(texture: seaTexture)
            seaNode.zPosition = 2
            let initialX = CGFloat(i) * seaWidth
            seaNode.position = CGPoint(x: initialX, y: 100)
            
            let rectSize = CGSize(width: seaWidth + 10, height: 100)
            let underSeaRect = SKShapeNode(rectOf: rectSize)
            underSeaRect.fillColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            underSeaRect.strokeColor = .clear
            underSeaRect.zPosition = 1
            underSeaRect.position = CGPoint(x: seaWidth / 2, y: -100)
            seaNode.addChild(underSeaRect)
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
            
        case .predator:
            handlePredatorAnimation()

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
        addChild(iceberg)
        
        // Icebergs move slow and heavy
        let move = SKAction.moveTo(x: -100, duration: 5.0)
        iceberg.run(.sequence([move, .removeFromParent()]))
    }
    
    private func handlePredatorAnimation() {
        let shipPos = shipNode.position
        
        // Helper to create a tentacle
        func createTentacle(name: String, isLeft: Bool) -> SKSpriteNode {
            let tentacle = SKSpriteNode(imageNamed: name)
            tentacle.setScale(0.6)
            tentacle.zPosition = 1 // Just in front of the ship
            
            // CRITICAL: Set anchor point to bottom middle so it rotates from the base
            tentacle.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            // Start position: Under the sea level (seaY)
            let sideOffset: CGFloat = isLeft ? -120 : 120
            tentacle.position = CGPoint(x: shipPos.x + sideOffset, y: seaY-300)
            
            return tentacle
        }

        let leftTentacle = createTentacle(name: "obs_kraken_1", isLeft: true)
        let rightTentacle = createTentacle(name: "obs_kraken_2", isLeft: false)
        
        addChild(leftTentacle)
        addChild(rightTentacle)

        // --- ANIMATION SEQUENCE ---
        
        // 1. Rise from the depths
        let rise = SKAction.moveBy(x: 0, y: 160, duration: 0.8)
        rise.timingMode = .easeOut
        
        // 2. Anticipation (tilt slightly back before the slap)
        let tiltBackLeft = SKAction.rotate(toAngle: .pi/6, duration: 0.4)
        let tiltBackRight = SKAction.rotate(toAngle: -.pi/6, duration: 0.4)
        
        // 3. THE SLAP (Aggressive rotation + hard ease out)
        // Left rotates clockwise (negative), Right rotates counter-clockwise (positive)
        let slapLeft = SKAction.rotate(toAngle: -.pi/6, duration: 0.2)
        let slapRight = SKAction.rotate(toAngle: .pi/6, duration: 0.2)
        let scaleDown = SKAction.scale(to: 0.4, duration: 0.2)
        slapLeft.timingMode = .easeIn
        slapRight.timingMode = .easeIn
        
        let impactLeft = SKAction.group([slapLeft, scaleDown])
        let impactRight = SKAction.group([slapRight, scaleDown])
        
        // 4. Retreat
        let wait = SKAction.wait(forDuration: 0.5)
        let sink = SKAction.moveBy(x: 0, y: -200, duration: 0.6)
        sink.timingMode = .easeIn

        // Run Left Sequence
        leftTentacle.run(.sequence([
            rise,
            tiltBackLeft,
            impactLeft,
            slapLeft,
            wait,
            sink,
            .removeFromParent()
        ]))
        
        // Run Right Sequence
        rightTentacle.run(.sequence([
            rise,
            tiltBackRight,
            impactRight,
            slapRight,
            wait,
            sink,
            .removeFromParent()
        ]))
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
