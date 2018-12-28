//
//  GameHUD.swift
//  The Runner
//
//  Created by Alex Gomez on 12/28/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import SpriteKit

class GameHUD: SKSpriteNode, HUDDelegate {
    
    var coinLabel: SKLabelNode
    var superCoinCounter: SKSpriteNode
    
    init(with size: CGSize) {
        coinLabel = SKLabelNode(fontNamed: GameConstants.StringConstants.fontName)
        superCoinCounter = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: size.width * 0.3, height: size.height * 0.8))
        
        super.init(texture: nil, color: .clear, size: size)
        
        coinLabel.verticalAlignmentMode = .center
        coinLabel.text = "0"
        coinLabel.fontSize = 200
        coinLabel.scale(to: frame.size, width: false, multiplier: 0.8)
        coinLabel.position = CGPoint(x: frame.maxX - coinLabel.frame.size.width * 2, y: frame.midY)
        coinLabel.zPosition = GameConstants.ZPositions.hud
        addChild(coinLabel)
        
        superCoinCounter.position = CGPoint(x: frame.minX + superCoinCounter.frame.width / 2, y: frame.midY)
        superCoinCounter.zPosition = GameConstants.ZPositions.hud
        addChild(superCoinCounter)
        
        for i in 0..<3 {
            let emptySlot = SKSpriteNode(imageNamed: GameConstants.StringConstants.superCoinImageName)
            emptySlot.name = String(i)
            emptySlot.alpha = 0.5
            emptySlot.scale(to: superCoinCounter.size, width: true, multiplier: 0.3)
            emptySlot.position = CGPoint(x: (-superCoinCounter.size.width / 2 + emptySlot.size.width / 2) + (CGFloat(i) * superCoinCounter.size.width / 3) + (superCoinCounter.size.width * 0.1), y: superCoinCounter.frame.midY)
            emptySlot.zPosition = GameConstants.ZPositions.hud
            superCoinCounter.addChild(emptySlot)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCoinLabel(coins: Int) {
        coinLabel.text = "\(coins)"
    }
    
    func addSuperCoin(index: Int) {
        let emptySlot = superCoinCounter[String(index)].first as! SKSpriteNode
        emptySlot.alpha = 1
    }
    
    
}
