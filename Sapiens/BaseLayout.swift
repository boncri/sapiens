//
//  LayoutBase.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 19/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class BaseLayout {
    let size:CGSize
    let topLeft:CGPoint
    
    init(size: CGSize, topLeft: CGPoint) {
        self.size = size
        self.topLeft = topLeft
    }
    
    func placeAll(couples: [Couple], scene: SKNode) {
        fatalError("Must be overridden")
    }
}