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
        let balloonsY : CGFloat
        let finalEffect : String
        let finalEffectParams : NSDictionary
        let touchEffect : [String:String]
        
        init(levelNumber: Int, count:Int, layout: String, mode: String, balloonsY: CGFloat, finalEffect : String, finalEffectParams: NSDictionary, touchEffect: [String:String]) {
            self.levelNumber = levelNumber
            self.count = count
            self.layout = layout
            self.mode = mode
            self.balloonsY = balloonsY
            self.finalEffect = finalEffect
            self.finalEffectParams = finalEffectParams
            self.touchEffect = touchEffect
        }
        convenience init(levelNumber: Int, levelInfo: NSDictionary) {
            let count:Int? = levelInfo.objectForKey("count") as? Int
            let layout:String? = levelInfo.objectForKey("layout") as? String
            let mode:String? = levelInfo.objectForKey("mode") as? String
            let balloonsY:CGFloat = LevelInfo.objectForKey(levelInfo, key: "balloons.y", defaultValue: 50)
            let finalEffect:String = LevelInfo.objectForKey(levelInfo, key: "finalEffect", defaultValue: "firstMoveAndShrink")
            let finalEffectParams:NSDictionary = LevelInfo.objectForKey(levelInfo, key: "finalEffect.params", defaultValue: NSDictionary())
            var touchEffect:[String:String] = LevelInfo.objectForKey(levelInfo, key: "touchEffect", defaultValue: [String:String]())
            
            if(count != nil && layout != nil && mode != nil) {
                if touchEffect.indexForKey("first") == nil {
                    touchEffect["first"] = ""
                }
                if touchEffect.indexForKey("second") == nil {
                    touchEffect["second"] = ""
                }
                
                self.init(levelNumber: levelNumber, count: count!, layout: layout!, mode: mode!, balloonsY: balloonsY, finalEffect: finalEffect, finalEffectParams: finalEffectParams, touchEffect: touchEffect)
            } else {
                fatalError("levelInfo invalid")
            }
        }
        
        class func objectForKey<T>(dictionary: NSDictionary, key: String, defaultValue: T) -> T {
            if let result = dictionary.objectForKey(key) as? T {
                return result
            }
            return defaultValue
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
        self.playGround = PlayGround(dragMode: self.level.mode == "drag", touchEffect: self.level.touchEffect)
        
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
        layerBackground.position = CGPoint(x: 0,y: -self.frame.height - 360)

                let bg = SKSpriteNode(imageNamed: "l\(level.levelNumber)bg")
                bg.position = CGPoint(x: self.frame.width/2, y:self.frame.height/2)
                bg.zPosition = -100
                layerBackground.addChild(bg)

        let balloon1 = SKSpriteNode(imageNamed: "palloncini")
        let balloon2 = SKSpriteNode(imageNamed: "palloncini")

        balloon1.anchorPoint = CGPoint(x: 0.5, y: 0)
        balloon1.position = CGPoint(x: 256, y: self.frame.height - level.balloonsY)
        balloon1.zPosition = 10
        layerBackground.addChild(balloon1)
        
        balloon2.anchorPoint = CGPoint(x: 0.5, y: 0)
        balloon2.position = CGPoint(x: 768, y: self.frame.height - level.balloonsY)
        balloon2.zPosition = 10
        layerBackground.addChild(balloon2)
        
        self.addChild(layerBackground)
        
        let layerControls = SKNode()
        layerControls.zPosition = 10
        layerControls.position = CGPoint(x:0,y:0)
        
        play.position = CGPoint(x: 40, y: self.frame.height - 30)
        play.setScale(0.6)
        layerControls.addChild(play)

        back.position = CGPoint(x: self.frame.width - 60, y: self.frame.height - 30)
        back.setScale(0.6)
        layerControls.addChild(back)

        self.addChild(layerControls)
        
        initGraphics()
        layerGame.zPosition = 100
        layerBackground.addChild(layerGame)
        
        player = AVAudioPlayer(data: wow, error: nil)
        player.prepareToPlay()
        
        playerWin = AVAudioPlayer(data: cheers, error: nil)
        playerWin.prepareToPlay()
        
        let rotate1 = SKAction.rotateByAngle(0.1, duration: 0.2)
        rotate1.timingMode = SKActionTimingMode.EaseOut
        let rotate2 = SKAction.rotateByAngle(-0.2, duration: 0.4)
        rotate2.timingMode = SKActionTimingMode.EaseInEaseOut
        let rotate3 = SKAction.rotateByAngle(0.1, duration: 0.2)
        rotate3.timingMode = SKActionTimingMode.EaseIn
        let wave = SKAction.sequence([rotate1, rotate2, rotate3])
        balloon1.runAction(SKAction.repeatActionForever(wave))
        balloon2.runAction(SKAction.repeatActionForever(wave))
        
        let moveup = SKAction.moveTo(CGPoint(x:0, y:0), duration: 2)
        moveup.timingMode = SKActionTimingMode.EaseOut
        
        let remove = SKAction.runBlock({
            balloon1.removeFromParent()
            balloon2.removeFromParent()
        })
        layerBackground.runAction(SKAction.sequence([moveup, remove]))
        
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
                        score++
                        if(score == playGround.targetScore())
                        {
                            playerWin.play()
                            couple.stop()
                        } else {
                            player.play()
                        }
                        for item in couple.touchedItems() {
                            item.sprite.alpha = 0.25
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
            couple.stop()
            
            let e = CoupleEffect(parameters: level.finalEffectParams)
            
            e.performEffect(couple, withKey: level.finalEffect)
            
            score++
            if(score == playGround.couples.count)
            {
                playerWin.play()
            } else {
                player.play()
            }
            
//            delay(2) {
//                couple.stop()
//            }
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
