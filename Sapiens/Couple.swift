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
        
        func rotateBy(angle: CGFloat) {
            sprite.runAction(SKAction.rotateByAngle(angle, duration: 0.2))
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
    
    func touched(node:SKSpriteNode, onlyFirst: Bool = false, touchEffect: [String:String]) -> SKSpriteNode? {
        if(node == second.sprite && !second.touched && !onlyFirst) {
            touch(second, touchEffect: touchEffect["second"]!)
            return second.sprite
        }

        for item in first {
            if(node == item.sprite && !item.touched) {
                touch(item, touchEffect: touchEffect["first"]!)
                return item.sprite
            }
        }
        return nil
    }
    
    func touch(item: Item, touchEffect: String) {
        if(item.touched) {
            return
        }
        item.touched = true
        item.originalPosition = item.sprite.position
        
        var action: SKAction
        var restoreActoin: SKAction
        switch(touchEffect) {
            case "swing":
                let action1 = SKAction.rotateByAngle(0.1, duration: 0.2)
                let action2 = SKAction.rotateByAngle(-0.2, duration: 0.4)
                let action3 = SKAction.rotateByAngle(0.1, duration: 0.2)
                let actionSeq = SKAction.sequence([action1, action2, action3])
                action = SKAction.repeatActionForever(actionSeq)
                restoreActoin = SKAction.rotateToAngle(0, duration: 0.2)
                
            default:
                action = SKAction.scaleTo(1.2, duration: 0.2)
                action.timingMode = SKActionTimingMode.EaseOut
                restoreActoin = SKAction.scaleTo(1, duration: 0.2)
        }

        item.sprite.runAction(action, withKey: "touched")
        if item.sprite.userData? == nil {
            item.sprite.userData = NSMutableDictionary()
        }
        item.sprite.userData?.setValue(restoreActoin, forKey: "touchedRestore")
    }
    
    func untouched(item:Item, restorePosition: Bool) -> SKSpriteNode? {
        if(item.touched) {
            item.touched = false
            untouch(item, restorePosition: restorePosition)
            return item.sprite
        }
        return nil
    }
    
    func stop(restorePosition: Bool) {
        untouch(second, restorePosition: restorePosition)
        for item in first {
            untouch(item, restorePosition: restorePosition)
        }
    }
    
    func reset() {
        stop(true)
        second.touched = false
        for item in first {
            item.touched = false
        }
    }
    
    private func untouch(item:Item, restorePosition: Bool) {
        item.sprite.removeActionForKey("touched")
        
        if !item.isLocked() {
            var actions : [SKAction] = []
            if let reverse = item.sprite.userData?.objectForKey("touchedRestore") as? SKAction {
                actions.append(reverse)
            }
            if restorePosition {
                if let location = item.originalPosition {
                    item.originalPosition = nil
                    actions.append(SKAction.moveTo(location, duration: 0.2))
                }
            }
            item.sprite.runAction(SKAction.group(actions))
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
