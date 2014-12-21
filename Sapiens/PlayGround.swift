//
//  PlayGround.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 14/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import SpriteKit

class PlayGround
{
    let dragMode:Bool
    var couples:[Couple] = []
    private var numTouches:Int = 0

    var draggedCouple:Couple?
    var dragged:SKSpriteNode?
    var draggedOffset:CGPoint = CGPointZero
    
    init(dragMode: Bool) {
        self.dragMode = dragMode
    }
    
    func add(couple:Couple) {
        couples.append(couple)
    }
    
    private func touchCouple(node:SKSpriteNode, location: CGPoint) -> Couple? {
        var selected:Couple?
        
        for couple in couples {
            if let node = couple.touched(node, onlyFirst: dragMode)
            {
                selected = couple
                dragged = node
                draggedCouple = couple
                draggedOffset = CGPoint(x: dragged!.position.x - location.x, y: dragged!.position.y - location.y)
                break
            }
        }
        
        return selected?
    }
    private func untouchCouple(node:SKSpriteNode) -> Couple? {
        var selected:Couple?
        
        for couple in couples {
            if(couple.untouched(node) != nil)
            {
                selected = couple
                break
            }
        }
        
        return selected?
    }
    
    func touched(node:SKSpriteNode, location: CGPoint) -> Couple? {
        if let selected = touchCouple(node, location: location) {
            numTouches++
            if(numTouches == 2)
            {
                numTouches = 0
                if(selected.allTouched() == true)
                {
                    return selected
                } else {
                    for couple in couples
                    {
                        couple.reset()
                    }
                }
            }
        }
        return nil
    }
    
    func untouched(node:SKSpriteNode) -> Couple? {
        var selected:Couple? = untouchCouple(node)

        if let couple = untouchCouple(node) {
            if !couple.allTouched() {
                numTouches--
                selected!.reset()
                return couple
            }
        }
        
        return nil
    }
    
    func cancelTouch() -> Couple? {
        if !dragMode {
            return nil
        }
        
        if let couple = draggedCouple {
            let win = couple.allTouched()

            numTouches = 0
            draggedCouple = nil
            dragged = nil
            draggedOffset = CGPointZero
            
            if(win) {
                return couple
            } else {
                couple.reset()
            }
        }
        return nil
    }
    
    func drag(location: CGPoint) {
        if !dragMode {
            return
        }
        
        if let node = dragged {
            node.position = CGPoint(x: location.x + draggedOffset.x, y: location.y + draggedOffset.y)
            if let couple = draggedCouple {
                if(contact(node, second: couple.second)) {
                    couple.touch(couple.second)
                } else {
                    couple.untouched(couple.second)
                }
            }
        }
    }
    
    func contact(first: SKSpriteNode, second: SKSpriteNode) -> Bool {
        let firstCenter = positionOfCenter(first)
        let secondCenter = positionOfCenter(second)
        
        let dist = CGPoint(x: abs(firstCenter.x - secondCenter.x), y: abs(firstCenter.y - secondCenter.y))
        
        let w = (first.size.width + second.size.width) / 2
        let h = (first.size.height + second.size.height) / 2
        
        return dist.x < w && dist.y < h
    }
    
    func positionOfCenter(node: SKSpriteNode) -> CGPoint {
        return CGPoint(x: node.position.x + node.size.width * (0.5 - node.anchorPoint.x),
            y: node.position.y + node.size.height * (0.5 - node.anchorPoint.y))
    }
}