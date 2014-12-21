//
//  MainMenuScene.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 18/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene : SKScene {

    override func didMoveToView(view: SKView) {        
        let width = self.frame.width / 4
        let height = self.frame.height / 4
        
        let levels = GameScene.LevelInfo.getLevels()
        
        for l in levels.allKeys {
            if let n = (l as String).toInt() {
                let x = width / 2 + CGFloat((n - 1) % 4) * width
                let y = self.frame.height - (height / 2 + CGFloat((((n - 1) - (n - 1) % 4) / 4)) * height)
                
                let button = LevelChooseNode(imageNamed: "level\(n)", level: n)
                button.position = CGPoint(x: x, y: y)
                button.xScale = 0
                button.yScale = 0
                
                self.addChild(button)
                
                button.runAction(SKAction.sequence([SKAction.waitForDuration(0.2 * Double(n)), SKAction.scaleTo(1, duration: 0.25)]))
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let touched : LevelChooseNode? = self.nodeAtPoint(location) as? LevelChooseNode
            
            if(touched? == nil) {
                return
            }
            
            var level = touched!.level
                        
            let game = GameScene(size: self.frame.size, level: level)
            
            let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1)
            
            self.view?.presentScene(game, transition: transition)
        }
    }
}