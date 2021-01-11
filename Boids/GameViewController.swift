//
//  GameViewController.swift
//  Boids
//
//  Created by Robert Bigelow on 7/6/20.
//  Copyright © 2020 Robert Bigelow. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  var scene: SKScene!
  
  @IBAction func zoomScene(_ sender: UIPinchGestureRecognizer) {
    if sender.state == .began || sender.state == .changed {
      if let camera = scene.camera {
        camera.setScale(sender.scale * camera.xScale)
        sender.scale = 1.0
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
    // including entities and graphs.
    if let gamekitScene = GKScene(fileNamed: "GameScene") {
        
      // Get the SKScene from the loaded GKScene
      if let sceneNode = gamekitScene.rootNode as! GameScene? {
          
        // Set the scale mode to scale to fit the window
        sceneNode.scaleMode = .aspectFill
        
        // Present the scene
        if let view = self.view as! SKView? {
          view.presentScene(sceneNode)
          
          view.ignoresSiblingOrder = true
          
          view.showsFPS = true
          view.showsNodeCount = true
        }
        
        self.scene = sceneNode
      }
    }
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
