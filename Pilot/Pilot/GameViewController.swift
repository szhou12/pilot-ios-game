//
//  GameViewController.swift
//  Pilot
//
//  Created by Joshua Zhou on 3/5/19.
//  Copyright © 2019 Shuyu Zhou. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.3, *) {
            RateMe().showReview(afterMinCounts: 2)
        }
        
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = false
        skView.showsFPS = false
        skView.showsNodeCount = false
        let gameScene = GameScene(size: view.bounds.size)
        gameScene.scaleMode = .resizeFill
        
        skView.presentScene(gameScene)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
