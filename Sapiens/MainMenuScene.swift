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
    
    private let ombre = SKSpriteNode(imageNamed: "mm_ombre")
    private let mangiare = SKSpriteNode(imageNamed: "mm_mangiare")

    override func didMoveToView(view: SKView) {
        ombre.position = CGPoint(x: self.frame.width / 2, y: (2 * self.frame.height) / 3)
        mangiare.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 3)
        
        self.addChild(ombre)
        self.addChild(mangiare)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let touched : SKSpriteNode? = self.nodeAtPoint(location) as? SKSpriteNode
            
            if(touched? == nil) {
                return
            }
            
            let level = touched == ombre ? 1 : 2
            
            let game = GameScene(size: self.frame.size, level: level)
            
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 1)
            
            self.view?.presentScene(game, transition: transition)
        }
    }
}