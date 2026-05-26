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
        // Avoid invalid ratios (and divide-by-zero)
        guard maxSpeed > 0 else { return }

        let raw = currentSpeed / maxSpeed
        // Clamp ratio into [0, 1]
        let ratio = CGFloat(min(max(raw, 0.0), 1.0))
        let multiplier = ratio

        // Update all registered nodes (waves, particles, etc.)
        for node in speedAffectedNodes {
            node.speed = multiplier
        }

        // Optionally slow down the ship's bobbing animation too (safely if ship is not yet created)
        shipNode?.speed = max(multiplier, 0.7)
        print("Visual speed updated, multiplier: \(multiplier), ratio: \(ratio), currentSpeed: \(currentSpeed), maxSpeed: \(maxSpeed)")
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
                        emitter.position = CGPoint(x: frame.width + 70, y: frame.height - 100)
                        
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
    
    func equipmentVisual(_ type: EquipmentType) {
        let shipPos = shipNode.position
        switch type {
        case .guardianAngel:
            let angel = SKSpriteNode(imageNamed: "icon_guardian_angel")
                
            // Set posisi awal: Di tengah kapal, tapi agak bawah (untuk efek naik)
            // Kita gunakan koordinat scene karena angel biasanya melayang bebas, bukan nempel di tiang
            let startPos = CGPoint(x: shipNode.position.x, y: shipNode.position.y - 20)
            angel.position = startPos
            angel.alpha = 0
            angel.zPosition = 15 // Paling depan
            angel.setScale(0.4)  // Sesuaikan ukuran iconmu
            
            addChild(angel)
            
            // --- SEQUENCE ANIMASI ---
            
            // 1. Fade in sambil naik sedikit
            let appear = SKAction.group([
                SKAction.fadeIn(withDuration: 0.4),
                SKAction.moveBy(x: 0, y: 50, duration: 0.4)
            ])
            appear.timingMode = .easeOut
            
            // 2. Wait (durasi saat shield aktif menahan serangan)
            let wait = SKAction.wait(forDuration: 1.0)
            
            // 3. Fade out sambil naik lagi (seolah terbang ke langit)
            let disappear = SKAction.group([
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.moveBy(x: 0, y: 40, duration: 0.5)
            ])
            disappear.timingMode = .easeIn
            
            // Jalankan semua
            angel.run(.sequence([
                appear,
                wait,
                disappear,
                .removeFromParent() // Hapus dari memory setelah selesai
            ]))
            let goldColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
                
            // Blend ke warna emas 70%, lalu kembali ke warna asli kapal
            let flashIn = SKAction.colorize(with: goldColor, colorBlendFactor: 0.7, duration: 0.15)
            let flashOut = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.6)
            
            // Jalankan sekuens warna pada shipNode (Tanpa scaleUp/scaleDown)
            shipNode.run(.sequence([flashIn, flashOut]))
        case .luckyHat:
            // 1. Cek dulu supaya nggak spawn dua kali
            if shipNode.childNode(withName: "hat_node") != nil { return }
            
            let hat = SKSpriteNode(imageNamed: "icon_lucky_hat")
            hat.name = "hat_node"
            
            // 2. Tentukan posisi koordinat lokal (dalam sistem koordinat asli gambar kapal)
            // Karena shipNode skalanya 0.1, angka koordinat di sini akan besar-besar
            var hatPosition: CGPoint
            
            switch shipImageName {
            case "ship_fishingboat":
                hatPosition = CGPoint(x: 160, y: 750)  // Di atas kabin boat
            case "ship_speedboat":
                hatPosition = CGPoint(x: 200, y: 450) // Di atas kursi pengemudi
            case "ship_cargoboat":
                hatPosition = CGPoint(x: -850, y: 600) // Di atas tower belakang
            default:
                hatPosition = CGPoint(x: 0, y: 500)
            }
            
            hat.position = hatPosition
            hat.zPosition = 10 // Pastikan di depan badan kapal
            
            /* Skala topi: Karena dia jadi child dari shipNode (0.1),
               maka scale 1.0 di sini artinya topi akan sekecil 10% ukuran aslinya.
               Kalau topinya masih kegedean, kecilin ke 0.5 atau 0.8.
            */
            hat.setScale(1.2)
            
            // 3. Tambahkan ke shipNode agar "nempel" permanen
            shipNode.addChild(hat)
            
            // Efek pop-in kecil biar manis
            hat.alpha = 0
            hat.run(SKAction.fadeIn(withDuration: 0.1))
        case .predatorBait:
            let bait = SKSpriteNode(imageNamed: "icon_predator_bait")
            bait.setScale(0.3)
            bait.position = CGPoint(x: shipPos.x, y: seaY - 20)
            bait.alpha = 0
            bait.zPosition = 1
            addChild(bait)
            
            bait.run(.sequence([
                .wait(forDuration: 0.3),
                .group([.moveBy(x: 0, y: 10, duration: 0.3), .fadeIn(withDuration: 0.3)]),
                .wait(forDuration: 0.3),
                .group([.moveBy(x: 0, y: -120, duration: 0.3), .fadeOut(withDuration: 0.3)]),
                .removeFromParent()
            ]))
        case .rocketThrusters:
            if shipNode.childNode(withName: "rocket_effect") != nil { return }
                    
            // 2. Tentukan koordinat anchor berdasarkan image kapal
            // Angka ini adalah koordinat "asli" gambar sebelum kena scale 0.1
            var anchorPoint: CGPoint
            
            switch shipImageName {
            case "ship_fishingboat":
                anchorPoint = CGPoint(x: -1200, y: -500)
            case "ship_speedboat":
                anchorPoint = CGPoint(x: -1200, y: 80)
            case "ship_cargoboat":
                anchorPoint = CGPoint(x: -1600, y: 200)
            default:
                anchorPoint = CGPoint(x: -1000, y: 0)
            }
            
            // 3. Setup Texture & Node
            let textures = [
                SKTexture(imageNamed: "icon_flame_1"),
                SKTexture(imageNamed: "icon_flame_2"),
                SKTexture(imageNamed: "icon_flame_3")
            ]
            
            let rocket = SKSpriteNode(texture: textures[0])
            rocket.name = "rocket_effect"
            rocket.zPosition = -1 // Di belakang kapal
            rocket.position = anchorPoint
            
            /* TIPS SKALA:
               Karena shipNode skalanya 0.1, maka rocket yang jadi child
               secara otomatis akan ikut mengecil 10x lipat.
               Jika api roket terlihat kekecilan, naikkan setScale-nya di sini.
            */
            rocket.setScale(1.8)
            
            // 4. Jalankan Animasi
            let animation = SKAction.animate(with: textures, timePerFrame: 0.1)
            rocket.run(SKAction.repeatForever(animation))
            
            // 5. Tempel ke kapal
            shipNode.addChild(rocket)
        case .scarecrow:
            let scarecrow = SKSpriteNode(imageNamed: "icon_scarecrow")
            scarecrow.position = CGPoint(x: shipPos.x, y: shipPos.y + 40)
            scarecrow.setScale(0.1) // Start small for the "pop"
            scarecrow.alpha = 0
            scarecrow.zPosition = 11
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
        case .shield:
            // 1. Cek apakah shield sudah ada, kalau belum, kita buat tapi sembunyikan (alpha 0)
            var shield: SKSpriteNode
            if let existingShield = shipNode.childNode(withName: "shield_node") as? SKSpriteNode {
                shield = existingShield
            } else {
                shield = SKSpriteNode(imageNamed: "icon_shield")
                shield.name = "shield_node"
                shield.zPosition = 1
                shield.alpha = 0 // Standby mode
                
                let shieldPos: CGPoint
                switch shipImageName {
                    case "ship_fishingboat": shieldPos = CGPoint(x: 0, y: shipPos.y - 200)
                    case "ship_speedboat":   shieldPos = CGPoint(x: 0, y: shipPos.y)
                    case "ship_cargoboat":   shieldPos = CGPoint(x: 0, y: shipPos.y)
                    default:                 shieldPos = CGPoint(x: 0, y: 0)
                }
                
                // Atur posisi moncong sesuai tipe kapal
                shield.position = shieldPos
                shipNode.addChild(shield)
            }

            // --- ANIMASI REAKTIF (SAAT KENA DAMAGE) ---
            
            // Hentikan animasi shield yang sedang berjalan (jika ada) agar tidak tumpang tindih
            shield.removeAllActions()
            
            // 1. Reset state: Kecil dan transparan
            shield.setScale(3)
            shield.alpha = 0
            
            // 2. Efek "Hard Impact" Show Up
            let appear = SKAction.group([
                SKAction.fadeIn(withDuration: 0.05), // Sangat cepat munculnya
                SKAction.scale(to: 7, duration: 0.05), // Meledak jadi besar (overshoot)
            ])
            
            // 3. Efek "Locking" (Kembali ke ukuran normal dengan kaku)
            let lockIn = SKAction.group([
                SKAction.scale(to: 5, duration: 0.1), // Ukuran solid-nya
            ])
            
            // 4. Durasi diam (menahan serangan) + Getaran mesin
            let vibrate = SKAction.repeat(SKAction.sequence([
                SKAction.moveBy(x: 2, y: 0, duration: 0.02),
                SKAction.moveBy(x: -2, y: 0, duration: 0.02)
            ]), count: 10)
            
            // 5. Dissolve (Menghilang pelan setelah tugas selesai)
            let dissolve = SKAction.group([
                SKAction.fadeOut(withDuration: 0.4),
                SKAction.scale(to: 3, duration: 0.4)
            ])
            
            // Jalankan Sequence
            shield.run(.sequence([
                appear,
                lockIn,
                vibrate,
                .wait(forDuration: 0.5),
                dissolve
            ]))
            
            // Tambahan: Kapal ikut bergetar sedikit (Bukan scaling) sebagai reaksi shield menahan beban
            let shipRecoil = SKAction.sequence([
                SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                SKAction.moveBy(x: 10, y: 0, duration: 0.1)
            ])
            shipNode.run(shipRecoil)
        case .soulEater:
            let healColor = UIColor(red: 0.0, green: 1.0, blue: 0.2, alpha: 1.0)
                
            // 1. Set warna target pada node kapal
            shipNode.color = healColor
            
            // 2. Buat action untuk blending
            // Blend ke 0.7 (70% hijau) dalam sekejap, lalu balik ke 0.0 (warna asli)
            let flashIn = SKAction.colorize(withColorBlendFactor: 0.7, duration: 0.1)
            let flashOut = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.5)
            
            // 3. Tambahkan sedikit efek "pulsing" pada skala agar lebih terasa seperti 'heal'
            let scaleUp = SKAction.scale(to: 0.11, duration: 0.1) // 0.1 adalah skala aslimu
            let scaleDown = SKAction.scale(to: 0.1, duration: 0.4)
            
            let colorSequence = SKAction.sequence([flashIn, flashOut])
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            
            shipNode.run(SKAction.group([colorSequence, scaleSequence]))
        }
    }
    
    func handleAlbatrosAnimation(isStealing: Bool, isScarecrow: Bool) {
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
            } else {
                if isScarecrow {
                    self.equipmentVisual(.scarecrow)
                }
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
    
    func handleLightningAnimation() {
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
    
    func handleTornadoAnimation() {
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
    
    func handleIcebergAnimation() {
        let iceberg = SKSpriteNode(imageNamed: "obs_iceberg")
        iceberg.setScale(0.3)
        iceberg.position = CGPoint(x: size.width + 100, y: seaY - 20)
        iceberg.zPosition = 1 // Behind the ship/sea
        iceberg.speed = shipNode.speed
        addChild(iceberg)
        
        // Icebergs move slow and heavy
        let move = SKAction.moveTo(x: -100, duration: 5.0)
        iceberg.run(.sequence([move, .removeFromParent()]))
    }
    
    func handlePredatorAnimation(isAttacking: Bool) {
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
            
            equipmentVisual(.predatorBait)
            runBaited(node: leftTentacle, isLeft: true)
            runBaited(node: rightTentacle, isLeft: false)
        }
    }
    
    func handleEngineFailureAnimation() {
        // Cari apakah sudah ada asap (agar tidak double/stack saat engine failure aktif)
        if childNode(withName: "engine_smoke") != nil { return }
        
        // Buat node induk untuk asap agar mudah dihapus nanti jika diperbaiki
        let smokeEmitter = SKNode()
        smokeEmitter.name = "engine_smoke"
        smokeEmitter.position = CGPoint(x: shipNode.position.x - 20, y: shipNode.position.y + 20)
        addChild(smokeEmitter)
        
        let spawnSmoke = SKAction.run { [weak self] in
            guard let self = self else { return }
            let smoke = SKSpriteNode(imageNamed: "obs_enginefailure")
            smoke.setScale(0.1)
            smoke.alpha = 0.6
            smoke.zPosition = 10
            smoke.position = CGPoint.zero // Relatif terhadap smokeEmitter
            smokeEmitter.addChild(smoke)
            
            // Gerakan asap: Naik, membesar sedikit, lalu hilang
            let moveUp = SKAction.moveBy(x: CGFloat.random(in: -20...20), y: 100, duration: 1.5)
            let scaleUp = SKAction.scale(to: 0.3, duration: 1.5)
            let fadeOut = SKAction.fadeOut(withDuration: 1.5)
            
            smoke.run(.sequence([
                .group([moveUp, scaleUp, fadeOut]),
                .removeFromParent()
            ]))
        }
        
        let wait = SKAction.wait(forDuration: 0.2) // Interval antar asap
        smokeEmitter.run(SKAction.repeatForever(.sequence([spawnSmoke, wait])))
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

