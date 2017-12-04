//
//  player.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/19/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Player: SKSpriteNode
{
   var audioPlayer: AVAudioPlayer = AVAudioPlayer()
   var skin = SKTexture(imageNamed: "newStandingRight")
   
   var isFacingLeft = false
   var isFacingRight = false
   var isRunning = false
   
   var isAlive = true
   var playerIsTouchingGround = true
   
   var runningActionsHaveBeenRemovedOnce = false // lets us reset the SKACtion once for jumping.
//   var animationResetHasBeenCalledOnce = false

   
   var hitPoints = 20 // 10
   var maxHealth = 20
   
    var airTime = 15 // how long the player can stay in the air for
   
   // *** Animations ***
   
  
   
   // *** GUNS ***
   var hasPistol = false
   var hasRocketLauncher = false
   var hasGranades = false
   
   
   var justGotGun = false // lets us rerun an animation to update for new gun.
   var isFiring = false // keeps the animation stikll
   var runOnce3 = false // makes sure that the shoot run gets called once
   var runOnce4 = false // ensures that the death animation is ran once
   
   // default constuctor
   init(color: UIColor, size: CGSize)
   {
      super.init(texture: skin, color: UIColor.clear, size: size)
      
      //setting up physics
      
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width / 2 , height: +70), center: CGPoint(x: 0, y: -35))
      self.physicsBody?.isDynamic = true
      self.physicsBody?.allowsRotation = false
      
   }
   
   /************************************************
    * moveLeft:
    *     Moves the player to the left
    *************************************************/
   func moveLeft()
   {
      if(isAlive == true)
      {
         let moveAction = SKAction.moveBy(x: -5, y: 0, duration: 0.1)
         run(moveAction)
      }
   }

   /************************************************
    * moveRight:
    *     Moves the player to the right
    *************************************************/
   func moveRight()
   {
      if(isAlive == true)
      {
         let moveAction = SKAction.moveBy(x: 5, y: 0, duration: 0.1)
         run(moveAction)
      }
   }
   
   /************************************************
    * jump:
    *     Moves the player into the air
    *************************************************/
   func jump()
   {
     
      
      if(isAlive == true)
      {
         
      // makes it so that you can only jump so high
         if(airTime > 0)
         {
         
            let jumpAction = SKAction.moveBy(x: 0, y: 20, duration: 0.2)
            
            
            let jumpSquence = SKAction.sequence([jumpAction])
            
            jumpSquence.speed = 0.5
            
            self.run(jumpSquence)
            
            airTime -= 1
         }
      }
      
     // airTime = 20
   }

   
   /************************************************
    * knockBack:
    *     Moves the player backwards when he takes damage.
    *************************************************/
   func knockBack()
   {
      if(isAlive == true)
      {
         
         if(isFacingLeft)
         {
            self.texture = SKTexture(imageNamed: "damageLeft")
            
//            let knockBackAction = SKAction.move(by: CGVector(dx: 15, dy: 35), duration: 0.2) //dy 75
//            let sequence = SKAction.sequence([knockBackAction])
//            
//            self.run(sequence)
         }
         
         if(isFacingRight)
         {
            self.texture = SKTexture(imageNamed: "damageRight")
//            let knockBackAction = SKAction.move(by: CGVector(dx: -15, dy: 35), duration: 0.2)
//            let sequence = SKAction.sequence([knockBackAction])
//            
//            self.run(sequence)
         }
      }
   }
   
   
   /************************************************
   * finishedMoving:
   *     When the player is done moving this will reset
   *  his image to the direction he was running.
   *************************************************/
   func finishedMoving()
   {
      if(isAlive == true)
      {
         
         
         // print("player is finished moving")
         runOnce3 = false
         if(hasPistol == false && hasRocketLauncher == false)
         {
            if(isFacingRight == true)
            {
               let standingRightTexture = SKTexture(imageNamed: "newStandingRight.png")
               let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
               let resetImage = SKAction.repeat(reset, count: 1)
               
               //Animate
               run(resetImage)
            }
            
            if(isFacingLeft == true)
            {
               let standingRightTexture = SKTexture(imageNamed: "newStandingLeft.png")
               let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
               let resetImage = SKAction.repeat(reset, count: 1)
               
               //Animate
               run(resetImage)
            }
         }
         
         if(hasPistol == true && hasRocketLauncher == false)
         {
            if(isFacingRight == true)
            {
               let standingRightTexture = SKTexture(imageNamed: "newHoldingPistolRight.png")
               let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
               let resetImage = SKAction.repeat(reset, count: 1)
               
               //Animate
               run(resetImage)
            }
            
            if(isFacingLeft == true)
            {
               let standingRightTexture = SKTexture(imageNamed: "newHoldingPistolLeft.png")
               let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
               let resetImage = SKAction.repeat(reset, count: 1)
               
               //Animate
               run(resetImage)
            }
         }
         
         if(hasRocketLauncher == true && hasPistol == false)
         {
            if(isFacingRight == true)
            {
               let standingRightTexture = SKTexture(imageNamed: "newHoldingRocketRightFixed.png")
               let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
               let resetImage = SKAction.repeat(reset, count: 1)
               
               //Animate
               run(resetImage)
            }
            
            if(isFacingLeft == true)
            {
               let standingRightTexture = SKTexture(imageNamed: "newHoldingRocketLeftFixed.png")
               let reset = SKAction.animate(with: [standingRightTexture], timePerFrame: 0.1)
               let resetImage = SKAction.repeat(reset, count: 1)
               
               //Animate
               run(resetImage)
            }

         }
         
      }
   }
   
   /************************************************
    * animateRight:
    *       Animates the player running to the right
    *************************************************/
   func animateRight()
   {
      if(isAlive == true)
      {
         
         if(hasPistol == false && hasRocketLauncher == false)
         {
            
               let run0RightTexture = SKTexture(imageNamed: "newRunRightOne.png")
               let run1RightTexture = SKTexture(imageNamed: "newRunRightTwo.png")
               let run2RightTexture = SKTexture(imageNamed: "newRunRightThree.png")
               let run3RightTexture = SKTexture(imageNamed: "newRunRightFour.png")
               
               let animation = SKAction.animate(with: [run0RightTexture, run1RightTexture, run2RightTexture,run3RightTexture], timePerFrame: 0.2)
               let runRight = SKAction.repeatForever(animation)
               
               
               //Animate
               run(runRight)
               playFootSteps()
               
               isFacingRight = true
               isFacingLeft = false
            
           
         }
         
         if(hasPistol == true && hasRocketLauncher == false)
         {
            
               isRunning = true
               
               
               
               let run0RightTexture = SKTexture(imageNamed: "newRunningPistolRightOne.png")
               let run1RightTexture = SKTexture(imageNamed: "newRunningPistolRightTwo.png")
               let run2RightTexture = SKTexture(imageNamed: "newRunningPistolRightThree.png")
               let run3RightTexture = SKTexture(imageNamed: "newRunningPistolRightTwo.png")
               
               
               
               let animation = SKAction.animate(with: [run0RightTexture, run1RightTexture, run2RightTexture, run3RightTexture], timePerFrame: 0.2)
               let runRight = SKAction.repeatForever(animation)
               
               
               //Animate
               run(runRight, completion: { self.runOnce3 = false })
               
               isFacingRight = true
               isFacingLeft = false
           
         }
         
         
         
         if(hasRocketLauncher == true && hasPistol == false)
         {
            
               isRunning = true
               
               
               
               let run0RightTexture = SKTexture(imageNamed: "newRunningRocketRightOne.png")
               let run1RightTexture = SKTexture(imageNamed: "newRunningRocketRightTwo.png")
               let run2RightTexture = SKTexture(imageNamed: "newRunningRocketRightThree.png")
               let run3RightTexture = SKTexture(imageNamed: "newRunningRocketRightFour.png")
               
               
               
               let animation = SKAction.animate(with: [run0RightTexture, run1RightTexture, run2RightTexture, run3RightTexture], timePerFrame: 0.2)
               let runRight = SKAction.repeatForever(animation)
               
               
               //Animate
               run(runRight, completion: { self.runOnce3 = false })
               
               isFacingRight = true
               isFacingLeft = false
            
         
            
         }
      }
   }
   
   
   /************************************************
    * animateLeft:
    *       Animates the player running to the left
    *************************************************/
   func animateLeft()
   {
      if(isAlive == true)
      {
         if(hasPistol == false && hasRocketLauncher == false)
         {
            
            
               let run0LeftTexture = SKTexture(imageNamed: "newRunLeftOne.png")
               let run1LeftTexture = SKTexture(imageNamed: "newRunLeftTwo.png")
               let run2LeftTexture = SKTexture(imageNamed:"newRunLeftThree.png")
               let run3LeftTexture = SKTexture(imageNamed:"newRunLeftFour.png")
               
               let animation = SKAction.animate(with: [run0LeftTexture, run1LeftTexture, run2LeftTexture, run3LeftTexture], timePerFrame: 0.2)
               let runLeft = SKAction.repeatForever(animation)
               
               
               //Animate
               run(runLeft)
               
               isFacingRight = false
               isFacingLeft = true
           
            
         }
         
         if(hasPistol == true && hasRocketLauncher == false)
         {
           
               isRunning = true // marker so that we know hes running and shooting
               
               
               let run0LeftTexture = SKTexture(imageNamed: "newRunningPistolLeftOne.png")
               let run1LeftTexture = SKTexture(imageNamed: "newRunningPistolLeftTwo.png")
               let run2LeftTexture = SKTexture(imageNamed:"newRunningPistolLeftThree.png")
               let run3LeftTexture = SKTexture(imageNamed:"newRunningPistolLeftTwo.png")
               
               
               let animation = SKAction.animate(with: [run0LeftTexture, run1LeftTexture, run2LeftTexture, run3LeftTexture], timePerFrame: 0.2)
               let runLeft = SKAction.repeatForever(animation)
               
               
               //Animate
               run(runLeft, completion: { self.runOnce3 = false })
               
               
               isFacingRight = false
               isFacingLeft = true
           
            
         }
      }
      
      if(hasRocketLauncher == true && hasPistol == false)
      {
         
            isRunning = true // marker so that we know hes running and shooting
            
            
            let run0LeftTexture = SKTexture(imageNamed: "newRunningRocketLeftOne.png")
            let run1LeftTexture = SKTexture(imageNamed: "newRunningRocketLeftTwo.png")
            let run2LeftTexture = SKTexture(imageNamed:"newRunningRocketLeftThree.png")
            let run3LeftTexture = SKTexture(imageNamed:"newRunningRocketLeftFour.png")
            
            let animation = SKAction.animate(with: [run0LeftTexture, run1LeftTexture, run2LeftTexture, run3LeftTexture], timePerFrame: 0.2)
            let runLeft = SKAction.repeatForever(animation)
            
            
            //Animate
            run(runLeft,completion: { self.runOnce3 = false })
            
            
            isFacingRight = false
            isFacingLeft = true
        
      }
      
   }
   
   /************************************************
    * animateShooting:
    *       Animates the player shooting
    *
    * // NOTE *** B button is calling this mulitple times
    * thus, halting the animation.
    *************************************************/
   func animateShooting()
   {
      if(isAlive == true)
      {
         isFiring = true
         
         if(isRunning == false)
         {
               // dont add anything here!
         }
         
         //shoot pistol while running
         if(isRunning == true && runOnce3 == false)
         {
            //set up a flag here so that this gets called only once!!!
            runOnce3 = true
            
            if(isFacingRight)
            {
               animateRight() //shooting and running animations exsist in heres
            }
            
            if(isFacingLeft)
            {
               animateLeft()
               
            }
            
         }
         
         
         self.isFiring = false
      }
   }
   
   
   /************************************************
    * deathAnimation:
    *       Animates the player dying when gameover.
    *************************************************/
   func deathAnimation()
   {
      isAlive = false
      
      
      if(isFacingRight == true && runOnce4 == false)
      {
         //make skeleton appear behind
          let skelText = SKTexture(imageNamed: "skelRight")
         let skeleton = SKSpriteNode(texture: skelText, color: UIColor.clear, size: CGSize(width: 56.25, height: 60))
         skeleton.position.y = -45.0
         addChild(skeleton)
         
         runOnce4 = true
         let death1 = SKTexture(imageNamed: "rightDeath1")
         let death2 = SKTexture(imageNamed: "rightDeath2")
         let death3 = SKTexture(imageNamed: "rightDeath3")
         let death4 = SKTexture(imageNamed: "rightDeath4")
         let death5 = SKTexture(imageNamed: "rightDeath5")
         let death6 = SKTexture(imageNamed: "rightDeath6")
         let death7 = SKTexture(imageNamed: "rightDeath7")
         let death8 = SKTexture(imageNamed: "rightDeath8")
         let death9 = SKTexture(imageNamed: "rightDeath9")
         let death10 = SKTexture(imageNamed: "rightDeath10")
         let death11 = SKTexture(imageNamed: "rightDeath11")
         let death12 = SKTexture(imageNamed: "rightDeath12")
         let death13 = SKTexture(imageNamed: "rightDeath13")
         let death14 = SKTexture(imageNamed: "rightDeath14")
         let death15 = SKTexture(imageNamed: "rightDeath15")
         let death16 = SKTexture(imageNamed: "rightDeath16")
         let death17 = SKTexture(imageNamed: "rightDeath17")
         let death18 = SKTexture(imageNamed: "rightDeath18")
         let death19 = SKTexture(imageNamed: "rightDeath19")
         let death20 = SKTexture(imageNamed: "rightDeath20")
         let death21 = SKTexture(imageNamed: "rightDeath21")
         let death22 = SKTexture(imageNamed: "rightDeath22")
         let death23 = SKTexture(imageNamed: "rightDeath23")
         let death24 = SKTexture(imageNamed: "rightDeath24")
         let death25 = SKTexture(imageNamed: "rightDeath25")
         let death26 = SKTexture(imageNamed: "rightDeath26")
         
         let animate = SKAction.animate(with: [death1, death2, death3, death4, death5, death6, death7, death8, death9, death10,
                                               death11, death12, death13, death14, death15, death16, death17, death18, death19,
                                               death20, death21, death22, death23, death24, death25, death26], timePerFrame: 0.05)
         let animateDeath = SKAction.repeat(animate, count: 1)
         
         //Animate
         run(animateDeath, completion: {

            self.deadPool()
         })
         
      }
      
      if(isFacingLeft == true && runOnce4 == false)
      {
         //make skeleton appear behind
         let skelText = SKTexture(imageNamed: "skelLeft")
         let skeleton = SKSpriteNode(texture: skelText, color: UIColor.clear, size: CGSize(width: 56.25, height: 60)) // 75 80
         skeleton.position.y = -45.0
         addChild(skeleton)
         
         runOnce4 = true
         let death1 = SKTexture(imageNamed: "leftDeath1")
         let death2 = SKTexture(imageNamed: "leftDeath2")
         let death3 = SKTexture(imageNamed: "leftDeath3")
         let death4 = SKTexture(imageNamed: "leftDeath4")
         let death5 = SKTexture(imageNamed: "leftDeath5")
         let death6 = SKTexture(imageNamed: "leftDeath6")
         let death7 = SKTexture(imageNamed: "leftDeath7")
         let death8 = SKTexture(imageNamed: "leftDeath8")
         let death9 = SKTexture(imageNamed: "leftDeath9")
         let death10 = SKTexture(imageNamed: "leftDeath10")
         let death11 = SKTexture(imageNamed: "leftDeath11")
         let death12 = SKTexture(imageNamed: "leftDeath12")
         let death13 = SKTexture(imageNamed: "leftDeath13")
         let death14 = SKTexture(imageNamed: "leftDeath14")
         let death15 = SKTexture(imageNamed: "leftDeath15")
         let death16 = SKTexture(imageNamed: "leftDeath16")
         let death17 = SKTexture(imageNamed: "leftDeath17")
         let death18 = SKTexture(imageNamed: "leftDeath18")
         let death19 = SKTexture(imageNamed: "leftDeath19")
         let death20 = SKTexture(imageNamed: "leftDeath20")
         let death21 = SKTexture(imageNamed: "leftDeath21")
         let death22 = SKTexture(imageNamed: "leftDeath22")
         let death23 = SKTexture(imageNamed: "leftDeath23")
         let death24 = SKTexture(imageNamed: "leftDeath24")
         let death25 = SKTexture(imageNamed: "leftDeath25")
         let death26 = SKTexture(imageNamed: "leftDeath26")
         
         let animate = SKAction.animate(with: [death1, death2, death3, death4, death5, death6, death7, death8, death9, death10,
                                               death11, death12, death13, death14, death15, death16, death17, death18, death19,
                                               death20, death21, death22, death23, death24, death25, death26], timePerFrame: 0.05)
         let animateDeath = SKAction.repeat(animate, count: 1)
         
         //Animate
         run(animateDeath, completion: {
           self.deadPool()
            
         })

      }

   }
   
   /************************************************
    * deadPool:
    *       final still of dead player
    *************************************************/
   func deadPool()
   {
      
      if(isFacingRight)
      {
         let deadPool = SKTexture(imageNamed: "rightDeath26")
         
         let animation = SKAction.animate(with: [deadPool], timePerFrame: 0.3)
         
         let runAni = SKAction.repeatForever(animation)
         
         //reset to false to go back to standing.
         run(runAni, completion:{ })

      }
      
      if(isFacingLeft)
      {
         let deadPool = SKTexture(imageNamed: "leftDeath26")
         
         let animation = SKAction.animate(with: [deadPool], timePerFrame: 0.3)
         
         let runAni = SKAction.repeatForever(animation)
         
         //reset to false to go back to standing.
         run(runAni, completion:{ })
         
      }
   
   }
   
   /************************************************
    * displayJumpingAnimation:
    *       This function is called when the player is
    * in the air and plays the correct animation for
    * jumping.
    *************************************************/
   func displayJumpingAnimation()
   {
      //PLAYER IS IN THE AIR
      if(!playerIsTouchingGround)
      {
        
         
        
         if(isPlayerFacingLeft()) //left
         {
            if(playerHasPistol())
            {
               
               self.texture = SKTexture(imageNamed: "jumpingWithPistolLeft.png")
            }
            else if(hasRocketLauncher)
            {
               self.texture = SKTexture(imageNamed: "jumpingWithRocketLeft.png")
            }
            else // player has nothing
            {
               self.texture = SKTexture(imageNamed: "jumpingEmptyLeft.png")
            }
         }
         else //right
         {
            if(playerHasPistol())
            {
               self.texture = SKTexture(imageNamed: "jumpingWithPistolRight.png")
            }
            else if(hasRocketLauncher)
            {
               self.texture = SKTexture(imageNamed: "jumpingWithRocketRight.png")
            }
            else // player has nothing
            {
               self.texture = SKTexture(imageNamed: "jumpingEmptyRight.png")
            }
         }
      }
     
   }
   
   func playerHit(damage: Int)
   {
      hitPoints -= damage
   }
   
   /************************************************
    * removeRunningActions:
    *       This function is used to stop the players
    * running animation for other things like jumping
    *************************************************/
   func removeRunningActions()
   {
      self.removeAllActions()
   }
   
   
   func playFootSteps()
   {
      SKAction.run
      {
         SKAction.playSoundFileNamed("Footstep.mp3",
                                     waitForCompletion: false)
      }
   }
   

   
   // **** GETTERS ****
   func getPosistion() -> CGFloat
   {
      return self.position.x
   }
   
   func playerIsFiring() -> Bool
   {
      return isFiring
   }
   
   func playerHasPistol() -> Bool
   {
      return hasPistol
   }
   
   
   func isPlayerFacingLeft() -> Bool
   {
      return isFacingLeft
   }
   
   func isPlayerFacingRight() -> Bool
   {
      return isFacingRight
   }
   
   func getHitPoints() -> Int
   {
      return hitPoints
   }
   
   
   // setters
   func setIsFiring(firing: Bool)
   {
      isFiring = firing
   }
   
   // GUNS THAT YOU HAVE
   func setHasPistol(gotPistol: Bool)
   {
      hasPistol = gotPistol
      
   }
   
   func setHasLauncher(gotLauncher: Bool)
   {
      hasRocketLauncher = gotLauncher
     

   }
   
   func setHitPoints(setHP: Int)
   {
      hitPoints = setHP
   }
   
   func setTexture(skin: String)
   {
      self.texture = SKTexture(imageNamed: skin)
   }
   
   
   
   //throw warning...
   required init?(coder aDecoder: NSCoder)
   {
      fatalError("init(coder:) has not been implemented")
   }
   
}


