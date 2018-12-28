//
//  PhysicsHelper.swift
//  The Runner
//
//  Created by Alex Gomez on 12/20/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import SpriteKit

class PhysicsHelper {
    
    static func addPhysicsBody(to sprite: SKSpriteNode, with name: String) {
        
        switch name {
        case GameConstants.StringConstants.playerName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width / 2, height: sprite.size.height))
            sprite.physicsBody?.restitution = 0
            sprite.physicsBody?.allowsRotation = false
            sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.playerCategory
            sprite.physicsBody?.collisionBitMask = GameConstants.PhysicsCategories.groundCategory | GameConstants.PhysicsCategories.finishCategory
            sprite.physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.allCategory
        case GameConstants.StringConstants.finishLineName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.finishCategory
        case GameConstants.StringConstants.enemyName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.enemiesCategory
        case GameConstants.StringConstants.coinName,
             _ where GameConstants.StringConstants.superCoinNames.contains(name):
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.collectibleCategory
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        }
        
        if name != GameConstants.StringConstants.playerName {
            sprite.physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
            sprite.physicsBody?.isDynamic = false
        }
    }
    
    static func addPhysicsBody(to tileMap: SKTileMapNode, and tileInfo: String) {
        let tileSize = tileMap.tileSize
        
        for row in 0..<tileMap.numberOfRows {
            var tiles = [Int]()
            for column in 0..<tileMap.numberOfColumns {
                let tileDefinition = tileMap.tileDefinition(atColumn: column, row: row)
                let isUsedTile = tileDefinition?.userData?[tileInfo] as? Bool
                if (isUsedTile) ?? false {
                    tiles.append(1)
                } else {
                    tiles.append(0)
                }
            }
            
            if tiles.contains(1) {
                var platform = [Int]()
                
                for (index, tile) in tiles.enumerated() {
                    if tile == 1 && index < (tileMap.numberOfColumns - 1) {
                        platform.append(index)
                    } else if !platform.isEmpty {
                        let x = CGFloat(platform[0]) * tileSize.width
                        let y = CGFloat(row) * tileSize.height
                        let nodeHeight = tileSize.height - 1
                        let tileNode = GroundNode(with: CGSize(width: tileSize.width * CGFloat(platform.count), height: nodeHeight))
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.anchorPoint = CGPoint.zero
                        tileMap.addChild(tileNode)
                        platform.removeAll()
                    }
                }
            }
        }
    }
}
