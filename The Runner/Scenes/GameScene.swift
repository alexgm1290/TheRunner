//
//  GameScene.swift
//  The Runner
//
//  Created by Alex Gomez on 12/17/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import SpriteKit

enum GameState {
    case ready, ongoing, paused, finished
}

class GameScene: SKScene {
    
    var worldLayer: Layer!
    var backgroundLayer: RepeatingLayer!
    
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var player : Player!
    var touch = false
    var brake = false
    
    var coins = 0
    var superCoins = 0
    
    var hudDelegate : HUDDelegate?
    
    var enemySprite : SKSpriteNode!
    
    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
                pauseEnemies(bool: false)
            case .finished:
                player.state = .idle
                pauseEnemies(bool: true)
            default:
                break
            }
        }
    }
    
    
    
    //MARK: - Methods
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.frameCategory
        physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
        
        createLayers()
    }
    
    func createLayers() {
        //MARK: World layer
        worldLayer = Layer()
        worldLayer.layerVelocity = CGPoint(x: -250, y: 0)
        worldLayer.zPosition = GameConstants.ZPositions.closeBackground
        addChild(worldLayer)
        
        //MARK: Background layer
        backgroundLayer = RepeatingLayer()
        backgroundLayer.layerVelocity = CGPoint(x: -100, y: 0)
        backgroundLayer.zPosition = GameConstants.ZPositions.farBackground
        addChild(backgroundLayer)
        
        for i in 0...1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundNames[0])
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0 + CGFloat(i) * backgroundImage.size.width, y: 0)
            backgroundLayer.addChild(backgroundImage)
        }
        
        //MARK: Load level
        load(level: "Level_0-1")
    }
    
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFromFile(file: level) {
            mapNode = levelNode
            levelNode.isPaused = false
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: GameConstants.StringConstants.groundTitlesName) as? SKTileMapNode {
            tileMap = groundTiles
            tileMap.scale(to: frame.size, width: false, multiplier: 0.8)
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "ground")
            
            for child in groundTiles.children {
                if let sprite = child as? SKSpriteNode, sprite.name != nil {
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
        }
        
        addPlayer()
        addHUD()
    }
    
    func addPlayer() {
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.15)
        player.name = GameConstants.StringConstants.playerName
        player.position = CGPoint(x: frame.midX / 2, y: frame.midY)
        player.zPosition = GameConstants.ZPositions.player
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        
        player.loadTextures()
        player.state = .idle
        
        addChild(player)
        
        addPlayerActions()
    }

    func addPlayerActions() {
        let up = SKAction.moveBy(x: 0, y: self.frame.size.height / 4, duration: 0.4)
        up.timingMode = .easeOut
        
        player.createUserData(entry: up, forKey: GameConstants.StringConstants.jumpUpActionKey)
        
        let move = SKAction.moveBy(x: 0, y: player.size.height, duration: 0.4)
        let jump = SKAction.animate(with: player.jumpFrames, timePerFrame: 0.4/Double(player.jumpFrames.count))
        let group = SKAction.group([move, jump])
        
        player.createUserData(entry: group, forKey: GameConstants.StringConstants.brakeDescendActionKey)
    }
    
    func jump() {
        player.airborne = true
        player.turnGravity(on: false)
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction) {
            if self.touch {
                self.player.run(self.player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction, completion: {
                    self.player.turnGravity(on: true)
                })
            }
        }
    }
    
    func brakeDescend() {
        brake = true
        player.physicsBody?.velocity.dy = 0
        
        if let sparkEmitter = ParticleHelper.addParticleEffect(name: GameConstants.StringConstants.brakeSparkEmitterKey, particlePositionRange: CGVector(dx: 30, dy: 30), position: CGPoint(x: player.position.x, y: player.position.y - player.size.height / 2)) {
            sparkEmitter.zPosition = GameConstants.ZPositions.object
            self.addChild(sparkEmitter)
        }
        
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.brakeDescendActionKey) as! SKAction) {
            ParticleHelper.removeParticleEffect(name: GameConstants.StringConstants.brakeSparkEmitterKey, from: self)
        }
        
    }
    
    func handleEnemyContact() {
        die(reason: 0)
    }
    
    //MARK: Retrieve all Enemy nodes in TileMap
    func pauseEnemies(bool: Bool) {
        for enemy in tileMap[GameConstants.StringConstants.enemyName] {
            enemy.isPaused = bool
        }
    }
    
    func handleCollectible(sprite: SKSpriteNode) {
        switch sprite.name {
        case GameConstants.StringConstants.coinName,
             _ where GameConstants.StringConstants.superCoinNames.contains(sprite.name!):
            collectCoin(sprite: sprite)
        default:
            break
        }
    }
    
    func collectCoin(sprite: SKSpriteNode) {
        if GameConstants.StringConstants.superCoinNames.contains(sprite.name!) {
            superCoins += 1
            for index in 0..<3 {
                if GameConstants.StringConstants.superCoinNames[index] == sprite.name {
                    hudDelegate?.addSuperCoin(index: index)
                }
            }
            
        } else {
            coins += 1
            hudDelegate?.updateCoinLabel(coins: coins)
        }
        
        
        if let coinDust = ParticleHelper.addParticleEffect(name: GameConstants.StringConstants.coinDustEmitterKey, particlePositionRange: CGVector(dx: 5, dy: 5), position: CGPoint.zero) {
            coinDust.zPosition = GameConstants.ZPositions.object
            sprite.addChild(coinDust)
            sprite.run(SKAction.fadeOut(withDuration: 0.4)) {
                coinDust.removeFromParent()
                sprite.removeFromParent()
            }
        }
    }
    
    func addHUD() {
        let hud = GameHUD(with: CGSize(width: frame.width, height: frame.height * 0.1))
        hud.position = CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.1)
        hud.zPosition = GameConstants.ZPositions.hud
        hudDelegate = hud
        addChild(hud)
    }
    
    func die(reason: Int) {
        gameState = .finished
        player.turnGravity(on: false)
        let deathAnimation: SKAction!
        switch reason {
        case 0:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        case 1:
            let up = SKAction.moveTo(y: frame.midY, duration: 0.25)
            let wait = SKAction.wait(forDuration: 0.1)
            let down = SKAction.moveTo(y: -player.size.height, duration: 0.2)
            deathAnimation = SKAction.sequence([up, wait, down])
        default:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        }
        
        player.run(deathAnimation) {
            self.player.removeFromParent()
        }
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        case .ongoing:
            touch = true
            if !player.airborne {
                jump()
            } else if !brake {
                brakeDescend()
            }
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //MARK: Move layers to left
        if lastTime > 0 {
            dt = currentTime - lastTime
        } else {
            dt = 0
        }
        lastTime = currentTime
        
        if gameState == .ongoing {
            worldLayer.update(dt)
            backgroundLayer.update(dt)
        }
    }
    
    override func didSimulatePhysics() {
        for node in tileMap[GameConstants.StringConstants.groundNodeName] {
            if let groundNode = node as? GroundNode {
                let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale
                let playerY = player.position.y - player.size.height / 3
                groundNode.isBodyActivated = playerY > groundY
            }
        }
    }
}




extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
            player.airborne = false
            brake = false
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.finishCategory:
            gameState = .finished
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.enemiesCategory:
            handleEnemyContact()
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.frameCategory:
            physicsBody = nil
            die(reason: 1)
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.collectibleCategory:
            // the "?" is used to test if true or false. If true, collectible is bodyB. If false, it's bodyA
            let collectible = contact.bodyA.node?.name == player.name ? contact.bodyB.node as! SKSpriteNode : contact.bodyA.node as! SKSpriteNode
            handleCollectible(sprite: collectible)
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
            player.airborne = true
        default:
            break
        }
    }
}
