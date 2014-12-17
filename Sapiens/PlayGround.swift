//
//  PlayGround.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 14/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class PlayGround
{
    var couples:[Couple] = []
    private var numTouches:Int = 0
    
    func add(couple:Couple) {
        couples.append(couple)
    }
    
    private func touchCouple(node:SKSpriteNode) -> Couple? {
        var selected:Couple?
        
        for couple in couples {
            if(couple.touched(node) != nil)
            {
                selected = couple
                break
            }
        }
        
        return selected?
    }
    private func untouchCouple(node:SKSpriteNode) -> Couple? {
        var selected:Couple?
        
        for couple in couples {
            if(couple.untouched(node) != nil)
            {
                selected = couple
                break
            }
        }
        
        return selected?
    }
    
    func touched(node:SKSpriteNode) -> Couple? {
        var selected:Couple? = touchCouple(node)
        
        if((selected?)==nil) {
            return nil
        }
        
        numTouches++
        if(numTouches == 2)
        {
            numTouches = 0
            if(selected?.allTouched() == true)
            {
                return selected
            } else {
                for couple in couples
                {
                    couple.reset()
                }
            }
        }
        
        return nil
    }
    
    func untouched(node:SKSpriteNode) -> Couple? {
        var selected:Couple? = untouchCouple(node)
        
        if((selected?)==nil) {
            return nil
        }
        
        numTouches--
        selected!.reset()
        
        return selected
    }
}