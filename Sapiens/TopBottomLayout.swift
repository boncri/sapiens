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
        
        let r1Random = self.options.objectForKey("random.1", defaultValue: true)
        let r2Random = self.options.objectForKey("random.2", defaultValue: true)
        
        var r1 : Int = -1
        var r2 : Int = -1
        for couple in couples
        {
            do {
                r1 = r1Random ? Int(arc4random_uniform(UInt32(columns))) : r1 + 1
            }while(occupiedTop[r1] == true)
            occupiedTop[r1] = true
            
            do {
                r2 = r2Random ? Int(arc4random_uniform(UInt32(columns))) : r2 + 1
            }while(occupiedBottom[r2] == true)
            occupiedBottom[r2] = true
            
            var x0 = width / 2 + r1 * width
            var y0 = 3 * height / 2
            var x1 = width / 2 + r2 * width
            var y1 = height / 2
            
            println("(\(x0),\(y0)) - (\(x1),\(y1))")
            
            let f = couple.first[0].sprite
            let s = couple.second.sprite
            
            f.position = CGPoint(x: x0, y: y0)
            s.position = CGPoint(x: x1, y: y1)
            
            f.zPosition = 2
            s.zPosition = 1

            scene.addChild(f)
            scene.addChild(s)
        }
    }
}