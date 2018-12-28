//
//  ObjectHelper.swift
//  The Runner
//
//  Created by Alex Gomez on 12/21/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import SpriteKit

class ObjectHelper {
    
    static func handleChild(sprite: SKSpriteNode, with name: String) {
        switch name {
        case GameConstants.StringConstants.finishLineName, GameConstants.StringConstants.enemyName,
             _ where GameConstants.StringConstants.superCoinNames.contains(name):
             PhysicsHelper.addPhysicsBody(to: sprite, with: name)
        default:
            // Create coins to the Map
            let component = name.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            if let rows = Int(component[0]), let columns = Int(component[1]) {
                calculateGridWith(rows: rows, columns: columns, parent: sprite)
            }
        }
    }
    
    static func calculateGridWith(rows: Int, columns: Int, parent: SKSpriteNode) {
        parent.color = .clear
        
        //Create CGPoints for the coins based on columns and rows. Eg. 0,0; 0,1; 0,2....1,0; 1;1, and so on.
        for x in 0..<columns {
            for y in 0..<rows {
                let position = CGPoint(x: x, y: y)
                addCoin(to: parent, at: position, columns: columns)
            }
        }
    }
    
    static func addCoin(to parent: SKSpriteNode, at position: CGPoint, columns: Int) {
        let coin = SKSpriteNode(imageNamed: GameConstants.StringConstants.coinName)
        coin.size = CGSize(width: parent.size.width / CGFloat(columns), height: parent.size.height / CGFloat(columns))
        coin.name = GameConstants.StringConstants.coinName
        
        // + coin.size.width / 2 used to counter the anchor point
        coin.position = CGPoint(x: position.x * coin.size.width + coin.size.width / 2, y: position.y * coin.size.height + coin.size.height / 2)
        
        let coinFrames = AnimationHelper.loadTexture(from: SKTextureAtlas(named: GameConstants.StringConstants.coinRotateAtlas), with: GameConstants.StringConstants.coinPrefixKey)
        
        coin.run(SKAction.repeatForever(SKAction.animate(with: coinFrames, timePerFrame: 0.1)))
        
        PhysicsHelper.addPhysicsBody(to: coin, with: GameConstants.StringConstants.coinName)
        
        parent.addChild(coin)
        
    }
    
}
