//
//  WhiteBackgroundScene.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 17/05/26.
//

import SpriteKit

class WhiteBackgroundScene: SKScene {
    var cardBg: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        cardBg = SKSpriteNode(imageNamed: "card_background_white")
        
        // 1. Masukkan dimensi ASLI dari gambar PNG Anda (misal 517 x 518)
        let imageWidth: CGFloat = 517.0
        let imageHeight: CGFloat = 518.0
        
        // 2. Masukkan ketebalan border hasil ukuran Slicing Anda (misal 30)
        let borderThickness: CGFloat = 15.0
        
        // 3. Biarkan kode menghitung persentasenya secara otomatis!
        let safeWidth = imageWidth - (borderThickness * 2)
        let safeHeight = imageHeight - (borderThickness * 2)
        
        cardBg.centerRect = CGRect(
            x: borderThickness / imageWidth,
            y: borderThickness / imageHeight,
            width: safeWidth / imageWidth,
            height: safeHeight / imageHeight
        )
        
        addChild(cardBg)
        updateSize()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        updateSize()
    }
    
    private func updateSize() {
        guard let cardBg = cardBg else { return }
        cardBg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        cardBg.size = self.size
    }
}
