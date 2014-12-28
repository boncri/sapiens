//
//  NSDictionary.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 28/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation

extension NSDictionary {
    func objectForKey<T>(key: String, defaultValue: T) -> T {
        if let result = self.objectForKey(key) as? T {
            return result
        }
        return defaultValue
    }
}