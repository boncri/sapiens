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
    class LevelInfo {
        let count : Int
        let layout : String
        let mode : String
        let levelNumber: Int
        
        init(levelNumber: Int, count:Int, layout: String, mode: String) {
            self.levelNumber = levelNumber
            self.count = count
            self.layout = layout
            self.mode = mode
        }
        convenience init(levelNumber: Int, levelInfo: NSDictionary) {
            let count:Int? = levelInfo.objectForKey("count") as? Int
            let layout:String? = levelInfo.objectForKey("layout") as? String
            let mode:String? = levelInfo.objectForKey("mode") as? String
            
            if(count != nil && layout != nil && mode != nil) {
                self.init(levelNumber: levelNumber, count: count!, layout: layout!, mode: mode!)
            } else {
                fatalError("levelInfo invalid")
            }
        }
        
        class func getLevels() -> NSDictionary {
            if let levelsDic = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("levels", ofType: "plist")!) {
                if let levels = levelsDic.objectForKey("levels") as? NSDictionary {
                    return levels
                } else {
                    fatalError("Levels not found")
                }
            } else {
                fatalError("levels.plist not found")
            }
        }
        class func getLevel(level: Int) -> LevelInfo {
            let levels = getLevels()
            if let levelInfo = levels.objectForKey(String(level)) as? NSDictionary {
                return LevelInfo(levelNumber: level, levelInfo: levelInfo)
            } else {
                fatalError("LevelInfo not found for level \(level)")
            }
        }
    }
    
    private let wow = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("wow", ofType: "wav")!)
    private let cheers = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("cheer", ofType: "caf")!)
    
    private var player = AVAudioPlayer()
    private var playerWin = AVAudioPlayer()
    
    private let play = SKSpriteNode(imageNamed: "replay")
    private let back = SKSpriteNode(imageNamed: "back")
    
    private let layerGame = SKNode()

    private let playGround : PlayGround
    
    var score = 0
    
    private let level : LevelInfo;
    init(size: CGSize, level: Int) {
        self.level = LevelInfo.getLevel(level)
        self.playGround = PlayGround(dragMode: self.level.mode == "drag")
        
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 60 / 256.0, green: 180 / 256.0, blue: 240 / 256.0, alpha: 1)
        
        let layerBackground = SKNode()
        layerBackground.zPosition = -100
        layerBackground.position = CGPoint(x: 0,y: 0)

                let bg = SKSpriteNode(imageNamed: "l\(level.levelNumber)bg")
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
        var layout : BaseLayout
        
        switch(level.layout) {
            case "BirdsLayout":
                layout = BirdsLayout(size: CGSize(width: self.frame.width, height: self.frame.height - 60), topLeft: CGPoint(x: 0, y: 60))
            case "TopBottomRowLayout":
                layout = TopBottomRowLayout(size: CGSize(width: self.frame.width, height: self.frame.height - 60), topLeft: CGPoint(x: 0, y: 60))
            default:
                layout = GridLayout(size: CGSize(width: self.frame.width, height: self.frame.height - 60), topLeft: CGPoint(x: 0, y: 60))
        }
        
        let num = level.count
        
        for(var i=1; i<=num; i++)
        {
            let couple = Couple(firstImageName: "l\(level.levelNumber)c\(i)f", secondImageName: "l\(level.levelNumber)c\(i)s")
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
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let touched = self.nodeAtPoint(location) as? SKSpriteNode {
                if let couple = playGround.touched(touched, location: location) {
                    if(couple.areAllTouched())
                    {
                        for item in couple.touchedItems() {
                            item.sprite.alpha = 0.25
                        }
                        score++
                        if(score == playGround.targetScore())
                        {
                            playerWin.play()
                            couple.stop()
                        } else {
                            player.play()
                        }
                        delay(1) {
                            couple.stop()
                        }
                        
                    }
                } else {
                    if(touched == play)
                    {
                        layerGame.removeAllChildren()
                        playGround.couples.removeAll(keepCapacity: true)
                        self.score = 0
                        self.initGraphics()
                    } else if (touched == back)
                    {
                        let main = MainMenuScene(size: self.frame.size)
                        self.view?.presentScene(main, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1))
                    }
                    return
                }
            }
        }
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if let couple = playGround.cancelTouch() {
            if let item = couple.firstTouched() {

                // First effect (Birds)
//                item.shrink()
                
                // Second effect (eating)
                if let second = couple.secondTouched() {
                    item.moveTo(second.sprite.position)
                    second.shrink()
                    second.lock()
                }
                item.lock()
                
                score++
                if(score == playGround.couples.count)
                {
                    playerWin.play()
                } else {
                    player.play()
                }
                
                delay(2) {
                    couple.stop()
                }
            }
        }
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if level.mode != "drag" {
            return
        }
        
        if let touch: AnyObject = touches.anyObject() {
            let location = touch.locationInNode(self)
            
            playGround.drag(location)
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
