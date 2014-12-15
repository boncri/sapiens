//
//  Shuffle.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 15/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation

extension Array {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
    
    /// Return a copy of `self` with its elements shuffled
    func shuffled() -> [T] {
        var list = self
        list.shuffle()
        return list
    }
}