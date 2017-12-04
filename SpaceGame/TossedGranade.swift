//
//  TossedGranade.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/30/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

// HAD TO INHERIT FROM OBJECT INSTEAD OF BULLET INORDER TO WORK

class TossedGranade: Object
{
   var bulletDamage = 75
   var bulletType = 3
   var bulletLifeTime = 20
   var wasFiredLeft = false
   
   init(skin: String, damage: Double)
   {
      super.init(color: UIColor.clear, size: CGSize(width: 0, height: 0), posistion: CGPoint(x: 0, y: 0))
      self.texture = SKTexture(imageNamed: "granadeExplo0")
      self.xScale = 1
      self.yScale = 1
      
      bulletType = 3
      isAGranade = true
      expireTime = 50
      bulletDamage = 75
      
      //may need to change to sqaure later.
      
      self.physicsBody = SKPhysicsBody(circleOfRadius: skin.size().height / 2, center: CGPoint(x: 1, y: 0))
     // self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))// 10
      self.physicsBody?.isDynamic = true
      self.physicsBody?.affectedByGravity = true
      self.physicsBody?.allowsRotation = true
      
   }
   
   
   
     
   
   
   
   func bulletExlopsion()
   {
      if(wasFiredLeft)
      {
         
         // let left0Texture = SKTexture(imageNamed: "bulletExpLeft")
         let lef1Texture = SKTexture(imageNamed: "granadeExplo0")
         let lef2Texture = SKTexture(imageNamed: "granadeExplo1")
         let lef3Texture = SKTexture(imageNamed: "granadeExplo2")
         
         
         let animation = SKAction.animate(with: [lef1Texture, lef2Texture, lef3Texture], timePerFrame: 0.11)
         let runExplo = SKAction.repeat(animation, count: 1)
         
         self.xScale = 1
         self.yScale = 1
         
         //Animate
         run(runExplo, completion: {
            self.bulletLifeTime = 1;
            self.removeFromParent()
         })
         
      }
      else
      {
         
         // let right0Texture = SKTexture(imageNamed: "bulletExpRight")
         let right1Texture = SKTexture(imageNamed: "granadeExplo0")
         let right2Texture = SKTexture(imageNamed: "granadeExplo1")
         let right3Texture = SKTexture(imageNamed: "granadeExplo2")
         
         
         
         
         let animation = SKAction.animate(with: [right1Texture, right2Texture, right3Texture], timePerFrame: 0.11)
         let runExplo = SKAction.repeat(animation, count: 1)
         
         self.xScale = 2
         self.yScale = 2
         
         //Animate
         run(runExplo, completion: {
            self.bulletLifeTime = 1;
            self.removeFromParent()
         })
      }
      
   }
   
   func tossGranade(playerPosistion: CGPoint)
   {
      if(wasFiredLeft)
      {
         //toss left sequnece
        
         let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI / 4), duration: 0.5)
         let tossAction0 = SKAction.move(to: CGPoint(x: playerPosistion.x - 50, y: playerPosistion.y + 25), duration: 0.1)
         let tossAction1 = SKAction.move(to: CGPoint(x:  playerPosistion.x - 75, y: playerPosistion.y + 50), duration: 0.1)
         let tossAction2 = SKAction.move(to: CGPoint(x:  playerPosistion.x - 95, y: playerPosistion.y + 25), duration: 0.1)
         let tossAction3 = SKAction.move(by: CGVector(dx: playerPosistion.x - 80, dy:  1), duration: 0.5)
         
         
         let tossSequence = SKAction.sequence([tossAction0, tossAction1, tossAction2, tossAction3, rotateAction])
         
         self.run(SKAction.repeatForever(SKAction.rotate(byAngle: -CGFloat.pi * 2.0, duration: 0.5))) // make it spin
         self.run(tossSequence)
      }
      else
      {
         //toss right sequnece
        
         let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI / 4), duration: 0.5)
         let tossAction0 = SKAction.move(to: CGPoint(x: playerPosistion.x + 50, y: playerPosistion.y + 25), duration: 0.1)
         let tossAction1 = SKAction.move(to: CGPoint(x:  playerPosistion.x + 75, y: playerPosistion.y + 50), duration: 0.1)
         let tossAction2 = SKAction.move(to: CGPoint(x:  playerPosistion.x + 95, y: playerPosistion.y + 25), duration: 0.1)
         let tossAction3 = SKAction.move(by: CGVector(dx: playerPosistion.x + 80, dy:  1), duration: 0.5)
         
         
         let tossSequence = SKAction.sequence([tossAction0, tossAction1, tossAction2, tossAction3, rotateAction])
         
         self.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: 0.5))) // make it spin
         self.run(tossSequence)

      }
   }

   
   //getters
   func wasBulletFiredLeft() -> Bool
   {
      return wasFiredLeft
   }
   
   func getBulletLifeTime() -> Int
   {
      return bulletLifeTime
   }
   
   
   //Setters
   func setY(y: CGFloat)
   {
      self.position.y = y
   }
   
   func setX(x: CGFloat)
   {
      self.position.x = x
   }
   
   func wasBulletFiredLeft(leftShot: Bool)
   {
      wasFiredLeft = leftShot
   }
   
   func setBulletLifeTime(life: Int)
   {
      bulletLifeTime = life
   }

   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
