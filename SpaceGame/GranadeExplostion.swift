//
//  GranadeExplostion.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/30/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class GranadeExplotion: Object
{
   var wasFiredLeft = false
  
   
   init(skin: String, damage: Double)
   {
      super.init(color: UIColor.clear, size: CGSize(width: 15, height: 15), posistion: CGPoint(x: 0, y: 0))
      self.texture = SKTexture(imageNamed: "granadeExplo1")
      self.xScale = 2
      self.yScale = 2
      
      
      
     explosionDamage = 75
      
      //may need to change to sqaure later.
      
      self.physicsBody = SKPhysicsBody(circleOfRadius: skin.size().height * 1.2, center: CGPoint(x: 1, y: 0))
      // self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))// 10
      self.physicsBody?.isDynamic = true
      self.physicsBody?.affectedByGravity = true
      self.physicsBody?.allowsRotation = true
      
   }
   
   
   
   
   
   
   
   override func explosion()
   {
      if(wasFiredLeft)
      {
         
         // let left0Texture = SKTexture(imageNamed: "bulletExpLeft")
         print("finished left")
         let lef1Texture = SKTexture(imageNamed: "explode0")
         let lef2Texture = SKTexture(imageNamed: "explode1")
         
         let lef3Texture = SKTexture(imageNamed: "granadeExplo1")
         let lef4Texture = SKTexture(imageNamed: "granadeExplo2")
         
         
         let animation = SKAction.animate(with: [lef1Texture, lef2Texture, lef3Texture, lef4Texture], timePerFrame: 0.11)
         let runExplo = SKAction.repeat(animation, count: 1)
         
         self.xScale *= 1.2
         self.yScale *= 1.2
         
         //Animate
         run(runExplo, completion: {
          //  self.bulletLifeTime = 1;
            self.removeFromParent()
         })
         
      }
      else
      {
         let lef1Texture = SKTexture(imageNamed: "explode0")
         let lef2Texture = SKTexture(imageNamed: "explode1")
         
         let lef3Texture = SKTexture(imageNamed: "granadeExplo1")
         let lef4Texture = SKTexture(imageNamed: "granadeExplo2")
         
         
         let animation = SKAction.animate(with: [lef1Texture, lef2Texture, lef3Texture, lef4Texture], timePerFrame: 0.11)
         let runExplo = SKAction.repeat(animation, count: 1)
         self.xScale *= 1.2
         self.yScale *= 1.2
         
         //Animate
         run(runExplo, completion: {
            //self.bulletLifeTime = 1;
            self.removeFromParent()
         })

         
      }
      
   }
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// ROCKET EXPLOTSOON
class RocketExplotion: Object
{
   var wasFiredLeft = false
   var animationSpeed = 0.10
   
   
   init(skin: String, damage: Double)
   {
      super.init(color: UIColor.clear, size: CGSize(width: 75, height: 75), posistion: CGPoint(x: 0, y: 0))
      self.texture = SKTexture(imageNamed: "granadeExplo1")
      self.xScale = 3 // was 1.5, 1.5
      self.yScale = 2
      
      
      
      explosionDamage = 200
      
      //may need to change to sqaure later.
      
      self.physicsBody = SKPhysicsBody(circleOfRadius: skin.size().height * 3, center: CGPoint(x: 1, y: 0))
     
      self.physicsBody?.isDynamic = true
      self.physicsBody?.affectedByGravity = false
      self.physicsBody?.allowsRotation = false
      
   }
   
   
   
   
   
   
   
   override func explosion()
   {
      if(wasFiredLeft)
      {
         
         // let left0Texture = SKTexture(imageNamed: "bulletExpLeft")
//         print("finished left")
         let lef1Texture = SKTexture(imageNamed: "newRocketExplodeLeftOne.png")
         let lef2Texture = SKTexture(imageNamed: "newRocketExplodeLeftTwo.png")
         
         let lef3Texture = SKTexture(imageNamed: "newRocketExplodeLeftThree.png")
//         let lef4Texture = SKTexture(imageNamed: "newRocketExplodeOne.png")
         
         
         let animation = SKAction.animate(with: [lef1Texture, lef2Texture, lef3Texture], timePerFrame: animationSpeed)
         let runExplo = SKAction.repeat(animation, count: 1)
         
//         self.xScale *= 1.5
//         self.yScale *= 1.5
         
         //Animate
         run(runExplo, completion: {
            //  self.bulletLifeTime = 1;
            self.removeFromParent()
         })
         
      }
      else
      {
         let lef1Texture = SKTexture(imageNamed: "newRocketExplodeOne.png")
         let lef2Texture = SKTexture(imageNamed: "newRocketExplodeTwo.png")
         
         let lef3Texture = SKTexture(imageNamed: "newRocketExplodeThree.png")
         
         
         let animation = SKAction.animate(with: [lef1Texture, lef2Texture, lef3Texture], timePerFrame: animationSpeed)
         let runExplo = SKAction.repeat(animation, count: 1)
//         self.xScale *= 1.5
//         self.yScale *= 1.5
         
         //Animate
         run(runExplo, completion: {
            //self.bulletLifeTime = 1;
            self.removeFromParent()
         })
         
         
      }
      
   }
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }


}
