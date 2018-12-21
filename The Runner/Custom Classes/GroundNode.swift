//
//  GroundNode.swift
//  The Runner
//
//  Created by Alex Gomez on 12/20/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import SpriteKit

class GroundNode: SKSpriteNode {

    var isBodyActivated: Bool = false {
        didSet {
            //if is true, setup activatedBody; if not, set physicsBody to nil
            physicsBody = isBodyActivated ? activatedBody : nil
        }
    }
    
    private var activatedBody: SKPhysicsBody?
    
    init(with size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        
        let bodyInitialPoint = CGPoint(x: 0, y: size.height)
        let bodyEndPoint = CGPoint(x: size.width, y: size.height)
        
        activatedBody = SKPhysicsBody(edgeFrom: bodyInitialPoint, to: bodyEndPoint)
        activatedBody?.restitution = 0
        
        physicsBody = isBodyActivated ? activatedBody : nil
        
        name = GameConstants.StringConstants.groundNodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
