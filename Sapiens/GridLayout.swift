//
//  GridLayout.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 15/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class GridLayout : ColumnLayout
{
    override func placeAll(couples: [Couple], scene: SKNode)
    {
        let count = couples.count * 2
        
        let rows = count / columns
        
        let width = Int(size.width) / columns
        let height = Int(size.height) / rows
        
        var occupied = [Bool](count: rows * columns, repeatedValue: false)
        
        var cells : UInt32 = UInt32(rows * columns)
        var r1 : Int
        var r2 : Int
        for couple in couples
        {
            do {
                r1 = Int(arc4random_uniform(cells))
            }while(occupied[r1] == true)
            occupied[r1] = true
            
            do {
                r2 = Int(arc4random_uniform(cells))
            }while(occupied[r2] == true)
            occupied[r2] = true
            
            var x0 = width / 2 + (r1 % columns) * width
            var y0 = height / 2 + (r1 / columns) * height
            var x1 = width / 2 + (r2 % columns) * width
            var y1 = height / 2 + (r2 / columns) * height
            
            println("(\(x0),\(y0)) - (\(x1),\(y1))")
            
            let f = couple.first[0].sprite
            let s = couple.second.sprite

            f.position = CGPoint(x: x0, y: y0)
            s.position = CGPoint(x: x1, y: y1)
            
            f.zPosition = 2
            s.zPosition = 1

            placeNode(scene, node: f)
            placeNode(scene, node: s)
        }
    }
}