//
//  BirdsLayout.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 21/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class BirdsLayout : BaseLayout {
    let positions = [
        [218, 768 - 196],
        [517, 768 - 167],
        [516, 768 - 447],
        [866, 768 - 447]
    ]
    let yBase : CGFloat = 100
    
    override func placeAll(couples: [Couple], scene: SKNode) {
        let n = positions.count
        
        var width : CGFloat = size.width / CGFloat(n)
        
        var occupied = [Bool](count: n, repeatedValue: false)
        var occupied2 = [Bool](count: n, repeatedValue: false)
        
        var r1 : Int
        var r2 : Int
        for couple in couples {
            do {
                r1 = Int(arc4random_uniform(UInt32(n)))
            } while(occupied2[r1] == true)
            occupied2[r1] = true
            
            couple.second.sprite.anchorPoint = CGPoint(x: 0.5, y: 1)
            couple.second.sprite.position = CGPoint(x: positions[r1][0], y: positions[r1][1])
         
            do {
                r2 = Int(arc4random_uniform(UInt32(n)))
            } while(occupied[r2] == true)
            occupied[r2] = true
            
            var x = width / 2 + (width * CGFloat(r2))
            
            println("(\(x), \(yBase))")
            
            couple.first[0].sprite.position = CGPoint(x: x, y: yBase)
            
            couple.first[0].sprite.zPosition = 2
            couple.second.sprite.zPosition = 1
            
            scene.addChild(couple.first[0].sprite)
            scene.addChild(couple.second.sprite)
        }
    }
}