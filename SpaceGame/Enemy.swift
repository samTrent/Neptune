//
//  Enemy.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/20/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode
{
  // var skin = SKTexture(imageNamed: "standingRight")
   
   var isFacingLeft = false
   var isFacingRight = false
   
   var hitPoints = 0
   var inRangeToAttack = false
   var isInContact = false // if enemy is touching the player
   var damageAmount = 1 // how much damage an enemy does
   var attackRate = 0.5 // how fast an enemy does damage
   
   
   var skin = SKTexture(imageNamed: "")
   
   var isAlive = true
  
   var isRunningLeft = false
   var isRunningRight = false
   
   var runOnce = false
   var runOnce2 = false
   var runOnce3 = false // ensures that the attack animation completes
   
   var goRoam = false // dont get into range, go roam
   
   
   var attackAnimationLeftFinished = true
   var attackAnimationRightFinished = true
   var deathAnimationFinished = false
   
   var deathAnimationDuration = 0.0 // how long before animation is complete, put this in didBegin()
   
   
   
   var isAttacking = false
   
   
   
   /************************************************
    * moveToPlayer:
    *    This function moves the enemy closer to the
    * player based on his posistion.
    *************************************************/
   func moveToPlayer(playerPosistion: CGFloat)
   {
      if(isAttacking == false && attackAnimationLeftFinished == true && attackAnimationRightFinished == true)
      {
      
     
         attackAnimationLeftFinished = false // reseting obvs
         attackAnimationLeftFinished = false
         
         if((playerPosistion - 5) > self.getPosistion())
         {
            self.moveRight()
            
            self.isRunningLeft = false
            self.isRunningRight = true
            self.runOnce = false
            
            // animate only if its the first time
            if(isRunningRight == true && runOnce2 == false)
            {
               self.animateRight(pic0: "minionRunningRight0", pic1: "minionRunningRight1", pic2: "minionRunningRight2")
               
               self.runOnce2 = true
            }
         }
        
         if((playerPosistion + 5) < self.getPosistion())
         {
            self.moveLeft()
            
            self.isRunningLeft = true
            self.isRunningRight = false
            self.runOnce2 = false
            
            // animate only if its the first time
            if(isRunningLeft == true && runOnce == false)
            {
               
               self.animateLeft(pic0: "minionRunningLeft0", pic1: "minionRunningLeft1", pic2: "minionRunningLeft2")
               
               self.runOnce = true
            }
         }
         
     }
   }

   
   
   
   
   /************************************************
    * moveLeft:
    *     Moves the player to the left
    *************************************************/
   func attack(playerPosistion: CGFloat)
   {
     
      if(isAttacking == true)
      {
         runOnce = false // reseting obvs
         runOnce2 = false
         
        
         
        
       
         if(isFacingRight == true && attackAnimationRightFinished == false)
         {
            self.attackAnimationRightFinished = true
            
            let attackRight0 = SKTexture(imageNamed: "")
            let attackRight1 = SKTexture(imageNamed: "")
            let attackRight2 = SKTexture(imageNamed: "")
            
            
            let animate = SKAction.animate(with: [attackRight0, attackRight1, attackRight2], timePerFrame: 0.2)
            let runAnimate = SKAction.repeatForever(animate)
            //Animate
            self.run(runAnimate, completion:
            {
               self.attackAnimationRightFinished = false
            })
            
            
           
         }
         
         
         
         if(isFacingLeft == true && attackAnimationLeftFinished == false)
         {
            self.attackAnimationLeftFinished = true
            
            let attackLeft0 = SKTexture(imageNamed: "")
            let attackLeft1 = SKTexture(imageNamed: "")
            let attackLeft2 = SKTexture(imageNamed: "")
            
            
            let animate = SKAction.animate(with: [attackLeft0, attackLeft1, attackLeft2], timePerFrame: 0.2)
            let runAnimate = SKAction.repeatForever(animate)
            
            //Animate
            self.run(runAnimate, completion:
               {
                  self.attackAnimationLeftFinished = false
            })
            
           

            
            
         }
         
         
     
      }
   }

   
   
   /************************************************
    * moveLeft:
    *     Moves the player to the left
    *************************************************/
   func moveLeft()
   {
      let moveAction = SKAction.moveBy(x: -3, y: 0, duration: 0.1)
      run(moveAction)
   }
   
   /************************************************
    * moveRight:
    *     Moves the player to the right
    *************************************************/
   func moveRight()
   {
      let moveAction = SKAction.moveBy(x: 3, y: 0, duration: 0.1)
      run(moveAction)
   }
   
   
   /************************************************
    * finishedMoving:
    *     When the player is done moving this will reset
    *  his image to the direction he was running.
    *************************************************/
   func finishedMoving(rightImage: String, leftImage: String)
   {
      if(isFacingRight == true)
      {
         let standingRightTexture = SKTexture(imageNamed: rightImage)
         let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
         let resetImage = SKAction.repeat(reset, count: 1)
         
         //Animate
         run(resetImage)
      }
      
      if(isFacingLeft == true)
      {
         let standingRightTexture = SKTexture(imageNamed: leftImage)
         let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
         let resetImage = SKAction.repeat(reset, count: 1)
         
         //Animate
         run(resetImage)
      }
      
   }
   
   /************************************************
    * animateRight:
    *       Animates the player running to the right
    *************************************************/
   func animateRight(pic0: String, pic1: String, pic2: String)
   {
      self.texture = SKTexture(imageNamed: "")
      
      let run0RightTexture = SKTexture(imageNamed: pic0)
      let run1RightTexture = SKTexture(imageNamed: pic1)
      let run2RightTexture = SKTexture(imageNamed: pic2)
      
      //let run2RightTexture = SKTexture(imageNamed: "Run0.png")
      
      let animation = SKAction.animate(with: [run0RightTexture, run1RightTexture, run2RightTexture], timePerFrame: 0.2)
      let runRight = SKAction.repeatForever(animation)
      
      
      //Animate
      run(runRight)
      
      isFacingRight = true
      isFacingLeft = false
   }
   
   
   /************************************************
    * animateLeft:
    *       Animates the player running to the left
    *************************************************/
   func animateLeft(pic0: String, pic1: String, pic2: String)
   {
      self.texture = SKTexture(imageNamed: "")
      
      let run0LeftTexture = SKTexture(imageNamed: pic0)
      let run1LeftTexture = SKTexture(imageNamed: pic1)
      let run2LeftTexture = SKTexture(imageNamed: pic2)
      
      let animation = SKAction.animate(with: [run0LeftTexture, run1LeftTexture, run2LeftTexture], timePerFrame: 0.2)
      let runLeft = SKAction.repeatForever(animation)
      
      
      //Animate
      run(runLeft)
      
      isFacingRight = false
      isFacingLeft = true
   }
   
   
   func faceLeft(textureName: String)
   {
      let standingRightTexture = SKTexture(imageNamed: textureName)
      let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
      let resetImage = SKAction.repeat(reset, count: 1)
      
      //Animate
      run(resetImage)
   }
   
   
   func faceRight(textureName: String)
   {
      let standingRightTexture = SKTexture(imageNamed: textureName)
      let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
      let resetImage = SKAction.repeat(reset, count: 1)
      
      //Animate
      run(resetImage)
   }
   
   
   
   
   /************************************************
    * deathAnimation:
    *   enemy is dead so animate it.
    *************************************************/
   func deathAnimation()
   {
      //stubb
   }
   
   
   /************************************************
    * pauseYourSelf:
    *   Pauses the enemy.
    *************************************************/
   func pauseYourSelf()
   {
      //stubb
   }
   
   /************************************************
    * pauseYourSelf:
    *   Pauses the enemy.
    *************************************************/
   func unpauseYourSelf()
   {
      //stubb
   }
   
   /************************************************
    * Roam:
    *    If the player is dead or the players Y is
    * greater than 60 and enemy hits an object, then
    * have them roam.
    *************************************************/
   func Roam()
   {
      
      
      if(self.position.x < 0)
      {
         
         moveLeft()
         
         self.isRunningLeft = true
         self.isRunningRight = false
         self.runOnce2 = false
         
         
         // animate only if its the first time
         if(isRunningLeft == true && runOnce == false)
         {
            
            self.animateLeft(pic0: "minionRunningLeft0", pic1: "minionRunningLeft1", pic2: "minionRunningLeft2")
            
            self.runOnce = true
         }
        
      }
      if(self.position.x > 0)
      {
        
         
         moveRight()
         
         self.isRunningLeft = false
         self.isRunningRight = true
         self.runOnce = false
         
         
         // animate only if its the first time
         if(isRunningRight == true && runOnce2 == false)
         {
            self.animateRight(pic0: "minionRunningRight0", pic1: "minionRunningRight1", pic2: "minionRunningRight2")
            
            self.runOnce2 = true
         }
         
      }

      

      
   }
   
   /************************************************
    * backup:
    *    If the enemy has attacked, backup so they 
    * can attack again.
    *************************************************/
   func backup()
   {
      
   }
   
   // **** GETTERS ****
   
   /************************************************
    * getPosistion:
    *     Sets the current posistion.
    *************************************************/
   func getPosistion() -> CGFloat
   {
      return self.position.x
   }
   
   
   /************************************************
    * getSkin:
    *     gets the skin of the sprite
    *************************************************/
   func getSkin() -> SKTexture
   {
      return skin
   }
   
   
   /************************************************
    * getIsAlive:
    *     returns isAlive
    *************************************************/
   func getIsAlive() -> Bool
   {
      return isAlive
   }
   
   /************************************************
    * getHitPoints:
    *     returns hitPoints
    *************************************************/
   func getHitPoints() -> Int
   {
      return hitPoints
   }

   
   
   
   /************************************************
    * getIsRunningleft:
    *     returns runningleft
    *************************************************/
   func getIsRunningLeft() -> Bool
   {
      return isRunningLeft
   }
   
   /************************************************
    * etIsRunningRight:
    *     returns runningRight
    *************************************************/
   func getIsRunningRight() -> Bool
   {
      return isRunningRight
   }

   func getRunOnce() -> Bool
   {
      return runOnce
   }
   
   func getRunOnce2() -> Bool
   {
      return runOnce2
   }
   
   /************************************************
    * getInRangeToAttackPlayer:
    *     returns true if the enemey is in range.
    *************************************************/
   func getInRangeToAttack(playerPosition: CGFloat, playerPositionY: CGFloat) -> Bool
   {
      if(playerPosition + 120 < getPosistion() || playerPosition - 120 > getPosistion())
      {
         // this should be true WTF oh well
         inRangeToAttack = false
         return inRangeToAttack
      }
      else
      {
         inRangeToAttack = true
         return inRangeToAttack
         
      }

   }
   
   
   
   
   

   
   //**** SETTERS ****
   
   /************************************************
    * spawn:
    *     Sets the spawn point.
    *************************************************/
   func spawn(spawnPoint: CGFloat)
   {
      self.position.x = spawnPoint
   }

   
   /************************************************
    * resetPosistion:
    *     Moves the posistion of the enemy charater
    *************************************************/
   func resetPosistion(newPosistion: CGFloat)
   {
      self.position.x += newPosistion
   }

   /************************************************
    * setSkin:
    *     Sets the skin of the sprite
    *************************************************/
   func setSkin(name: String)
   {
      skin = SKTexture(imageNamed: name)
   }
   
   /************************************************
    * setHitPoints:
    *     Sets the hitpoints
    *************************************************/
   func setHitPoints(setPoints: Int)
   {
      hitPoints = setPoints
   }

   func setIsRunningLeft(runningLeft: Bool)
   {
      isRunningLeft = runningLeft
   }
   
   func setIsRunningRight(runningRight: Bool)
   {
      isRunningRight = runningRight
   }
   
   func setRunOnce(settingRunOnce: Bool)
   {
      runOnce = settingRunOnce
   }
   
   func setRunOnce2(settingRunOnce2: Bool)
   {
      runOnce2 = settingRunOnce2
   }
   
   
   func setIsInRageToAttack(inRange: Bool)
   {
      inRangeToAttack = inRange
   }
   
   
}


   


   
   
   
   
   

