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
    
    func readOffsetParam() -> CGPoint {
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        if let xx = parameters.objectForKey("offset.x") as? CGFloat {
            x = xx
        }
        if let yy = parameters.objectForKey("offset.y") as? CGFloat {
            y = yy
        }

        return CGPoint(x: x, y: y)
    }
    
    func firstShrink(first: Couple.Item, second: Couple.Item) {
        first.shrink()
    }

    func firstMoveAndShrink(first: Couple.Item, second: Couple.Item) {
        firstMove(first, second: second)

        firstShrink(first, second: second)
    }
    
    func firstMove(first: Couple.Item, second: Couple.Item) {
        let offset = readOffsetParam()
        
        first.moveTo(CGPoint(x: second.sprite.position.x + offset.x * second.sprite.size.width, y: second.sprite.position.y + offset.y * second.sprite.size.height))
    }
    
    func secondMove(first: Couple.Item, second: Couple.Item) {
        firstMove(first, second: second)
        
        let offset = readOffsetParam()
        
        second.sprite.zPosition = first.sprite.zPosition + 10
        second.moveTo(CGPoint(x: first.sprite.position.x + offset.x * first.sprite.size.width, y: first.sprite.position.y + offset.y * second.sprite.size.height))
    }
    
    func secondShrink(first: Couple.Item, second: Couple.Item) {
        first.moveTo(second.sprite.position)
        second.shrink()
        second.lock()
        first.lock()
    }
}