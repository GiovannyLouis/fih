//
//  MainMenuScene.swift
//  fih
//
//  Created by Jose Putra Perdana Taneo on 19/05/26.
//

import SpriteKit

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        // MARK: Ship
        if let ship = childNode(withName: "Ship") {
            startBobbingAnimation(node: ship)
        } else {
            print("Failed to find the Ship node!")
        }
        
        // MARK: Cloud
        startCloudAnimation()
        
        // MARK: Bird
        startBirdAnimation()
        
        // MARK: Ocean
        startOceanAnimation()
        
        // MARK: Wave
        startWaveAnimation()
        
        // MARK: Tree and Grass
        startWindAnimation()
    }
    
    private func startBobbingAnimation(node: SKNode) {
        // move up and move down actions
        let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 2.0)
        let moveDown = SKAction.moveBy(x: 0, y: -20, duration: 2.0)
        
        moveUp.timingMode = .easeInEaseOut
        moveDown.timingMode = .easeInEaseOut
        
        // sequence and repeat it forever
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeatForever = SKAction.repeatForever(sequence)
        
        node.run(repeatForever)
    }
    
    private func startCloudAnimation() {
        enumerateChildNodes(withName: "//cloud") { (node, stop) in
            // random duration.
            let randomDuration = TimeInterval.random(in: 50.0...100.0)
                
            // travel distance.
            let moveLeft = SKAction.moveBy(
                x: -1500,
                y: 0,
                duration: randomDuration
            )
                
            // reset.
            let snapRight = SKAction.moveBy(x: 1500, y: 0, duration: 0)
                
            // sequence and loop
            let sequence = SKAction.sequence([moveLeft, snapRight])
            let repeatForever = SKAction.repeatForever(sequence)
                
            node.run(repeatForever)
        }
    }
    
    private func startBirdAnimation() {
        enumerateChildNodes(withName: "//bird") { (node, stop) in
            let randomDuration = TimeInterval.random(in: 10.0...20.0)
                    
            // HORIZONTAL MOVEMENT
            let spawnRightX: CGFloat = 1500
            let travelDistance: CGFloat = -3000
                    
            let moveLeft = SKAction.moveBy(
                x: travelDistance,
                y: 0,
                duration: randomDuration
            )
                    
            let snapRight = SKAction.run {
                node.position.x = spawnRightX
            }
                    
            let horizontalSequence = SKAction.sequence([moveLeft, snapRight])
            let horizontalLoop = SKAction.repeatForever(horizontalSequence)
                    
            // VERTICAL MOVEMENT
            let randomYMove = CGFloat.random(in: 40...60)
            
            let moveUp = SKAction.moveBy(x: 0, y: randomYMove, duration: 2.0)
            let moveDown = SKAction.moveBy(
                x: 0,
                y: -(randomYMove),
                duration: 2.0
            )
            moveUp.timingMode = .easeInEaseOut
            moveDown.timingMode = .easeInEaseOut
                    
            let verticalSequence = SKAction.sequence([moveUp, moveDown])
            let verticalLoop = SKAction.repeatForever(verticalSequence)
                    
            // COMBINE THEM
            let flyAndBob = SKAction.group([horizontalLoop, verticalLoop])
                    
            node.run(flyAndBob)
        }
    }
    
    private func startOceanAnimation() {
        enumerateChildNodes(withName: "//ocean") { (node, stop) in
            let segmentWidth = (node.frame.width) - 10
                    
            let moveRight = SKAction.moveBy(
                x: segmentWidth,
                y: 0,
                duration: 6.0
            )
                    
            // Snap back
            let snapLeft = SKAction.moveBy(x: -segmentWidth, y: 0, duration: 0)
                
            // sequence and loop
            let sequence = SKAction.sequence([moveRight, snapLeft])
            let repeatForever = SKAction.repeatForever(sequence)
                
            node.run(repeatForever)
        }
    }
    
    private func startWaveAnimation() {
        enumerateChildNodes(withName: "//small_wave") { (node, stop) in
            let moveRight = SKAction.moveBy(
                x: 1500,
                y: 0,
                duration: 40
            )
                
            // reset.
            let snapLeft = SKAction.moveBy(x: -1500, y: 0, duration: 0)
                
            let horizontalSequence = SKAction.sequence([moveRight, snapLeft])
            let horizontalLoop = SKAction.repeatForever(horizontalSequence)
                    
            // VERTICAL MOVEMENT
            let randomYMove = CGFloat.random(in: 5...10)
            
            let moveUp = SKAction.moveBy(x: 0, y: randomYMove, duration: 2.0)
            let moveDown = SKAction.moveBy(
                x: 0,
                y: -(randomYMove),
                duration: 2.0
            )
            moveUp.timingMode = .easeInEaseOut
            moveDown.timingMode = .easeInEaseOut
                    
            let verticalSequence = SKAction.sequence([moveUp, moveDown])
            let verticalLoop = SKAction.repeatForever(verticalSequence)
                    
            // COMBINE THEM
            let flyAndBob = SKAction.group([horizontalLoop, verticalLoop])
                    
            node.run(flyAndBob)
        }
    }
    
    private func startWindAnimation() {
        let windNodes = ["//tree", "//grass"]
            
        for nodeName in windNodes {
            enumerateChildNodes(withName: nodeName) { (node, stop) in
                let leanAngle: CGFloat = 0.05
                let swingDuration = TimeInterval.random(in: 2.5...3.5)
                    
                let swingRight = SKAction.rotate(
                    toAngle: leanAngle,
                    duration: swingDuration
                )
                let swingLeft = SKAction.rotate(
                    toAngle: -leanAngle,
                    duration: swingDuration
                )
                    
                swingRight.timingMode = .easeInEaseOut
                swingLeft.timingMode = .easeInEaseOut
                    
                let sequence = SKAction.sequence([swingRight, swingLeft])
                node.run(SKAction.repeatForever(sequence))
            }
        }
    }
}
