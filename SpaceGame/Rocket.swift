//
//  Rocket.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/25/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Rocket: Bullet
{
  
   
   
   override init(skin: String, damage: Double)
   {
    super.init(skin: "rocketRight1", damage: 200)
      
      self.xScale = 4
      self.yScale = 1
      
      bulletType = 2
      
      bulletDamage = 200
      
      //may need to change to sqaure later.
      
      //self.physicsBody = SKPhysicsBody(circleOfRadius: skin.size().height, center: CGPoint(x: 1, y: 0))
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height + 5))// 10
      self.physicsBody?.isDynamic = true
      self.physicsBody?.affectedByGravity = false
      self.physicsBody?.allowsRotation = false
      isARocket = true
   }
   
   override func bulletExlopsion()
   {
      if(wasFiredLeft)
      {
         
         // let left0Texture = SKTexture(imageNamed: "bulletExpLeft")
         let lef1Texture = SKTexture(imageNamed: "newRocketExplodeOne.png")
         let lef2Texture = SKTexture(imageNamed: "newRocketExplodeTwo.png")
         let lef3Texture = SKTexture(imageNamed: "newRocketExplodeThree.png")
         
         
         let animation = SKAction.animate(with: [lef1Texture, lef2Texture, lef3Texture], timePerFrame: 0.11)
         let runExplo = SKAction.repeat(animation, count: 1)
         
         self.xScale = 2
         self.yScale = 5
         
         //Animate
         run(runExplo, completion: {
            self.bulletLifeTime = 1;
            self.removeFromParent()
         })
         
      }
      else
      {
         
         // let right0Texture = SKTexture(imageNamed: "bulletExpRight")
         let right1Texture = SKTexture(imageNamed: "newRocketExplodeOne.png")
         let right2Texture = SKTexture(imageNamed: "newRocketExplodeTwo.png")
         let right3Texture = SKTexture(imageNamed: "newRocketExplodeThree.png")
         
         
         
         
         let animation = SKAction.animate(with: [right1Texture, right2Texture, right3Texture], timePerFrame: 0.11)
         let runExplo = SKAction.repeat(animation, count: 1)
         
         self.xScale = 2
         self.yScale = 5
         
         //Animate
         run(runExplo, completion: {
            self.bulletLifeTime = 1;
            self.removeFromParent()
         })
      }

   }
   
   override func animateMovement()
   {
      if(wasFiredLeft == true && runOnce == false)
      {
         runOnce = true
         let rocket0 = SKTexture(imageNamed: "rocketLeft0")
         let rocket1 = SKTexture(imageNamed: "rocketLeft1")
         
         let animate = SKAction.animate(with: [rocket0, rocket1], timePerFrame: 0.1)
         
         let animateRocket = SKAction.repeatForever(animate)
         
         run(animateRocket)
         
      }
      if(wasFiredLeft == false && runOnce == false)
      {
         runOnce = true
         let rocket0 = SKTexture(imageNamed: "rocketRight0")
         let rocket1 = SKTexture(imageNamed: "rocketRight1")
         
         let animate = SKAction.animate(with: [rocket0, rocket1], timePerFrame: 0.1)
         
         let animateRocket = SKAction.repeatForever(animate)
         
         run(animateRocket)
      }
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
