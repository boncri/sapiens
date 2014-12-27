//
//  CoupleEffect.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 25/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class CoupleEffect {
    typealias Effect = (first: Couple.Item, second: Couple.Item) -> Void
    typealias EffectDictionary = [String:Effect]
    typealias ParamDictionary = NSDictionary
    
    private let effects: EffectDictionary = EffectDictionary()
    private let parameters : ParamDictionary

    init(parameters : NSDictionary) {
        self.effects = EffectDictionary()
        self.parameters = ParamDictionary(dictionary: parameters)
        
        self.effects["firstShrink"] = firstShrink
        self.effects["firstMove"] = firstMove
        self.effects["firstMoveAndShrink"] = firstMoveAndShrink
        self.effects["secondShrink"] = secondShrink
        self.effects["secondMove"] = secondMove
        self.effects["rotateFirst"] = rotateFirst
        self.effects["join"] = join
    }
    
    func performEffect(couple: Couple, withKey: String) {
        if let first = couple.firstTouched() {
            if let second = couple.secondTouched() {
                if let e = self.effects[withKey] {
                    e(first: first, second: second)
                }
                second.lock()
            }
            first.lock()
        }
    }
    
    func readOffsetParam(parameters: NSDictionary, defaultOffset: CGPoint = CGPointZero) -> CGPoint {
        var x:CGFloat = defaultOffset.x
        var y:CGFloat = defaultOffset.y
        
        if let xx = parameters.objectForKey("offset.x") as? CGFloat {
            x = xx
        }
        if let yy = parameters.objectForKey("offset.y") as? CGFloat {
            y = yy
        }

        return CGPoint(x: x, y: y)
    }
    
    func calcPositionFromSpritePositionAndOffset(sprite: SKSpriteNode, defaultOffset: CGPoint) -> CGPoint {
        var offset:CGPoint = defaultOffset
        
        if let userData = sprite.userData?.objectForKey("finalEffect.params") as? NSDictionary {
            offset = readOffsetParam(userData, defaultOffset: offset)
        }

        let position = sprite.position
        let size = sprite.size
        
        return CGPoint(x: position.x + offset.x * size.width, y: position.y + offset.y * size.height)
    }
    
    func rotateFirst(first: Couple.Item, second: Couple.Item) {
        firstMove(first, second: second)
        first.rotateBy(CGFloat(2 * M_PI))
        second.sprite.runAction(SKAction.fadeAlphaTo(0, duration: 0.2))
    }
    
    func firstShrink(first: Couple.Item, second: Couple.Item) {
        first.shrink()
    }

    func firstMoveAndShrink(first: Couple.Item, second: Couple.Item) {
        firstMove(first, second: second)

        firstShrink(first, second: second)
    }
    
    func firstMove(first: Couple.Item, second: Couple.Item) {
        let offset = readOffsetParam(parameters)
        
        first.moveTo(calcPositionFromSpritePositionAndOffset(second.sprite, defaultOffset: offset))
    }
    
    func secondMove(first: Couple.Item, second: Couple.Item) {
        firstMove(first, second: second)
        
        let offset = readOffsetParam(parameters)
        
        second.sprite.zPosition = first.sprite.zPosition + 10
        second.moveTo(calcPositionFromSpritePositionAndOffset(first.sprite, defaultOffset: offset))
    }
    
    func secondShrink(first: Couple.Item, second: Couple.Item) {
        first.moveTo(second.sprite.position)
        second.shrink()
    }
    
    func join(first: Couple.Item, second: Couple.Item) {
        let location = second.sprite.position
        
        let f = first.sprite
        let s = second.sprite
    
        let movef = SKAction.moveTo(CGPoint(x:location.x - f.size.width * 0.5 / f.xScale, y: location.y), duration: 0.2)
        let moves = SKAction.moveTo(CGPoint(x:location.x + s.size.width * 0.5 / f.xScale, y: location.y), duration: 0.2)
//        let scale = SKAction.scaleTo(0.5, duration: 0.2)
        
        let actionf = movef// SKAction.group([movef, scale])
        let actions = moves//SKAction.group([moves, scale])
        
        f.runAction(actionf)
        s.runAction(actions)
    }
}