//
//  CardBackgroundScene.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 16/05/26.
//

import SpriteKit

class CardBackgroundScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        
        let cardBg = SKSpriteNode(imageNamed: "card_background") // Your asset name
        
        // SpriteKit uses percentages (0.0 to 1.0) for 9-slicing.
        // Example: x: 0.1, y: 0.1 protects the outer 10% of the image from stretching.
        cardBg.centerRect = CGRect(x: 0.2, y: 0.2, width: 0.4, height: 0.4)
        
        // Center the sprite
        cardBg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Stretch the sprite to fill the scene
        cardBg.size = self.size
        
        addChild(cardBg)
    }
}
