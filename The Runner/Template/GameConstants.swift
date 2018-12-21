//
//  GameConstants.swift
//  The Runner
//
//  Created by Alex Gomez on 12/19/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import Foundation
import CoreGraphics

struct GameConstants {
    
    struct ZPositions {
        static let farBackground: CGFloat = -1
        static let closeBackground: CGFloat = 0
        static let world: CGFloat = 1
        static let object: CGFloat = 2
        static let player: CGFloat = 3
        static let hud: CGFloat = 4
    }
    
    struct StringConstants {
        static let groundTitlesName = "Ground tiles"
        static let worldBackgroundNames = ["DesertBackground", "GrassBackground"]
        static let playerName = "Player"
        static let playerImageName = "Idle_0"
        static let groundNodeName = "GroundNode"
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let playerRunAtlas = "Player Run Atlas"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let playerDieAtlas = "Player Die Atlas"
        static let idlePrefixKey = "Idle_"
        static let runPrefixKey = "Run_"
        static let jumpPrefixKey = "Jump_"
        static let diePrefixKey = "Die_"
        
        static let jumpUpActionKey = "JumpUp"
        static let breakDescendActionKey = "BreakDescend"
    }
    
    
}
