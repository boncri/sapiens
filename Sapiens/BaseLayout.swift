//
//  LayoutBase.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 19/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class BaseLayout {
    let size:CGSize
    let topLeft:CGPoint
    let options:NSDictionary
    var nodes : [SKNode]
    
    init(size: CGSize, topLeft: CGPoint, options: NSDictionary) {
        self.size = size
        self.topLeft = topLeft
        self.options = options
        self.nodes = [SKNode]()
    }
    
    func placeAll(couples: [Couple], scene: SKNode) {
        fatalError("Must be overridden")
    }
    
    func commitLayout() {
//        let appear = SKAction.group([
//            SKAction.scaleTo(1.0, duration: 0.25),
//            SKAction.fadeAlphaTo(1.0, duration: 0.25)
//        ])
        let appear = SKAction.scaleTo(1.0, duration: 0.25)

        appear.timingMode = SKActionTimingMode.EaseOut
        
        for node in nodes {
            node.runAction(appear)
        }
    }
    
    func placeNode(scene: SKNode, node: SKNode) {
        node.setScale(0.0)
        node.alpha = 1.0
    
        scene.addChild(node)
        self.nodes.append(node)
    }
}