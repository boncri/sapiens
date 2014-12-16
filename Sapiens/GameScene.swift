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
    
    private let play = SKSpriteNode(imageNamed: "play")

    private var playGround = PlayGround()
    
    var score = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        initGraphics()
        
        player = AVAudioPlayer(data: wow, error: nil)
        player.prepareToPlay()
        
        playerWin = AVAudioPlayer(data: cheers, error: nil)
        playerWin.prepareToPlay()
    }
    
    private func initGraphics()
    {
        let bg = SKSpriteNode(imageNamed: "back_img")
        bg.position = CGPoint(x: self.frame.width/2, y:self.frame.height/2)
        bg.zPosition = -100
        bg.alpha = 0.5
        self.addChild(bg)
        
        let layout = GridLayout(size: self.frame.size)
        
        for(var i=1; i<=3; i++)
        {
            let couple = Couple(firstImageName: "c\(i)f", secondImageName: "c\(i)s")
            //let couple = Couple(firstImageName: "first", secondImageName: "second")
            
            playGround.add(couple)
        }
        
        layout.placeAll(playGround.couples, scene: self)
        
        play.position = CGPoint(x: 60, y: self.frame.height - 60)
        self.addChild(play)
    }
    
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
                        self.removeAllChildren()
                        playGround.couples.removeAll(keepCapacity: true)
                        self.initGraphics()
                        self.score = 0
                    }
                    return
                }
                
                if(couple!.allTouched())
                {
                    drawLine(couple!)
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
            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)            
        }
    }
    
    func drawLine(couple:Couple)
    {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, couple.first.position.x, couple.first.position.y)
        CGPathAddLineToPoint(path, nil, couple.second.position.x, couple.second.position.y)
        
        
        
        let line = SKShapeNode(path: CGPathCreateCopyByDashingPath(path, nil, 0, [10, 10], 2))
        line.strokeColor = UIColor.yellowColor()
        line.lineWidth = 8
        
        line.zPosition = -1
        
        self.addChild(line)
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
