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
    
    func touched(node:SKSpriteNode) -> Couple? {
        var selected:Couple?
        
        for couple in couples {
            if(couple.touched(node) != nil)
            {
                selected = couple
                break
            }
        }
        
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
                    couple.stop()
                }
            }
        }
        
        return nil
    }    
}