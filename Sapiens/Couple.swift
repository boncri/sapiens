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
    class Item {
        let sprite: SKSpriteNode
        var touched: Bool = false
        var originalPosition: CGPoint? = nil
        private var locked: Bool = false
        
        init(sprite: SKSpriteNode) {
            self.sprite = sprite
            self.originalPosition = nil
        }
        
        func shrink() {
            sprite.runAction(SKAction.scaleTo(0, duration: 0.5))
        }
        
        func moveTo(location: CGPoint) {
            sprite.runAction(SKAction.moveTo(location, duration: 0.2))
        }
        
        func lock() {
            self.locked = true
        }
        func unlock() {
            self.locked = false
        }
        func isLocked() -> Bool {
            return self.locked
        }
    }
    
    var first : [Item]
    var second : Item
    
    convenience init(firstImageName: String, secondImageName: String) {
        self.init(first: SKSpriteNode(imageNamed: firstImageName), second: SKSpriteNode(imageNamed: secondImageName))
    }
    
    convenience init(first : SKSpriteNode, second: SKSpriteNode)
    {
        self.init(first: [first], second: second)
    }
    
    init(first: [SKSpriteNode], second: SKSpriteNode) {
        self.first = []
        self.second = Item(sprite: second)
        
        for node in first {
            self.first.append(Item(sprite: node))
        }
    }
    
    func isTouched(node:SKSpriteNode) -> Bool {
        if(node == second.sprite && second.touched) {
            return true
        }
        for item in first {
            if (item.sprite == node && item.touched) {
                return true
            }
        }
        return false
    }
    
    func touched(node:SKSpriteNode, onlyFirst: Bool = false) -> SKSpriteNode? {
        if(node == second.sprite && !second.touched && !onlyFirst) {
            touch(second)
            return second.sprite
        }

        for item in first {
            if(node == item.sprite && !item.touched) {
                touch(item)
                return item.sprite
            }
        }
        return nil
    }
    
    func touch(item: Item) {
        if(item.touched) {
            return
        }
        item.touched = true
        item.originalPosition = item.sprite.position
        
//        let action1 = SKAction.scaleTo(1.0, duration: 0.2)
//        let action2 = SKAction.scaleTo(1.1, duration: 0.2)
//        let action = SKAction.sequence([action1, action2])
        
        let action1 = SKAction.rotateByAngle(0.1, duration: 0.2)
        let action2 = SKAction.rotateByAngle(-0.2, duration: 0.4)
        let action3 = SKAction.rotateByAngle(0.1, duration: 0.2)
        let action = SKAction.sequence([action1, action2, action3])
        
        item.sprite.runAction(SKAction.repeatActionForever(action))
    }
    
    func untouched(item:Item) -> SKSpriteNode? {
        if(item.touched) {
            item.touched = false
            untouch(item)
            return item.sprite
        }
        return nil
    }
    
    func stop() {
        untouch(second)
        for item in first {
            untouch(item)
        }
    }
    
    func reset() {
        stop()
        second.touched = false
        for item in first {
            item.touched = false
        }
    }
    
    private func untouch(item:Item) {
        if let location = item.originalPosition {
            item.originalPosition = nil
            item.sprite.removeAllActions()
            
            if !item.isLocked() {
                item.sprite.runAction(SKAction.group([SKAction.moveTo(location, duration: 0.2), SKAction.rotateToAngle(0, duration: 0.2), SKAction.scaleTo(1, duration: 0.2)]))
            }
        }
    }
    
    func areAllTouched() -> Bool {
        if !second.touched {
            return false
        }
        for item in first {
            if item.touched {
                return true
            }
        }
        return false
    }
    func firstTouched() -> Item? {
        for item in first {
            if item.touched {
                return item
            }
        }
        return nil
    }
    func secondTouched() -> Item? {
        return second.touched ? second : nil
    }
    func touchedItems() -> [Item] {
        var result : [Item] = []
        
        if let f = firstTouched() {
            result.append(f)
        }
        if let s = secondTouched() {
            result.append(s)
        }
        return result
    }
    
    func target() -> Int {
        return first.count
    }
}
