//
//  LevelChooseNode.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 20/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class LevelChooseNode : SKNode {
    
    let sprite:SKSpriteNode
    let level:Int
    
    init(imageNamed: String, level: Int) {
        self.level = level
        self.sprite = SKSpriteNode(imageNamed: imageNamed)
        
        super.init()

        self.addChild(sprite)
        sprite.zPosition = -1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
