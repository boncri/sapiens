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
        
        for(var i=1; i<=6; i++)
        {
            let couple = Couple(firstImageName: "c\(i)f", secondImageName: "c\(i)s")
            //let couple = Couple(firstImageName: "first", secondImageName: "second")
            
            playGround.add(couple)
        }
        
        layout.placeAll(playGround.couples, scene: self)
        
        play.position = CGPoint(x: 60, y: self.frame.height - 60)
        self.addChild(play)
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
                        self.removeAllChildren()
                        playGround.couples.removeAll(keepCapacity: true)
                        self.initGraphics()
                        self.score = 0
                    }
                    return
                }
                
                if(couple!.allTouched())
                {
//                    drawLine(couple!)
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
    
    func drawLine(couple:Couple)
    {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, couple.first.position.x, couple.first.position.y)
        
        let cp = RandomPoint(couple.first.position, corner2: couple.second.position)
        CGPathAddQuadCurveToPoint(path, nil,  cp.x,cp.y, couple.second.position.x, couple.second.position.y)
        
        let line = SKShapeNode(path: CGPathCreateCopyByDashingPath(path, nil, 0, [8, 8], 2))

        line.strokeColor = UIColor.yellowColor().colorWithAlphaComponent(0.25)
        line.lineWidth = 8

        line.zPosition = -1
        self.addChild(line)
    }
    
    private func MidPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x)/2, y: (p1.y + p2.y)/2)
    }
    private func RandomPoint() -> CGPoint {
        return CGPoint(x: Double(arc4random_uniform(UInt32(self.frame.width))), y: Double(arc4random_uniform(UInt32(self.frame.height))))
    }
    private func RandomPoint(corner1: CGPoint, corner2: CGPoint) -> CGPoint {
        let xFrom = UInt32(min(corner1.x, corner2.x))
        let xTo = UInt32(max(corner1.x, corner2.x))
        let x = Double(arc4random_uniform(xTo - xFrom) + xFrom)

        let yFrom = UInt32(min(corner1.y, corner2.y))
        let yTo = UInt32(max(corner1.y, corner2.y))
        let y = Double(arc4random_uniform(yTo - yFrom) + yFrom)

        return CGPoint(x: x, y: y)
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
