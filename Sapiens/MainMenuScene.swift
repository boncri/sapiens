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
    
    private let ombre = LevelChooseNode(imageNamed: "mm_ombre", level: 1)
    private let mangiare = LevelChooseNode(imageNamed: "mm_mangiare", level: 2)
    private let mangiare2 = LevelChooseNode(imageNamed: "mm_mangiare2", level: 3)
    private let colori = LevelChooseNode(imageNamed: "mm_colori", level: 4)
//    private let ombre = SKSpriteNode(imageNamed: "mm_ombre")
//    private let mangiare = SKSpriteNode(imageNamed: "mm_mangiare")
//    private let mangiare2 = SKSpriteNode(imageNamed: "mm_mangiare2")
//    private let colore = SKSpriteNode(imageNamed: "mm_colore")
    
    override func didMoveToView(view: SKView) {
        let width = self.frame.width / 2
        let height = self.frame.height / 2
        
        ombre.position = CGPoint(x: width / 2, y: 3 * height / 2)
        mangiare.position = CGPoint(x: 3 * width / 2, y: 3 * height / 2)
        mangiare2.position = CGPoint(x: width / 2, y: height / 2)
        colori.position = CGPoint(x: 3 * width / 2, y: height / 2)
        
        self.addChild(ombre)
        self.addChild(mangiare)
        self.addChild(mangiare2)
        self.addChild(colori)
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
            
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 1)
            
            self.view?.presentScene(game, transition: transition)
        }
    }
}