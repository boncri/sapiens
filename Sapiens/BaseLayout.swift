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
    let options:NSDictionary
    
    init(size: CGSize, topLeft: CGPoint, options: NSDictionary) {
        self.size = size
        self.topLeft = topLeft
        self.options = options
    }
    
    func placeAll(couples: [Couple], scene: SKNode) {
        fatalError("Must be overridden")
    }    
}