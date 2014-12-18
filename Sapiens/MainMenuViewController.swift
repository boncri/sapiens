//
//  MainMenuViewController.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 18/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MainMenuViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
        let scene = GameScene(size: self.view.frame.size, level: 1)
        // Configure the view.
        let skView = self.view as SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        //        }
    }

}