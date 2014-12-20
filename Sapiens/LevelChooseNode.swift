//
//  LevelChooseNode.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 20/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class LevelChooseNode : SKSpriteNode {
    
    let level:Int
    
    init(imageNamed: String, level: Int) {
        self.level = level
        
        let texture = SKTexture(imageNamed:  imageNamed)
        
        super.init(texture: texture, color: UIColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
