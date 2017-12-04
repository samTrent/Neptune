//
//  GameViewController.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/18/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
   
  
    
   //Here the scene is created and the Gamescene object is presented.
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let scene = MainMenu(fileNamed: "mainMenu") // start with mainMenu
      //if let scene = GameScene(fileNamed: "GameScene") // GameScene
      {
         // Configure the view.
         let skView = self.view as! SKView
         skView.showsFPS = true
         skView.showsNodeCount = true
         
         //see bodies
         
         skView.showsPhysics = true
        
         /* Sprite Kit applies additional optimizations to improve rendering performance */
         skView.ignoresSiblingOrder = true
         
         /* Set the scale mode to scale to fit the window */
         scene.scaleMode = .aspectFill // apparently aspectFit is the one we want
         
         skView.presentScene(scene)
      }
   }
   
   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      let skView = self.view as! SKView
      if let scene = skView.scene {
         var size = scene.size
         let newHeight = skView.bounds.size.height / skView.bounds.width * size.width
         if newHeight > size.height {
            scene.anchorPoint = CGPoint(x: 0, y: (newHeight - scene.size.height) / 2.0 / newHeight)
            size.height = newHeight
            scene.size = size
         }
      }
   }
   
   override var shouldAutorotate : Bool {
      return true
   }
   
   override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
      if UIDevice.current.userInterfaceIdiom == .phone {
         return .allButUpsideDown
      } else {
         return .all
      }
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Release any cached data, images, etc that aren't in use.
   }
   
   override var prefersStatusBarHidden : Bool {
      return true
   }
    
    //Hide homebutton on iphone X
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}
