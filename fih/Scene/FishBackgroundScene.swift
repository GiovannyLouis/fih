//
//  FishBackgroundScene.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 16/05/26.
//

import SpriteKit

class FishBackgroundScene: SKScene {
    
    override func didMove(to view: SKView) {
        // This function automatically runs when the .sks file finishes loading!
        
        // Loop through every single node you dragged into the .sks canvas
        for node in children {
            // Make sure it's a sprite node (a fish)
            if let fish = node as? SKSpriteNode {
                startSwimming(fish)
            }
        }
    }
    
    func startSwimming(_ fish: SKSpriteNode) {
        // 1. Give each fish a slightly different speed based on its scale
        // Smaller fish look further away, so they might seem faster or slower!
        let randomDuration = Double.random(in: 20.0...30.0)
        
        // 2. Calculate the destination (Off-screen to the right)
        // Since anchor point is (0.5, 0.5), the right edge is frame.width / 2
        let rightEdge = frame.width / 2 + fish.size.width
        let leftEdge = -frame.width / 2 - fish.size.width
        
        // 3. Create the swimming action
        let swimRight = SKAction.moveTo(x: rightEdge, duration: randomDuration)
        
        // 4. Create the teleport action to bring it back to the left side
        let teleportToLeft = SKAction.moveTo(x: leftEdge, duration: 0)
        
        // 5. Chain them together: Swim -> Teleport -> Repeat Forever
        let swimSequence = SKAction.sequence([swimRight, teleportToLeft])
        let continuousSwim = SKAction.repeatForever(swimSequence)
        
        // Run it!
        fish.run(continuousSwim)
    }
}
