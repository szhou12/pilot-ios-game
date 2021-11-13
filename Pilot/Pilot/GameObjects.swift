//
//  GameObjects.swift
//  Pilot
//
//  Created by Joshua Zhou on 3/8/19.
//  Copyright © 2019 Shuyu Zhou. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let playerType: UInt32 = 0x1 << 0
    static let pillarType: UInt32 = 0x1 << 1
    static let groundType: UInt32 = 0x1 << 2
    static let flowerType: UInt32 = 0x1 << 3
    static let coinType: UInt32 = 0x1 << 4
    static let lineType: UInt32 = 0x1 << 5

}

enum gameType {
    case easy
    case medium
    case hard
}

extension GameScene {
    
    func createPlayer() -> SKSpriteNode {
        let player = SKSpriteNode(texture: SKTextureAtlas(named: "player").textureNamed("rowlet1"))
        player.size = CGSize(width: 55, height: 50)
        player.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.linearDamping = 0.9
        player.physicsBody?.restitution = 0
        
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.categoryBitMask = CollisionBitMask.playerType
        player.physicsBody?.collisionBitMask = CollisionBitMask.groundType | CollisionBitMask.pillarType | CollisionBitMask.lineType
        player.physicsBody?.contactTestBitMask = CollisionBitMask.groundType | CollisionBitMask.pillarType | CollisionBitMask.coinType | CollisionBitMask.flowerType | CollisionBitMask.lineType
        
        return player
    }
    
    
    func createOpeningLabel() {
        openingLabel.text = "Select a mode to play"
        openingLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100 )
        openingLabel.fontSize = 20
        openingLabel.zPosition = 5
        openingLabel.fontColor = UIColor.darkGray
        openingLabel.fontName = "Helvetica-Bold"
        self.addChild(openingLabel)
        
    }
    
    func createMediumLabel() -> SKLabelNode {
        
        let mediumLabel = SKLabelNode()
        mediumLabel.text = "Medium"
        mediumLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
        mediumLabel.fontSize = 20
        mediumLabel.zPosition = 5
        mediumLabel.fontName = "HelveticaNeue-Bold"
        
        let mediumBackground = SKShapeNode()
        mediumBackground.position = CGPoint(x: 0, y: 0)
        mediumBackground.path = UIBezierPath(roundedRect: CGRect(x:CGFloat(-60), y: CGFloat(-16), width: CGFloat(mediumLabel.frame.size.width + 40), height: CGFloat(mediumLabel.frame.size.height + 30)), cornerRadius: 30).cgPath
        
        mediumBackground.strokeColor = UIColor.clear
        mediumBackground.fillColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.2))
        mediumBackground.zPosition = -1
        mediumLabel.addChild(mediumBackground)
        
        return mediumLabel
        
        
    }
    
    func createEasyLabel() -> SKLabelNode {
        
        let easyLabel = SKLabelNode()
        easyLabel.text = "Easy"
        easyLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        easyLabel.fontSize = 20
        easyLabel.zPosition = 5
        easyLabel.fontName = "HelveticaNeue-Bold"
        
        let easyBackground = SKShapeNode()
        easyBackground.position = CGPoint(x: 0, y: 0)
        easyBackground.path = UIBezierPath(roundedRect: CGRect(x:CGFloat(-60), y: CGFloat(-16), width: CGFloat(mediumLabel.frame.size.width + 40), height: CGFloat(mediumLabel.frame.size.height + 30)), cornerRadius: 30).cgPath
        
        easyBackground.strokeColor = UIColor.clear
        easyBackground.fillColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.2))
        easyBackground.zPosition = -1
        easyLabel.addChild(easyBackground)
        
        return easyLabel
        
        
    }
    
    func createHardLabel() -> SKLabelNode {
        
        let hardLabel = SKLabelNode()
        hardLabel.text = "Hard"
        hardLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 250)
        hardLabel.fontSize = 20
        hardLabel.zPosition = 5
        hardLabel.fontName = "HelveticaNeue-Bold"
        
        let hardBackground = SKShapeNode()
        hardBackground.position = CGPoint(x: 0, y: 0)
        hardBackground.path = UIBezierPath(roundedRect: CGRect(x:CGFloat(-60), y: CGFloat(-16), width: CGFloat(mediumLabel.frame.size.width + 40), height: CGFloat(mediumLabel.frame.size.height + 30)), cornerRadius: 30).cgPath
        
        hardBackground.strokeColor = UIColor.clear
        hardBackground.fillColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.2))
        hardBackground.zPosition = -1
        hardLabel.addChild(hardBackground)
        
        return hardLabel
        
        
    }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "\(currentScore)"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: 4.5 * self.frame.height / 5)
        scoreLabel.fontSize = 45
        scoreLabel.zPosition = 5
        scoreLabel.fontName = "HelveticaNeue-Bold"
        
        let scoreBackground = SKShapeNode()
        scoreBackground.position = CGPoint(x: 0, y: 0)
        scoreBackground.path = UIBezierPath(roundedRect: CGRect(x:CGFloat(-45), y: CGFloat(-26), width: CGFloat(90), height: CGFloat(90)), cornerRadius: 50).cgPath
        
        
        scoreBackground.strokeColor = UIColor.clear
        scoreBackground.fillColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.2))
        scoreBackground.zPosition = -1
        scoreLabel.addChild(scoreBackground)
        
        
        return scoreLabel
    }
    
    func createLeaderboard() {
        let leaderboard = SKLabelNode()
        leaderboard.numberOfLines = 0
        
        
        var eHighestScore: String = "0"
        var mHighestScore: String = "0"
        var hHighestScore: String = "0"
        
        if let easyRecord = UserDefaults.standard.object(forKey: "easyHighestScore") {
            eHighestScore = "\(easyRecord)"
        }
        
        if let mediumRecord = UserDefaults.standard.object(forKey: "mediumHighestScore") {
            mHighestScore = "\(mediumRecord)"
        }
        
        if let hardRecord = UserDefaults.standard.object(forKey: "hardHighestScore") {
            hHighestScore = "\(hardRecord)"
        }
        
        leaderboard.text = "Your best scores \n Easy: " + eHighestScore + " \n Medium: " + mHighestScore + " \n Hard: " + hHighestScore

        leaderboard.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 40)
        leaderboard.fontSize = 20
        leaderboard.zPosition = 5
        leaderboard.fontName = "HelveticaNeue-Bold"
        
        
        let leaderboardBackground = SKShapeNode()
        leaderboardBackground.position = CGPoint(x: 0, y: 0)
        leaderboardBackground.path = UIBezierPath(roundedRect: CGRect(x:CGFloat(-110), y: CGFloat(-18), width: CGFloat(leaderboard.frame.size.width + 60), height: CGFloat(leaderboard.frame.size.height + 30)), cornerRadius: 30).cgPath
        
        leaderboardBackground.strokeColor = UIColor.clear
        leaderboardBackground.fillColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.3))
        leaderboardBackground.zPosition = -1
        leaderboard.addChild(leaderboardBackground)
        
        leaderboard.run(SKAction.fadeIn(withDuration: 1))
        self.addChild(leaderboard)
        
    }
    
    
    
    
    func createRestartButton() {
        restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.size = CGSize(width: 100, height: 100)
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 40)
        restartButton.zPosition = 5
        
        self.addChild(restartButton)
        restartButton.run(SKAction.scale(by: 1, duration: 0.3))

    }
    
    
    func createBattery() -> SKSpriteNode {
        let battery = SKSpriteNode(texture: SKTextureAtlas(named: "battery").textureNamed("batteryFull"))
        battery.size = CGSize(width: 70, height: 50)
        battery.position = CGPoint(x: self.frame.width / 8, y: self.frame.height - 30)
        battery.zPosition = 6
        return battery
        
    }
    
    
    func createCoin() -> SKSpriteNode {
        
        let coin = SKSpriteNode(texture: SKTextureAtlas(named: "coin").textureNamed("starCoin1"))
        
        coin.size = CGSize(width: 40, height: 40)
        coin.position = CGPoint(x: self.frame.width + 30, y: self.frame.height / 2)
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width / 2)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = CollisionBitMask.coinType
        coin.physicsBody?.collisionBitMask = CollisionBitMask.playerType
        coin.physicsBody?.contactTestBitMask = CollisionBitMask.playerType
        
        return coin
    }
    
    
    func animateCoin() -> SKAction {
        var coinAnimateArray = Array<Any>()
        for i in 0..<5 {
            coinAnimateArray.append(coinAtlas.textureNamed("starCoin\(i+1)"))
        }
        
        let animation = SKAction.animate(with: coinAnimateArray as! [SKTexture], timePerFrame: 0.2)
        return SKAction.repeatForever(animation)
    }
    
    
    
    func createFlower() -> SKSpriteNode {
        let flower = SKSpriteNode(texture: SKTextureAtlas(named: "flower").textureNamed("flower1"))
        flower.size = CGSize(width: 40, height: 40)
        flower.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2 - 200)

        flower.physicsBody = SKPhysicsBody(circleOfRadius: flower.size.width / 2)
        flower.physicsBody?.affectedByGravity = false
        flower.physicsBody?.isDynamic = false
        flower.physicsBody?.categoryBitMask = CollisionBitMask.flowerType
        flower.physicsBody?.collisionBitMask = CollisionBitMask.playerType
        flower.physicsBody?.contactTestBitMask = CollisionBitMask.playerType
        
        return flower
    }
    
    
    
    func animateFlower() -> SKAction {
        var flowerAnimateArray = Array<Any>()
        for i in 0..<4 {
            flowerAnimateArray.append(flowerAtlas.textureNamed("flower\(i+1)"))
        }
        
        let animation = SKAction.animate(with: flowerAnimateArray as! [SKTexture], timePerFrame: 0.1)
        return SKAction.repeatForever(animation)
    }
    
    
    func createPillars() -> SKNode {
        
        pillarPair = SKNode()
        pillarPair.name = "pillarPair"
        
        let btmPillar = SKSpriteNode(imageNamed: "pillar")
        btmPillar.position = CGPoint(x: self.frame.width + 30, y: self.frame.height / 2 - 480)
        btmPillar.setScale(0.5)
        btmPillar.physicsBody = SKPhysicsBody(rectangleOf: btmPillar.size)
        btmPillar.physicsBody?.categoryBitMask = CollisionBitMask.pillarType
        btmPillar.physicsBody?.collisionBitMask = CollisionBitMask.playerType
        btmPillar.physicsBody?.contactTestBitMask = CollisionBitMask.playerType
        btmPillar.physicsBody?.isDynamic = false
        btmPillar.physicsBody?.affectedByGravity = false
        pillarPair.addChild(btmPillar)
        
        if currentGameType != .easy {
            let topPillar = SKSpriteNode(imageNamed: "pillar")
            topPillar.position = CGPoint(x: self.frame.width + 30, y: self.frame.height / 2 + 480)
            topPillar.setScale(0.5)
            topPillar.physicsBody = SKPhysicsBody(rectangleOf: topPillar.size)
            topPillar.physicsBody?.categoryBitMask = CollisionBitMask.pillarType
            topPillar.physicsBody?.collisionBitMask = CollisionBitMask.playerType
            topPillar.physicsBody?.contactTestBitMask = CollisionBitMask.playerType
            topPillar.physicsBody?.isDynamic = false
            topPillar.physicsBody?.affectedByGravity = false
            topPillar.zRotation = CGFloat(Double.pi)
            pillarPair.addChild(topPillar)
        }
        

        pillarPair.zPosition = 1
        
        
        let randomNum = Float.random(in: 0..<1)
        let pillarRandomPlacing = random(uniRandom: randomNum, min: -70, max: 70)
        pillarPair.position.y = pillarPair.position.y + pillarRandomPlacing
        

        // Add coin to the pillar
        let coinNode = createCoin()
        let coinActionRepeat = animateCoin()
        coinNode.run(coinActionRepeat)
        pillarPair.addChild(coinNode)
        
        
        // add flower next to the pillar
        if currentGameType != .easy {
            let randomFlower = Float.random(in: 0..<1)
            if randomFlower > 0.65 {
                // generate flower
                let flowerNode = createFlower()
                let flowerActionRepeat = animateFlower()
                let flowerRandomPlacing = random(uniRandom: randomFlower, min: -250, max: 100)
                flowerNode.position.y = flowerNode.position.y + flowerRandomPlacing
                flowerNode.run(flowerActionRepeat)
                pillarPair.addChild(flowerNode)
            }
        }

        pillarPair.run(pillarMoveRemove)

        return pillarPair
    }
    

    func random(uniRandom: Float, min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(uniRandom) * (max - min) + min
    }
    
    
    
    
}
