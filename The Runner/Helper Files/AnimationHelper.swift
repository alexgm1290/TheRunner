//
//  AnimationHelper.swift
//  The Runner
//
//  Created by Alex Gomez on 12/21/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import SpriteKit

class AnimationHelper {
    static func loadTexture(from atlas: SKTextureAtlas, with name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        
        for index in 0..<atlas.textureNames.count {
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
    }
}
