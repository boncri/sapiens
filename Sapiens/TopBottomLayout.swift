//
//  RowLayout.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 19/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class TopBottomRowLayout : BaseLayout {
    private let rows:Int = 2
    
    override func placeAll(couples: [Couple], scene: SKNode) {
        let columns = couples.count
        
        let width = Int(size.width) / columns
        let height = Int(size.height) / rows
        
        var occupiedTop = [Bool](count: columns, repeatedValue: false)
        var occupiedBottom = [Bool](count: columns, repeatedValue: false)
        
        var r1 : Int
        var r2 : Int
        for couple in couples
        {
            do {
                r1 = Int(arc4random_uniform(UInt32(columns)))
            }while(occupiedTop[r1] == true)
            occupiedTop[r1] = true
            
            do {
                r2 = Int(arc4random_uniform(UInt32(columns)))
            }while(occupiedBottom[r2] == true)
            occupiedBottom[r2] = true
            
            var x0 = width / 2 + r1 * width
            var y0 = 3 * height / 2
            var x1 = width / 2 + r2 * width
            var y1 = height / 2
            
            println("(\(x0),\(y0)) - (\(x1),\(y1))")
            
            couple.first.position = CGPoint(x: x0, y: y0)
            couple.second.position = CGPoint(x: x1, y: y1)
            
            scene.addChild(couple.first)
            scene.addChild(couple.second)
        }
    }
}