//
//  Minion.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/20/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Minion: Enemy
{
   
   var minionSound = SKAction.playSoundFileNamed("Minion voice", waitForCompletion: true)
   
   let LEAP_DISTANCE_X = 80
   let LEAP_DISTANCE_Y = 80
   
   // default constuctor
   init()
   {
      super.init(texture: SKTexture(imageNamed: "ThrallLeft.png"), color: UIColor.clear, size: CGSize(width: 56.25, height: 56.25)) // 75
      
      self.zPosition = 1
      self.position.y = 0.0
      
      self.xScale *= 1.5
      self.yScale *= 1.5
      
      //setting up physics
   //  self.physicsBody = SKPhysicsBody(circleOfRadius: skin.size().height / 4, center: CGPoint(x: 1, y: 0))
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width / 2 , height: self.frame.size.height))

      self.physicsBody?.isDynamic = true
      
      self.physicsBody?.allowsRotation = false
      
      self.hitPoints = 100
      deathAnimationDuration = 0.3
   }
   
   
   /************************************************
    * moveToPlayer:
    *    This function moves the enemy closer to the
    * player based on his posistion.
//    *************************************************/
   override func moveToPlayer(playerPosistion: CGFloat)
   {
      if(self.isAlive == true)
      {
         
         if(isAttacking == false && attackAnimationLeftFinished == true && attackAnimationRightFinished == true)
         {
            if((playerPosistion - 5) > self.getPosistion())
            {
               self.moveRight()
               
               self.isRunningLeft = false
               self.isRunningRight = true
               self.runOnce = false
               
               // animate only if its the first time and the player isnt in the middle of shooting
               if(isRunningRight == true && runOnce2 == false)
               {
                  self.animateRight(pic0: "runRightOne.png", pic1: "runRightTwo.png", pic2: "runRightThree.png")
                  
                  self.runOnce2 = true
               }
            }
            
            
            if((playerPosistion + 5) < self.getPosistion())
            {
               self.moveLeft()
               
               self.isRunningLeft = true
               self.isRunningRight = false
               self.runOnce2 = false
               
               // animate only if its the first time and the player isnt in the middle of shooting
               if(isRunningLeft == true && runOnce == false)
               {
                  
                  self.animateLeft(pic0: "runLeftOne.png", pic1: "runLeftTwo.png", pic2: "runLeftThree.png")
                  
                  self.runOnce = true
               }
            }
            
         }
      }
   }
   
   /************************************************
    * moveToPlayer:
    *    This function moves the enemy closer to the
    * player based on his posistion.
    //    *************************************************/
   override func attack(playerPosistion: CGFloat)
   {
      if(self.isAlive == true)
      {
         if(isAttacking == true)
         {
            runOnce = false // reseting obvs
            runOnce2 = false
            
            
            if(isFacingRight == true && attackAnimationRightFinished == false && runOnce3 == false)
            {
               
               //animate skin
               let attackRight0 = SKTexture(imageNamed: "minionAttackRight0 copy")
               let attackRight1 = SKTexture(imageNamed: "minionAttackRight1 copy")
               let attackRight2 = SKTexture(imageNamed: "minionAttackRight2 copy")
               
               //animate leap
               let leapAction0 = SKAction.move(by: CGVector(dx: +LEAP_DISTANCE_X, dy:  +LEAP_DISTANCE_Y), duration: 0.3)
               let leapAction1 = SKAction.move(by: CGVector(dx:  +LEAP_DISTANCE_X, dy: -LEAP_DISTANCE_Y), duration: 0.3)
               let leapSequence = SKAction.sequence([leapAction0, leapAction1, leapAction0])
               
               
               
               let animate = SKAction.animate(with: [attackRight0, attackRight1, attackRight2], timePerFrame: 0.2)//2
               let runAnimate = SKAction.repeatForever(animate)
               
               //Animate
               self.run(runAnimate, completion:
                  {
                     
                     self.attackAnimationRightFinished = true
                     
               })
               
               //run sequnce
               self.run(leapSequence)
               runOnce3 = true
               
               //voice minion attack
               self.run(minionSound)
               
            }
            
            
            
            if(isFacingLeft == true && attackAnimationLeftFinished == false && runOnce3 == false)
            {
               //animate skin
               let attackLeft0 = SKTexture(imageNamed: "minionAttackLeft0")
               let attackLeft1 = SKTexture(imageNamed: "minionAttackLeft1")
               let attackLeft2 = SKTexture(imageNamed: "minionAttackLeft2")
               
               //animate leap
               let leapAction0 = SKAction.move(by: CGVector(dx: -LEAP_DISTANCE_X, dy:  +LEAP_DISTANCE_Y), duration: 0.3)
               let leapAction1 = SKAction.move(by: CGVector(dx:  -LEAP_DISTANCE_X, dy: -LEAP_DISTANCE_Y), duration: 0.3)
               let leapSequence = SKAction.sequence([leapAction0, leapAction1, leapAction0])
               
               
               
               
               let animate = SKAction.animate(with: [attackLeft0, attackLeft1, attackLeft2], timePerFrame: 0.2)
               let runAnimate = SKAction.repeatForever(animate)
               
               //Animate
               self.run(runAnimate, completion:
                  {
                     
                     self.attackAnimationLeftFinished = true
                     
               })
               
               //run sequnce
               self.run(leapSequence)
               runOnce3 = true
               
               //voice minion attack
               self.run(minionSound)
               
            }
         }
         
         
      }
         
   }
   
   /************************************************
    * backup:
    *    If the enemy has attacked, backup so they
    * can attack again.
    *************************************************/
   override func backup()
   {
      let codeBlock = SKAction.run({
         if(self.isFacingRight)
         {
            let moveAction = SKAction.moveBy(x: -5, y: 0, duration: 1.5)
            self.run(moveAction)
         }
         if(self.isFacingLeft)
         {
            let moveAction = SKAction.moveBy(x: 5, y: 0, duration: 1.5)
            self.run(moveAction)

         }
         
      })
      
      
      
      let sequence = SKAction.sequence([codeBlock, SKAction.wait(forDuration: 1)])
      
      self.run(sequence)

   }
   
   /************************************************
    * deathAnimation:
    *   enemy is dead so animate it.
    *************************************************/
   override func deathAnimation()
   {
      if(isAlive == false)
      {
         
         if(isFacingRight && deathAnimationFinished == false)
         {
            //animate skin
            let death0 = SKTexture(imageNamed: "thrallDeathRightOne.png")
            let death1 = SKTexture(imageNamed: "thrallDeathRightTwo.png")
            
            let animate = SKAction.animate(with: [death0,death1,death1,death1,death1], timePerFrame: 0.1)
            let runAnimate = SKAction.repeat(animate, count: 1)
            
            self.run(runAnimate, completion: {
               //self.deathAnimationFinished = true
            })
            
            deathAnimationFinished = true
            self.texture = SKTexture(imageNamed: "thrallDeathRightTwo.png")

         }
         
         
         if(isFacingLeft && deathAnimationFinished == false)
         {
            //animate skin
            let death0 = SKTexture(imageNamed: "thrallDeathLeftOne.png")
            let death1 = SKTexture(imageNamed: "thrallDeathLeftTwo.png")
            
            let animate = SKAction.animate(with: [death0,death1,death1,death1,death1], timePerFrame: 0.1)
            let runAnimate = SKAction.repeat(animate, count: 1)
            
            
            self.run(runAnimate, completion: {
             //  self.deathAnimationFinished = true
            })
            deathAnimationFinished = true
            
            self.texture = SKTexture(imageNamed: "thrallDeathLeftTwo.png")
            
         }
      }
   }
   
   /************************************************
    * pauseYourSelf:
    *   Pauses the enemy.
    *************************************************/
   override func pauseYourSelf()
   {
      
      runOnce = false;
      runOnce2 = false;
      runOnce3 = false;
      if(self.isFacingRight)
      {
         //set texture
         let standingRight = SKTexture(imageNamed: "ThrallRight.png")
         
         let animate = SKAction.animate(with: [standingRight], timePerFrame: 0.1)
         let runAnimate = SKAction.repeatForever(animate)
         
         self.run(runAnimate, completion: {
            
         })
        
      }
      if(self.isFacingLeft)
      {
         //set texture
         let standingRight = SKTexture(imageNamed: "ThrallLeft.png")
         
         let animate = SKAction.animate(with: [standingRight], timePerFrame: 0.1)
         let runAnimate = SKAction.repeatForever(animate)
         
         self.run(runAnimate, completion: {
            
         })      }

   }
   
   /************************************************
    * pauseYourSelf:
    *   Pauses the enemy.
    *************************************************/
   override func unpauseYourSelf()
   {
        
   }
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
}
   
