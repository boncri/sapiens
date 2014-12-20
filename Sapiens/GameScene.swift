//
//  GameScene.swift
//  Sapiens
//
//  Created by Cristiano Boncompagni on 14/12/14.
//  Copyright (c) 2014 Cristiano Boncompagni. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, AVAudioPlayerDelegate {
    private let wow = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("wow", ofType: "wav")!)
    private let cheers = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("cheer", ofType: "caf")!)
    
    private var player = AVAudioPlayer()
    private var playerWin = AVAudioPlayer()
    
    private let play = SKSpriteNode(imageNamed: "replay")
    private let back = SKSpriteNode(imageNamed: "back")
    
    private let layerGame = SKNode()

    private var playGround = PlayGround()
    
    var score = 0
    
    private let level : Int;
    init(size: CGSize, level: Int) {
        self.level = level

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.whiteColor()
        
        let layerBackground = SKNode()
        layerBackground.zPosition = -100
        layerBackground.position = CGPoint(x: 0,y: 0)

                let bg = SKSpriteNode(imageNamed: "l\(level)bg")
                bg.position = CGPoint(x: self.frame.width/2, y:self.frame.height/2)
                bg.zPosition = -100
                layerBackground.addChild(bg)

        self.addChild(layerBackground)
        
        let layerControls = SKNode()
        layerControls.zPosition = 10
        layerControls.position = CGPoint(x:0,y:0)
        
        play.position = CGPoint(x: 60, y: self.frame.height - 60)
        layerControls.addChild(play)

        back.position = CGPoint(x: self.frame.width - 60, y: self.frame.height - 60)
        layerControls.addChild(back)

        self.addChild(layerControls)
        
        initGraphics()
        self.addChild(layerGame)
        
        player = AVAudioPlayer(data: wow, error: nil)
        player.prepareToPlay()
        
        playerWin = AVAudioPlayer(data: cheers, error: nil)
        playerWin.prepareToPlay()
    }
    
    private func initGraphics()
    {
        let layout : BaseLayout = (level==1 || level==4) ? GridLayout(size: CGSize(width: self.frame.width, height: self.frame.height - 60), topLeft: CGPoint(x: 0, y: 60)) : TopbottomRowLayout(size: CGSize(width: self.frame.width, height: self.frame.height - 60), topLeft: CGPoint(x: 0, y: 60))
        
        let num = (level==1 || level==4) ? 6 : 4
        
        for(var i=1; i<=num; i++)
        {
            let couple = Couple(firstImageName: "l\(level)c\(i)f", secondImageName: "l\(level)c\(i)s")
            //let couple = Couple(firstImageName: "first", secondImageName: "second")
            
            playGround.add(couple)
        }
        
        layout.placeAll(playGround.couples, scene: layerGame)
    }
    
//    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let touched : SKSpriteNode? = self.nodeAtPoint(location) as? SKSpriteNode
//            
//            if((touched?) != nil)
//            {
//             let couple = playGround.untouched(touched!)
//            }
//        }
//    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let touched : SKSpriteNode? = self.nodeAtPoint(location) as? SKSpriteNode
            
            if ((touched?) != nil) {
                let couple = playGround.touched(touched!)
                if((couple?) == nil)
                {
                    if(touched! == play)
                    {
                        layerGame.removeAllChildren()
                        playGround.couples.removeAll(keepCapacity: true)
                        self.score = 0
                        self.initGraphics()
                    } else if (touched! == back)
                    {
                        let main = MainMenuScene(size: self.frame.size)
                        self.view?.presentScene(main, transition: SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 1))
                    }
                    return
                }
                
                if(couple!.allTouched())
                {
                    couple!.first.alpha = 0.25
                    couple!.second.alpha = 0.25
                    score++
                    if(score == playGround.couples.count)
                    {
                        playerWin.play()
                    } else {
                        player.play()
                    }
                
                    delay(2) {
                        couple!.stop()
                    }
                }
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
