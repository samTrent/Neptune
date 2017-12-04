//
//  mainMenu.swift
//  SpaceGame
//
//  Created by Sam Trent on 1/3/17.
//  Copyright © 2017 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameKit

class MainMenu: SKScene
{
   
   /************************************************
    * didMove:
    *    Loads the scence and init's all objects.
    *************************************************/
   override func didMove(to view: SKView)
   {
      let background = Background(color: UIColor.clear, size: CGSize(width: 800, height: 450))
      
      background.position = CGPoint(x: 0, y: 0)
      
      background.zPosition = 1
      
      background.texture = SKTexture(imageNamed: "menuScene.png")

      addChild(background)
      
      
      // Start the game
      let startButton = Button(defaultButtonImage: "startButton", activeButtonImage: "startButton")
      {
         // transition to game
         let newScene = GameScene(fileNamed: "GameScene")
//         let skView = self.view as! SKView
//         skView.ignoresSiblingOrder = true
         
         /* Set the scale mode to scale to fit the window */
         newScene?.scaleMode = .aspectFill
         self.scene?.view?.presentScene(newScene!, transition: SKTransition.fade(with: UIColor.black, duration: 2.0))
      }
      
      startButton.position = CGPoint(x: 0, y: 0)
      startButton.zPosition = 10
      startButton.xScale /= 2
      startButton.yScale /= 2
      addChild(startButton)
      
   }
   
   
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
   {
      //none
   }
   
   
   
   override func update(_ currentTime: TimeInterval)
   {
      //none
   }
}
