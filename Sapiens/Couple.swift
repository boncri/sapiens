//
//  Couple.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 14/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class Couple
{
    var first : SKSpriteNode
    var second : SKSpriteNode
    
    var firstTouched:Bool = false
    var secondTouched:Bool = false
    
    var firstOriginalPosition : CGPoint?
    var secondOriginalPosition : CGPoint?
        
    init(firstImageName: String, secondImageName: String) {
        self.first = SKSpriteNode(imageNamed: firstImageName)
        self.second = SKSpriteNode(imageNamed: secondImageName)
    }
    
    init(first : SKSpriteNode, second: SKSpriteNode)
    {
        self.first = first
        self.second = second
    }
    
    func isTouched(node:SKSpriteNode) -> Bool {
        return (node == first && firstTouched) || (node == second && secondTouched)
    }
    
    func touched(node:SKSpriteNode, onlyFirst: Bool = false) -> SKSpriteNode? {
        if(node == first && !firstTouched)
        {
            touch(first)
            return first
        }
        if(node == second && !secondTouched && !onlyFirst)
        {
            touch(second)
            return second
        }
        return nil
    }
    
    func touch(node: SKSpriteNode) {
        if(node == first) {
            if(firstTouched) {
                return
            }
            firstTouched = true
            firstOriginalPosition = first.position
        }
        if(node == second) {
            if(secondTouched) {
                return
            }
            secondTouched = true
            secondOriginalPosition = second.position
        }
        
//        let action1 = SKAction.scaleTo(1.0, duration: 0.2)
//        let action2 = SKAction.scaleTo(1.1, duration: 0.2)
//        let action = SKAction.sequence([action1, action2])
        
        let action1 = SKAction.rotateByAngle(0.1, duration: 0.2)
        let action2 = SKAction.rotateByAngle(-0.2, duration: 0.4)
        let action3 = SKAction.rotateByAngle(0.1, duration: 0.2)
        let action = SKAction.sequence([action1, action2, action3])
        
        node.runAction(SKAction.repeatActionForever(action))
    }
    
    func untouched(node:SKSpriteNode) -> SKSpriteNode? {
        if(node == first && firstTouched)
        {
            firstTouched = false
            untouch(first)
            return first
        }
        if(node == second && secondTouched)
        {
            secondTouched = false
            untouch(second)
            return second
        }
        return nil
    }
    
    func stop() {
        untouch(first)
        untouch(second)
    }
    
    func reset() {
        stop()
        firstTouched=false
        secondTouched=false
    }
    
    private func untouch(node:SKSpriteNode) {
        var location : CGPoint?
        if(node == first) {
            location = firstOriginalPosition
            firstOriginalPosition = nil
        }
        if(node == second) {
            location = secondOriginalPosition
            secondOriginalPosition = nil
        }
        
        if let loc = location {
            node.removeAllActions()
            
            node.runAction(SKAction.group([SKAction.moveTo(loc, duration: 0.2), SKAction.rotateToAngle(0, duration: 0.2), SKAction.scaleTo(1, duration: 0.2)]))
        }
    }
    
    func allTouched() -> Bool {
        return firstTouched && secondTouched
    }
}