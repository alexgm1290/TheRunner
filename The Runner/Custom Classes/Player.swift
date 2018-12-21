//
//  PlayerSpriteNode.swift
//  The Runner
//
//  Created by Alex Gomez on 12/19/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import SpriteKit

enum PlayerState {
    case idle, running
}

class Player: SKSpriteNode {

    var runFrames = [SKTexture]()
    var idleFrames = [SKTexture]()
    var jumpFrames = [SKTexture]()
    var dieFrames = [SKTexture]()
    
    var state = PlayerState.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    var airborne = false
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTexture(from: SKTextureAtlas(named: GameConstants.StringConstants.playerIdleAtlas), with: GameConstants.StringConstants.idlePrefixKey)
        runFrames = AnimationHelper.loadTexture(from: SKTextureAtlas(named: GameConstants.StringConstants.playerRunAtlas), with: GameConstants.StringConstants.runPrefixKey)
        jumpFrames = AnimationHelper.loadTexture(from: SKTextureAtlas(named: GameConstants.StringConstants.playerJumpAtlas), with: GameConstants.StringConstants.jumpPrefixKey)
        dieFrames = AnimationHelper.loadTexture(from: SKTextureAtlas(named: GameConstants.StringConstants.playerDieAtlas), with: GameConstants.StringConstants.diePrefixKey)
    }
    
    func animate(for state: PlayerState) {
        removeAllActions()
        
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
    }
    
}
