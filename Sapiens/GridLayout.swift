//
//  GridLayout.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 15/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class GridLayout
{
    private var size:CGSize
    
    private let columns = 2
    
    init(size: CGSize)
    {
        self.size = size
    }
    
    func placeAll(couples: [Couple], scene: SKScene)
    {
        let count = couples.count * 2
        
        let rows = count / 2
        
        let width = Int(size.width) / columns
        let height = Int(size.height) / rows
        
        var occupied = [Bool](count: rows * columns, repeatedValue: false)

        var r1 : Int
        var r2 : Int
        
        for couple in couples
        {
            
            do {
                r1 = Int(arc4random() % UInt32(rows))
            }while(occupied[r1] == true)
            occupied[r1] = true
            
            do {
                r2 = Int(arc4random() % UInt32(rows))
            }while(occupied[r2 + rows] == true)
            occupied[r2 + rows] = true
            
            var x0 = width / 2
            var x1 = width / 2 + width
            var y0 = height / 2 + height * r1
            var y1 = height / 2 + height * r2
            
            println("(\(x0),\(y0)) - (\(x1),\(y1))")
            
            couple.first.position = CGPoint(x: x0, y: height/2 + height * r1)
            couple.second.position = CGPoint(x: x1, y: height/2 + height * r2)
            
            scene.addChild(couple.first)
            scene.addChild(couple.second)
        }
    }
}