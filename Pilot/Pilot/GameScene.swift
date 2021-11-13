//
//  GameScene.swift
//  Pilot
//
//  Created by Joshua Zhou on 3/5/19.
//  Copyright © 2019 Shuyu Zhou. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    let flowerSound = SKAction.playSoundFileNamed("FlowerSound.mp3", waitForCompletion: false)
    
    var isGameStarted: Bool = false
    var isDied: Bool = false
    
    let playerAtlas = SKTextureAtlas(named: "player")
    var playerAnimateArray = Array<Any>()
    var player = SKSpriteNode()
    var playerActionRepeat = SKAction()
    
    var openingLabel = SKLabelNode()
    var mediumLabel = SKLabelNode()
    var easyLabel = SKLabelNode()
    var hardLabel = SKLabelNode()
    var currentGameType = gameType.medium
    
    var pace: CGFloat = 2
    
    var pillarPair = SKNode()
    var pillarMoveRemove = SKAction()
    
    let coinAtlas = SKTextureAtlas(named: "coin")
    let flowerAtlas = SKTextureAtlas(named: "flower")
    
    var batteryLeft = 15
    var battery = SKSpriteNode()
    let batteryAtlas = SKTextureAtlas(named: "battery")
    
    
    // line collision
    var lines: [Line] = []
    var lastTouch: CGPoint?
    var touchLocation: CGPoint!
    var linePhysics: CGPoint?
    var lastPoint: CGPoint?
    var pathArray = [CGPoint]()
    
    var restartButton = SKSpriteNode()
    
    var currentScore: Int = 0
    var scoreLabel = SKLabelNode()
    
    let easyHighestScore = "easyHighestScore"
    let mediumHighestScore = "mediumHighestScore"
    let hardHighestScore = "hardHighestScore"
    
    
    
    override func didMove(to view: SKView) {
        createScene()
        
    }
    

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameStarted {
            
            if let t = touches.first {
                let modeSelected = t.location(in: self)
                if mediumLabel.contains(modeSelected) {
                    currentGameType = .medium
                    initialSetUp()
                } else if easyLabel.contains(modeSelected) {
                    currentGameType = .easy
                    initialSetUp()
                } else if hardLabel.contains(modeSelected) {
                    currentGameType = .hard
                    initialSetUp()
                }
                
                
            }
            
            
        } else {
            if !isDied {
                lines.removeAll()
                pathArray.removeAll()
                if let firstTouch = touches.first {
                    lastTouch = firstTouch.location(in: self)
                    lastPoint = firstTouch.location(in: self)
                }
                
                if currentGameType == .hard {
                    batteryLeft -= 1
                    if batteryLeft > 5 && batteryLeft <= 10 {
                        battery.texture = batteryAtlas.textureNamed("batteryHalf")
                    } else if batteryLeft > 1 && batteryLeft <= 5 {
                        battery.texture = batteryAtlas.textureNamed("batteryUrgent")
                    } else if batteryLeft > 0 && batteryLeft <= 1 {
                        battery.texture = batteryAtlas.textureNamed("batteryEmpty")
                    }
                        
                
                }
                
            }
            
        }
        
        for t in touches {
            let location = t.location(in: self)
            if isDied {
                if restartButton.contains(location) {                    
                    restartScene()
                }
            }
        }
    }
    
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isGameStarted {
            if !isDied {
                if let firstTouch = touches.first {
                    touchLocation = firstTouch.location(in: self)
                    lines.append(Line(start: lastTouch!, end: touchLocation))
                    lastTouch = touchLocation
                    pathArray.append(lastPoint!)
                    lastPoint = touchLocation
                }
                
                let path = CGMutablePath()
                for line in lines {
                    path.move(to: CGPoint(x: line.start.x, y: line.start.y))
                    path.addLine(to: CGPoint(x: line.end.x, y: line.end.y))
                }
                
                let shape = SKShapeNode(points: &pathArray, count: pathArray.count)
                shape.strokeColor = UIColor.red
                shape.lineWidth = 1
                shape.fillColor = .clear
                shape.lineCap = .round
                shape.glowWidth = 5
                shape.zPosition = 6
                
                self.addChild(shape)
                
                shape.physicsBody = SKPhysicsBody(edgeChainFrom: shape.path!)
                shape.physicsBody?.isDynamic = false
                shape.physicsBody?.affectedByGravity = false
                shape.physicsBody?.friction = 0
                shape.physicsBody?.restitution = 1
                shape.physicsBody?.linearDamping = 0
                shape.physicsBody?.categoryBitMask = CollisionBitMask.lineType
                shape.physicsBody?.collisionBitMask = CollisionBitMask.playerType
                shape.physicsBody?.contactTestBitMask = CollisionBitMask.playerType
                
                let fade = SKAction.fadeOut(withDuration: 0.6)
                fade.timingMode = .easeIn
                let remove = SKAction.removeFromParent()
                shape.run(SKAction.sequence([fade, remove]))
            }
        }

    }
    

    
    override func update(_ currentTime: TimeInterval) {
        if isGameStarted {
            if !isDied {
                enumerateChildNodes(withName: "background", using: ({ (node, error) in
                    let background = node as! SKSpriteNode
                    background.position = CGPoint(x: background.position.x - self.pace, y: background.position.y)
                    if background.position.x <= -background.size.width {
                        background.position = CGPoint(x: background.position.x + 2 * background.size.width, y: background.position.y)
                    }
                    
                }))
            }
        }
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == CollisionBitMask.coinType && bodyB.categoryBitMask == CollisionBitMask.playerType {
            self.run(coinSound)
            currentScore += 1
            scoreLabel.text = "\(currentScore)"
            
            bodyA.node?.removeFromParent()
        } else if bodyA.categoryBitMask == CollisionBitMask.playerType && bodyB.categoryBitMask == CollisionBitMask.coinType {
            self.run(coinSound)
            
            currentScore += 1
            scoreLabel.text = "\(currentScore)"
            
            bodyB.node?.removeFromParent()
        } else if bodyA.categoryBitMask == CollisionBitMask.flowerType && bodyB.categoryBitMask == CollisionBitMask.playerType {
            self.run(flowerSound)
            
            // recharge battery
            batteryLeft = 15
            battery.texture = batteryAtlas.textureNamed("batteryFull")
            
            // recharge momentum
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 80))
            
            bodyA.node?.removeFromParent()
        } else if bodyA.categoryBitMask == CollisionBitMask.playerType && bodyB.categoryBitMask == CollisionBitMask.flowerType {
            self.run(flowerSound)
            
            // recharge battery
            batteryLeft = 15
            battery.texture = batteryAtlas.textureNamed("batteryFull")
            
            // recharge momentum
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 80))
            
            bodyB.node?.removeFromParent()
        } else if bodyA.categoryBitMask == CollisionBitMask.playerType && bodyB.categoryBitMask == CollisionBitMask.pillarType || bodyA.categoryBitMask == CollisionBitMask.pillarType && bodyB.categoryBitMask == CollisionBitMask.playerType {

            enumerateChildNodes(withName: "pillarPair", using: ({ (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))

            if !isDied {
                isDied = true
                self.player.removeAllActions()
                updateScore()
                
                createRestartButton()
                
                createLeaderboard()
            }
        } else if bodyA.categoryBitMask == CollisionBitMask.playerType && bodyB.categoryBitMask == CollisionBitMask.lineType || bodyA.categoryBitMask == CollisionBitMask.lineType && bodyB.categoryBitMask == CollisionBitMask.playerType {
            if batteryLeft <= 0 {
                enumerateChildNodes(withName: "pillarPair", using: ({ (node, error) in
                    node.speed = 0
                    self.removeAllActions()
                }))
                if !isDied {
                    isDied = true
                    self.player.removeAllActions()
                    updateScore()
                    
                    createRestartButton()
                    
                    createLeaderboard()
                }
            }
        }
        
        
        
        
        
    }
    
    func initialSetUp() {
        isGameStarted = true
        
        player.physicsBody?.affectedByGravity = true
        
        lines.removeAll()
        pathArray.removeAll()
        openingLabel.removeFromParent()
        

        switch currentGameType {
        case .easy:
            easyLabel.run(SKAction.fadeOut(withDuration: 0.3), completion: {
                self.easyLabel.removeFromParent()
            })
            mediumLabel.removeFromParent()
            hardLabel.removeFromParent()
            break
        case .medium:
            mediumLabel.run(SKAction.fadeOut(withDuration: 0.3), completion: {
                self.mediumLabel.removeFromParent()
            })
            easyLabel.removeFromParent()
            hardLabel.removeFromParent()
            break
        case .hard:
            hardLabel.run(SKAction.fadeOut(withDuration: 0.3), completion: {
                self.hardLabel.removeFromParent()
            })
            easyLabel.removeFromParent()
            mediumLabel.removeFromParent()
            break
        }
        
        
        // add battery image
        battery = createBattery()
        self.addChild(battery)
        
        // Add score label
        scoreLabel = createScoreLabel()
        self.addChild(scoreLabel)
        
        player.run(playerActionRepeat)
        
        setUpPillars()
        
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 70))
    }
    
    
    
    func createScene() {
        
        // Set up physical property of the scene
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundType
        self.physicsBody?.collisionBitMask = CollisionBitMask.playerType
        self.physicsBody?.contactTestBitMask = CollisionBitMask.playerType
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        self.physicsWorld.contactDelegate = self
        
        
        // Add background to the scene
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "background")
            background.name = "background"
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
            
        }
        
        // Add player to the scene
        for j in 0..<4 {
            playerAnimateArray.append(playerAtlas.textureNamed("rowlet\(j+1)"))
        }
        
        self.player = createPlayer()
        self.addChild(self.player)
        let animatePlayer = SKAction.animate(with: self.playerAnimateArray as! [SKTexture], timePerFrame: 0.1)
        self.playerActionRepeat = SKAction.repeatForever(animatePlayer)
        
        
        // Add Opening Label to the scene
        createOpeningLabel()
        
        
        // Add level label
        mediumLabel = createMediumLabel()
        self.addChild(mediumLabel)
        
        easyLabel = createEasyLabel()
        self.addChild(easyLabel)
        
        hardLabel = createHardLabel()
        self.addChild(hardLabel)
        
        
        
    }
    
    
    func setUpPillars() {
        
        let generator = SKAction.run({
            () in
            self.pillarPair = self.createPillars()
            self.addChild(self.pillarPair)
        })
        
        let sleep = SKAction.wait(forDuration: 2)
        let generateSleep = SKAction.sequence([generator, sleep])
        let generateSleepRepeat = SKAction.repeatForever(generateSleep)
        self.run(generateSleepRepeat)
        
        let distance = CGFloat(self.frame.width + pillarPair.frame.width)
        let movePillars = SKAction.moveBy(x: -distance - 100, y: 0, duration: TimeInterval(0.01 * distance))
        let removePillars = SKAction.removeFromParent()
        pillarMoveRemove = SKAction.sequence([movePillars, removePillars])
    
    }
    
    func restartScene() {
        
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        batteryLeft = 15
        currentScore = 0
        lines.removeAll()
        pathArray.removeAll()
        createScene()
    }
    
    
    func updateScore() {
        switch currentGameType {
        case .easy:
            if UserDefaults.standard.object(forKey: easyHighestScore) != nil {
                if currentScore > UserDefaults.standard.integer(forKey: easyHighestScore) {
                    UserDefaults.standard.set(currentScore, forKey: easyHighestScore)
                }
            } else {
                UserDefaults.standard.set(currentScore, forKey: easyHighestScore)
            }
            break
        case .medium:
            if UserDefaults.standard.object(forKey: mediumHighestScore) != nil {
                if currentScore > UserDefaults.standard.integer(forKey: mediumHighestScore) {
                    UserDefaults.standard.set(currentScore, forKey: mediumHighestScore)
                }
            } else {
                UserDefaults.standard.set(currentScore, forKey: mediumHighestScore)
            }
            break
        case .hard:
            if UserDefaults.standard.object(forKey: hardHighestScore) != nil {
                if currentScore > UserDefaults.standard.integer(forKey: hardHighestScore) {
                    UserDefaults.standard.set(currentScore, forKey: hardHighestScore)
                }
            } else {
                UserDefaults.standard.set(currentScore, forKey: hardHighestScore)
            }
            break
        }
    }
    
    
}


class Line {
    var start: CGPoint
    var end: CGPoint
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
}
