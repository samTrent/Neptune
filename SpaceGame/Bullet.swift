//
//  Bullet.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/21/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode
{
   var wasFiredLeft = false
   var bulletLifeTime = 50
   var bulletDamage = 25
   var isARocket = false
   
   var bulletType = 1 // this is a laserBolt
   
   var runOnce = false // ensures that the movement animation plays once.
   
   
   init(skin: String, damage: Double)
   {
      super.init(texture: SKTexture(imageNamed: "laserBolt"), color: UIColor.clear, size: CGSize(width: 15, height: 15)) // 20
      
      self.xScale = 2
      self.yScale /= 5
      
      
      //may need to change to sqaure later.
     
      //self.physicsBody = SKPhysicsBody(circleOfRadius: skin.size().height, center: CGPoint(x: 1, y: 0))
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
      self.physicsBody?.isDynamic = true
      self.physicsBody?.affectedByGravity = false
      self.physicsBody?.allowsRotation = false
   }
   
   /************************************************
    * moveLeft:
    *     laser fires to the left
    *************************************************/
   func moveLeft()
   {
      let moveAction = SKAction.moveBy(x: -10, y: 0, duration: 0.1)
      run(moveAction)
   }
   
   /************************************************
    * moveRight:
    *     laser fires to the right
    *************************************************/
   func moveRight()
   {
      let moveAction = SKAction.moveBy(x: 10, y: 0, duration: 0.1)
      run(moveAction)
   }
   
   /************************************************
    * bulletExplosion:
    *     animate the bullet when it hits somthing
    *************************************************/
   func bulletExlopsion()
   {
      if(wasFiredLeft)
      {
        
        // let left0Texture = SKTexture(imageNamed: "bulletExpLeft")
         let lef1Texture = SKTexture(imageNamed: "ExploLeft")
         
         
         let animation = SKAction.animate(with: [lef1Texture], timePerFrame: 0.01)
         let runExplo = SKAction.repeat(animation, count: 1)
         
         self.xScale = 2
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
         let right1Texture = SKTexture(imageNamed: "ExploRight")
         
         
         let animation = SKAction.animate(with: [right1Texture], timePerFrame: 0.01)
         let runExplo = SKAction.repeat(animation, count: 1)
         
         self.xScale = 2
         self.yScale = 1
         
         //Animate
         run(runExplo, completion: {
            self.bulletLifeTime = 1;
            self.removeFromParent()
         })
      }
   }
   
   
   func animateMovement()
   {
      
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
