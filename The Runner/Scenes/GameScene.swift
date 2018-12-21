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
    
    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
            case .finished:
                player.state = .idle
            default:
                break
            }
        }
    }
    
    var player : Player!
    
    //MARK: - Methods
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        
        createLayers()
    }
    
    func createLayers() {
        //MARK: World layer
        worldLayer = Layer()
        worldLayer.layerVelocity = CGPoint(x: -200, y: 0)
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
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: GameConstants.StringConstants.groundTitlesName) as? SKTileMapNode {
            tileMap = groundTiles
            tileMap.scale(to: frame.size, width: false, multiplier: 0.8)
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "ground")
        }
        
        addPlayer()
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

    }
    
    func jump() {
        player.airborne = true
        player.turnGravity(on: false)
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction) {
            self.player.turnGravity(on: true)
        }
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        case .ongoing:
            
            if !player.airborne {
                jump()
            }
            
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    
}
