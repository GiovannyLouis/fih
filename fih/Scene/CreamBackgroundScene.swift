//
//  CardBackgroundScene.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 16/05/26.
//

import SpriteKit

class CreamBackgroundScene: SKScene {
    var cardBg: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        
        cardBg = SKSpriteNode(imageNamed: "card_background_cream") // Your asset name
        
        // SpriteKit uses percentages (0.0 to 1.0) for 9-slicing.
        // x and y define the start of the stretchable area. width and height define how much is stretchable.
        // Example: x:0.33, y:0.33, width: 0.34, height: 0.34 divides the image into 9 equal sections.
        // Adjust these values based on the exact pixel thickness of your border.
        cardBg.centerRect = CGRect(x: 0.33, y: 0.33, width: 0.34, height: 0.34)
        
        addChild(cardBg)
        updateSize()
    }
    
    // This is called automatically when SwiftUI resizes the view (because of .scaleMode = .resizeFill)
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        updateSize()
    }
    
    private func updateSize() {
        guard let cardBg = cardBg else { return }
        // Center the sprite
        cardBg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        // Stretch the sprite to fill the scene
        cardBg.size = self.size
    }
}
