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
    
    struct PhysicsCategories {
        static let noCategory : UInt32 = 0
        static let allCategory : UInt32 = UInt32.max
        static let playerCategory : UInt32 = 0x1
        static let groundCategory : UInt32 = 0x1 << 1
        static let finishCategory : UInt32 = 0x1 << 2
        static let collectibleCategory : UInt32 = 0x1 << 3
        static let enemiesCategory : UInt32 = 0x1 << 4
        static let frameCategory : UInt32 = 0x1 << 5
        static let ceilingCategory : UInt32 = 0x1 << 6
    }
    
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
        static let finishLineName = "FinishLine"
        static let enemyName = "Enemy"
        static let coinName = "Coin"
        static let coinImageName = "gold0"
        static let superCoinImageName = "SuperCoin"
        static let superCoinNames = ["Super1", "Super2", "Super3"]
        static let fontName = "Unanimous Inverted -BRK-"
        static let playButton = "PlayButton"
        static let pauseButton = "PauseButton"
        static let cancelButton = "CancelButton"
        static let menuButton = "MenuButton"
        static let retryButton = "RetryButton"
        static let emptyButton = "EmptyButton"
        static let bannerName = "Banner"
        static let popupLarge = "PopupLarge"
        static let popupSmall = "PopupSmall"
        static let starEmpty = "StarEmpty"
        static let starFull = "StarFull"
        static let popUpButtons = ["MenuButton", "PlayButton", "RetryButton", "CancelButton"]
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let playerRunAtlas = "Player Run Atlas"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let playerDieAtlas = "Player Die Atlas"
        static let idlePrefixKey = "Idle_"
        static let runPrefixKey = "Run_"
        static let jumpPrefixKey = "Jump_"
        static let diePrefixKey = "Die_"
        static let coinRotateAtlas = "Coin Rotate Atlas"
        static let coinPrefixKey = "gold"
        
        static let jumpUpActionKey = "JumpUp"
        static let brakeDescendActionKey = "BrakeDescend"
        
        static let coinDustEmitterKey = "CoinDustEmitter"
        static let brakeSparkEmitterKey = "BrakeSparkEmitter"
    }
    
    
}
