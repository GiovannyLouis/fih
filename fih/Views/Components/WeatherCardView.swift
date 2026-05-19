//
//  WeatherCardView.swift
//  fih
//
//  Created by Jose Putra Perdana Taneo on 19/05/26.
//

import SpriteKit
import Foundation

final class WeatherCardScene: SKScene {
    private let textureName: String
    private let cornerInset: CGFloat
    private var cardNode: SKSpriteNode!

    init(size: CGSize, textureName: String = "frame_normal.png", cornerInset: CGFloat = 12) {
        self.textureName = textureName
        self.cornerInset = cornerInset
        super.init(size: size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let texture = SKTexture(imageNamed: textureName)
        let node = SKSpriteNode(texture: texture)
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)

        // Compute normalized insets for 9-slicing
        let texSize = texture.size()
        // Avoid divide-by-zero and clamp to < 0.5 for safety
        let nx = min(max(cornerInset / max(texSize.width, 1), 0), 0.49)
        let ny = min(max(cornerInset / max(texSize.height, 1), 0), 0.49)
        node.centerRect = CGRect(x: nx, y: ny, width: 1 - (2 * nx), height: 1 - (2 * ny))

        node.size = size
        addChild(node)
        self.cardNode = node
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        // Keep the 9-sliced sprite filling the scene as it resizes
        cardNode?.size = size
        cardNode?.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
}

