//
//  ColumnLayout.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 19/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class ColumnLayout : BaseLayout {
    let columns:Int
    
    init(size: CGSize, topLeft: CGPoint, options: NSDictionary, columns:Int = 4) {
        self.columns = columns
        super.init(size: size, topLeft: topLeft, options: options)
    }
}