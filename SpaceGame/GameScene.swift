//
//  GameScene.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/18/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation // audio
import AudioToolbox // make phone vibrate when hit



class GameScene: SKScene, SKPhysicsContactDelegate
{
   // *** SETTING UP COLLION DECTETION ***
   
   let playerCategory   : UInt32 = 0x1 << 0
   let pickupCategory   : UInt32 = 0x1 << 1
   let bulletCategory   : UInt32 = 0x1 << 2
   let objectCategory   : UInt32 = 0x1 << 3
   let enemyCategory    : UInt32 = 0x1 << 4
   let deadCategory     : UInt32 = 0x1 << 5
   let wallCategory     : UInt32 = 0x1 << 6
   let explosionCategory: UInt32 = 0x1 << 7

   
   
   // ###### MACROS ######
   
   var gameOver = false
   
   let PUSH_BACK_DISTANCE_RIGHT:CGFloat = 100  // when the player gets knock how far things move
   let PUSH_BACK_DISTANCE_LEFT:CGFloat  = 100
   
   let NORMAL_DISTANCE_RIGHT:CGFloat = 5      // the movement of other things when the player moves
   let NORMAL_DISTANCE_LEFT:CGFloat  = 5
   
   let CHANCE_FOR_PICKUP:UInt32 = 3 // Chance of enemy droping an item
   var RANDOM_ITEM :UInt32 = 6 // what random item will drop form dead enemy
   
   var CURRENT_LEVEL = 1 // current level we are playing on
   
   var ENEMY_SPAWN_RATE = 150 // rate at which enemies appear (lower is more frwq)
   
   var CURRENT_WEAPON = 1 // current weapon held by the player
   var NUM_OF_WEAPONS = 0 // number of weapons the player has collected
   
   var MAX_NUM_OF_TREES = 100
   
   var HAS_SHIP_PART = false // if the player has the ship part, they can return and finish level
   var PLAYER_HAS_FINISHED_LEVEL = false // player has met the requirements to move on to the next level
   
   var JUMP_BUTTON_IS_PRESSED = false // informs the game that the user is holding down the jumpbutton
   
   // *** AMMO FOR WEAPONS ***
   var STARTING_PISTOL_AMMO = 0
   var STARTING_LAUNCHER_AMMO = 0
   var STARTING_GRANADE_AMMO = 0
   // lables
   var pistolAmmoLabel = SKLabelNode(text: "0")
   var launcherAmmoLabel = SKLabelNode(text: "0")
   var granadeAmmoLabel = SKLabelNode(text: "0")
   
   //pointers to refernce the buttons
   var pistolPointer: Button? = nil
   var LauncherPointer: Button? = nil
   var granadePointer: Button? = nil
   
   
   
   
   
   //notify the game when a gun is pickup
   var pickedupPistol = false
   var pickedupLauncher = false
   var pickedupGranade = true // player now starts off with grenades
 
   
   //vibrates phone when taking damage
   let rumble =  SKAction.run {
      (AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)))
   }
   
   
   //movement conditions
   var jump    = false
   var canJump = true
   var justLanded = false
   
   var isRunningLeft  = false
   var isRunningRight = false
   
   var runOnce  = false
   var runOnce2 = false
   
   
   //Enemy contact obs
   var enemyInRange = false
   

   
   let retryButton = Button(defaultButtonImage: "RestartButton.png", activeButtonImage: "RestartButton.png", buttonAction: {})
   
   
   // movement buttons
   let leftMovementbutton  = Button(defaultButtonImage: "LeftArrow.png", activeButtonImage: "LeftArrow.png",   buttonAction:{})
   let rightMovementbutton  = Button(defaultButtonImage: "RightArrowFix.png", activeButtonImage: "RightArrowFix.png",   buttonAction:{})

   let jumpButton = Button(defaultButtonImage: "B.png", activeButtonImage: "B.png", buttonAction:{})
   
   
   
   //health bar
   let healthBar = HealthBar()
   
   //pause button
   var gamePaused = false
   let pauseLabel = Object(color: UIColor.clear, size: CGSize(width: 200,height: 100), posistion: CGPoint(x: 0, y: 150))
   
   //Dims the screen when paused.
   let dimPanel = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 0, height: 0))
   
   
   
   

   //objects
   let player = Player(color: UIColor.clear, size: CGSize(width: 75, height: 75)) // 100, 100
//   let background = Background(color: UIColor.clear, size: CGSize(width: 2000, height: 700)) // 800
//   let backgroundSecond = Background(color: UIColor.clear, size: CGSize(width: 2000, height: 700))
   
   
   let background = Background(color: UIColor.clear, size: CGSize(width: 4000, height: 850)) // 800
   let backgroundSecond = Background(color: UIColor.clear, size: CGSize(width: 4000, height: 850))
   let ground = Ground()
   
  
   
   // init weapons.
   let pistol = Pistol()
   let launcher = Launcher()
   
   
   //*** Setting up audio ***
   var audioplayer: AVAudioPlayer = AVAudioPlayer()
   var SFXPlayer:   AVAudioPlayer = AVAudioPlayer()
   
   // *** sound lib ***
   var laserSound = SKAction.playSoundFileNamed("Laser", waitForCompletion: true)
   var footStepSound = SKAction.playSoundFileNamed("Footstep", waitForCompletion: true)
   var minionSound = SKAction.playSoundFileNamed("Minion voice", waitForCompletion: true)
   var hitSound = SKAction.playSoundFileNamed("Hit", waitForCompletion: true)
   
   
   
   //collections
   var bulletList: NSMutableArray = []
   var enemyList:  NSMutableArray = []
   var pickupList: NSMutableArray = []
   var objectList: NSMutableArray = []
   var nonRemoveObjectList: NSMutableArray = []
   
   
   
   /************************************************
    * didMove:
    *    Loads the scence and init's all objects.
    *************************************************/
    override func didMove(to view: SKView)
    {
      
      scene?.scaleMode = .aspectFit
//      scene?.setScale(CGFloat())
      //      scene?.xScale /= 5
//      scene?.yScale /= 5
      
//      scene?.anchorPoint = CGPoinst(x: 0, y: 0)
      //setting up scene here...
      self.physicsWorld.contactDelegate = self
      
      dimPanel.size = self.size
      dimPanel.alpha = 0.65
      dimPanel.zPosition = 2
      dimPanel.position = CGPoint(x: 0, y: 0)
      
      // OTHER BUTTON SETUP
      rightMovementbutton.xScale /= 3.5
      rightMovementbutton.yScale /= 2.8 //1.5

      leftMovementbutton.xScale /= 3.5
      leftMovementbutton.yScale /= 2.8
      
      jumpButton.xScale /= 4.8
      jumpButton.yScale /= 4.8
      
      

      retryButton.xScale /= 2
      retryButton.yScale /= 2
     
      
      
      // *** LOAD LEVEL ***
      levelInit(levelSelect: CURRENT_LEVEL)
      
      //add swipe guestures
      let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
//      let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
      swipeLeft.direction = .left
      view.addGestureRecognizer(swipeLeft)
      
      let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
//      let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
      swipeRight.direction = .right
      view.addGestureRecognizer(swipeRight)
      
      
//      displayText(text: "THIS IS A TEST")
     
      
     // createEnemies()
      
   }
   
    
   
   
   /************************************************
    * update:
    *     updates the scence 60 times a second.
   *************************************************/
    override func update(_ currentTime: TimeInterval)
    {
      // *** Called before each frame is rendered (60 per sec)***

         // RUN GAME
         if(player.getHitPoints() > 0 && player.isAlive)
         {
            
            //generate enemies
//            createEnemies()
            
            // remove trees
            cleanupTrees()
            
            //Player movement Left
            playerLeftMovement()
            
            //PLayer movement Right
            playerRightMovement()
            
            playerJumpMovement()
            
            //reset animation to standing
            playerAnimationReset()
            
            advanceBullets()
            
            // enemy movement AI
            advanceEnemies()
            

            //clean up any remaining bullets
            bulletCleanup(killNow: false)
            
         
         }
            
         // GAME OVER YOU ARE DEAD
         else //if(player.isAlive == false && player.getHitPoints() <= 0)
         {
            //no colliosion when player is dying
            player.physicsBody!.categoryBitMask = deadCategory
            player.physicsBody?.contactTestBitMask = objectCategory
            player.physicsBody?.collisionBitMask = objectCategory
            
            
            advanceBullets()
            advanceEnemies()
            
            
            let deathSLQ = SKAction.run({
               
               self.player.deathAnimation()
            })
            
            run(deathSLQ, completion:
               {
                  self.retryButton.isHidden = false
                  
                  self.retry(levelSelect: 1)
                  self.displayText(text: "GAMEOVER")
            })
            
            
         }
        
         // CONGRATS YOU WIN!!
         if(player.isAlive && player.getHitPoints() > 0 && PLAYER_HAS_FINISHED_LEVEL)
         {
            self.displayText(text: "MISSION SUCCESSFUL!")
            self.retryButton.isHidden = false
            
            //move to the next level
            self.retry(levelSelect: 1)
         }
      
      
      

      
   }
   
   
   /************************************************
    * didBegin:
    *    This function handls our collition dection
    *************************************************/
   func didBegin(_ contact: SKPhysicsContact)
   {
      
      let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
      
      
      switch contactMask
      {
      // pick up objects dection
      case pickupCategory | playerCategory:
         
         let pickupObject: PickupObject = (contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! as! PickupObject : contact.bodyB.node! as! PickupObject)

         // switching on the type of object that you picked up!
         switch pickupObject.pickupObjectType
         {
            // healthPack
         case 1:
            
            switch pickupObject.pickupType
            {
               //healthpack
            case 1:
               
               if(player.getHitPoints() < player.maxHealth)
               {
                  displayText(text: "+1 Health")
                  player.setHitPoints(setHP: player.getHitPoints() + 1)
                  healthBar.setHealthBarPoints(points: player.getHitPoints())
               }
               
               let healthPack: HealthPack = (contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! as! HealthPack : contact.bodyB.node! as! HealthPack)
               pickupList.remove(healthPack)
               healthPack.removeFromParent()
               
               break
               
               //pistol ammo
            case 2:
               
               let pistolAmmo: PistolAmmo = (contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! as! PistolAmmo : contact.bodyB.node! as! PistolAmmo)
              
               displayText(text: "+\(pistolAmmo.ammo) Pistol ammo")
               
               //add ammo
               STARTING_PISTOL_AMMO += pistolAmmo.ammo
               pistolAmmoLabel.text = String(Int(pistolAmmoLabel.text!)! + pistolAmmo.ammo)
               
               //remove obj
               pickupList.remove(pistolAmmo)
               pistolAmmo.removeFromParent()
               
               break
            //Rocket ammo
            case 3:
               
               let rocketAmmo: RocketAmmo = (contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! as! RocketAmmo : contact.bodyB.node! as! RocketAmmo)
               
               displayText(text: "+\(rocketAmmo.ammo) Rocket ammo")
               
               //add ammo
               STARTING_LAUNCHER_AMMO += rocketAmmo.ammo
               launcherAmmoLabel.text = String(Int(launcherAmmoLabel.text!)! + rocketAmmo.ammo)
               
               //remove obj
               pickupList.remove(rocketAmmo)
               rocketAmmo.removeFromParent()
               
               break
               
            //Granade ammo
            case 4:
               
               let granadeAmmo: GranadeAmmo = (contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! as! GranadeAmmo : contact.bodyB.node! as! GranadeAmmo)
               
               displayText(text: "+\(granadeAmmo.ammo) Grenade  ammo")
               
               //add ammo
               STARTING_GRANADE_AMMO += granadeAmmo.ammo
               granadeAmmoLabel.text = String(Int(granadeAmmoLabel.text!)! + granadeAmmo.ammo)
               
               //remove obj
               pickupList.remove(granadeAmmo)
               granadeAmmo.removeFromParent()
               
               break


            
            

            default:
               break
            }
            
            // *** PICKING UP GUN ****
         case 2:
            
            switch pickupObject.weaponType
            {
               //picked up a pistol
            case 1:
               pickedupPistol = true
               STARTING_PISTOL_AMMO += 48
               NUM_OF_WEAPONS += 1
               CURRENT_WEAPON = 1
               displayText(text: "Picked up Pistol")
               player.setHasPistol(gotPistol: true)
               player.setHasLauncher(gotLauncher: false)
               let pistol = contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! : contact.bodyB.node!
               pickupList.remove(pistol)
               self.pistolAmmoLabel.text = String(self.STARTING_PISTOL_AMMO)
               pistol.removeFromParent()
               player.justGotGun = true
               //add button
               addChild(pistolPointer!)
               addChild(pistolAmmoLabel)
               self.pistolPointer?.setIcon(icon: "pistolSelected")
               self.LauncherPointer?.setIcon(icon: "launcherNotSelected")
               self.granadePointer?.setIcon(icon: "granadeNotSelected.png")
               break
               
               //picked rocket launcher
            case 2:
               RANDOM_ITEM = 10
               pickedupLauncher = true
               STARTING_LAUNCHER_AMMO += 4
               CURRENT_WEAPON = 2
               NUM_OF_WEAPONS += 1
               displayText(text: "Picked up Rocket Launcher")
               player.setHasLauncher(gotLauncher: true)
               player.setHasPistol(gotPistol: false)
               let launcher = contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! : contact.bodyB.node!
               pickupList.remove(launcher)
               launcher.removeFromParent()
               player.justGotGun = true // reste animation
               self.launcherAmmoLabel.text = String(self.STARTING_LAUNCHER_AMMO)
               //add button
               addChild(LauncherPointer!)
               addChild(launcherAmmoLabel) // add ammo counter
               self.LauncherPointer?.setIcon(icon: "launcherSelected")
               self.pistolPointer?.setIcon(icon: "pistolNotSelected")
               self.granadePointer?.setIcon(icon: "granadeNotSelected.png")
               break
               
               //picked up granades
            case 3:
               RANDOM_ITEM = 8
               pickedupGranade = true
               STARTING_GRANADE_AMMO += 6
//               CURRENT_WEAPON = 3
//               NUM_OF_WEAPONS += 1
               displayText(text: "Picked up Granade")
//               player.hasGranades = true
//               player.setHasLauncher(gotLauncher: false)
//               player.setHasPistol(gotPistol: false)
               let granade = contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! : contact.bodyB.node!
               pickupList.remove(granade)
               granade.removeFromParent()
//               player.justGotGun = true // reste animation
               self.granadeAmmoLabel.text = String(self.STARTING_GRANADE_AMMO)
               //add icon
//               addChild(granadePointer!)
               
//               addChild(granadeAmmoLabel) // add ammo counter
//               self.granadePointer?.setIcon(icon: "granadeSelected.png")
//               self.pistolPointer?.setIcon(icon: "pistolNotSelected")
//               self.LauncherPointer?.setIcon(icon: "launcherNotSelected")
               break

               
               
            default:
               break
            }
            
            //PICKED UP SHIP PART
           case 3:
            displayText(text: "Return to Ship!")
            HAS_SHIP_PART = true
            displayLabel(text: "Acquired", position: CGPoint(x: 260, y: 150))
            let partIcon = shipPart()
            partIcon.position = CGPoint(x: 340, y: 155)
            partIcon.physicsBody?.isDynamic = false
            partIcon.zPosition = 10
            partIcon.xScale /= 2
            partIcon.yScale /= 2
            addChild(partIcon)
            
            let shipParts: shipPart = (contact.bodyA.categoryBitMask == pickupCategory ? contact.bodyA.node! as! shipPart : contact.bodyB.node! as! shipPart)
            pickupList.remove(shipParts)
            shipParts.removeFromParent()

            // RETUNRING PART TO SHIP
            case 4:
               if(HAS_SHIP_PART == true)
               {
                 
                  PLAYER_HAS_FINISHED_LEVEL = true
               }
               else
               {
                  displayText(text: "Find the Ship Part!")
               }
            
         default:
            break
         }
         
        
         
        
         
      //contact between a bullet and world objs
      case objectCategory | bulletCategory:
         
         //delete bullet
         let bullet: Bullet = (contact.bodyA.categoryBitMask == bulletCategory ? contact.bodyA.node! as! Bullet : contact.bodyB.node! as! Bullet)
         
         if(!bullet.isARocket)
         {
            let explosionSLQ = SKAction.run({
               
               bullet.bulletExlopsion()
            })
            
            run(explosionSLQ, completion:
               {
                  
            })
         }
         // iF IS A ROCKET MAKE AN EXPLOSION!
         if(bullet.isARocket)
         {
            let rocketExplotion = RocketExplotion(skin: "", damage: 75)
            let codeBlock = SKAction.run({
               
               // Create explotion!
               rocketExplotion.position = bullet.position
               self.objectList.add(rocketExplotion)
               self.addChild(rocketExplotion)
               rocketExplotion.physicsBody?.categoryBitMask = self.explosionCategory
               rocketExplotion.physicsBody?.contactTestBitMask = self.enemyCategory | self.objectCategory
               rocketExplotion.physicsBody?.collisionBitMask =  self.objectCategory
               rocketExplotion.explosion()
               
               
            })
            let finishedBlock = SKAction.run({
               rocketExplotion.removeFromParent()
               self.objectList.remove(rocketExplotion)
            })
            
            let sequence = SKAction.sequence([codeBlock, SKAction.wait(forDuration: 0.3), finishedBlock])
            
            self.run(sequence)
            bullet.bulletLifeTime = 0
         }
         
        
         
      // *** ENEMY HITS PLAYER ***
      case playerCategory | enemyCategory:
         
         run(hitSound)
          let enemy: Enemy = (contact.bodyA.categoryBitMask == enemyCategory ? contact.bodyA.node! as! Enemy: contact.bodyB.node! as! SKSpriteNode as! Enemy)
         
         enemy.isInContact = true
         //do damamge
         self.player.setHitPoints(setHP: self.player.getHitPoints() - enemy.damageAmount)
         self.healthBar.setHealthBarPoints(points: self.player.getHitPoints())
         
         //knock back
         self.player.knockBack()
         
         //make phone vibrate
         self.run(self.rumble)
      
      // *** ENEMY HITS BULLET ***
      case enemyCategory | bulletCategory:
        
         let bullet: Bullet = (contact.bodyA.categoryBitMask == bulletCategory ? contact.bodyA.node! as! Bullet : contact.bodyB.node! as! Bullet)
         
         let enemy: Enemy = (contact.bodyA.categoryBitMask == enemyCategory ? contact.bodyA.node! as! Enemy: contact.bodyB.node! as! SKSpriteNode as! Enemy)
         enemy.setHitPoints(setPoints: enemy.getHitPoints() - bullet.bulletDamage)
         
         
         //if no health, get rid of enemy
         if(enemy.getHitPoints() <= 0)
         {
            enemy.physicsBody!.categoryBitMask = deadCategory
            enemy.physicsBody?.contactTestBitMask = objectCategory
            enemy.physicsBody?.collisionBitMask = objectCategory
          
            let codeBlock = SKAction.run({
               
               enemy.isAlive = false
               enemy.deathAnimation()
               self.createPickupObject(spawnPoint: enemy.position)

            })
           let finishedBlock = SKAction.run({
             self.cleanupEnemies(incDamage: 0)
           })
            
            
            let sequence = SKAction.sequence([codeBlock, SKAction.wait(forDuration: 0.3), finishedBlock])
            
            self.run(sequence)
            
      
         }
         
         //clean up bullet that hit enemy
        
         if(!bullet.isARocket)
         {
            let explosionSLQ = SKAction.run({
               
               bullet.bulletExlopsion()
            })
            
            run(explosionSLQ, completion:
               {
                  
                  
            })
         }
         //IF BULLET IS A ROCKET MAKE AN EXPLOSOON!
         if(bullet.isARocket)
         {
            
            let rocketExplotion = RocketExplotion(skin: "", damage: 75)
            let codeBlock = SKAction.run({
               
               if(bullet.wasFiredLeft)
               {
                  rocketExplotion.wasFiredLeft = true
               }
               
               // Create explotion!
               rocketExplotion.position = bullet.position
               self.objectList.add(rocketExplotion)
               self.addChild(rocketExplotion)
               rocketExplotion.physicsBody?.categoryBitMask = self.explosionCategory
               rocketExplotion.physicsBody?.contactTestBitMask = self.enemyCategory | self.objectCategory
               rocketExplotion.physicsBody?.collisionBitMask =  self.objectCategory
               rocketExplotion.explosion()
               
               
            })
            let finishedBlock = SKAction.run({
               rocketExplotion.removeFromParent()
               self.objectList.remove(rocketExplotion)
            })
            
            let sequence = SKAction.sequence([codeBlock, SKAction.wait(forDuration: 0.3), finishedBlock])
            
            self.run(sequence)
            bullet.bulletLifeTime = 0
         }

         
      
      // *** ENEMY IS HIT BY AN EXPLOSION ***
      case enemyCategory | explosionCategory:
         
         let explodingObj: Object = (contact.bodyA.categoryBitMask == explosionCategory ? contact.bodyA.node! as! Object : contact.bodyB.node! as! Object)
         
         let enemy: Enemy = (contact.bodyA.categoryBitMask == enemyCategory ? contact.bodyA.node! as! Enemy: contact.bodyB.node! as! SKSpriteNode as! Enemy)
         enemy.setHitPoints(setPoints: enemy.getHitPoints() - explodingObj.explosionDamage)
         
         
         //if no health, get rid of enemy
         if(enemy.getHitPoints() <= 0)
         {
            // DEATH SEQUENCE 
            enemy.physicsBody!.categoryBitMask = deadCategory
            enemy.physicsBody?.contactTestBitMask = objectCategory
            enemy.physicsBody?.collisionBitMask = objectCategory
            
            let codeBlock = SKAction.run({
               
               enemy.isAlive = false
               enemy.deathAnimation()
               self.createPickupObject(spawnPoint: enemy.position)
               
            })
            let finishedBlock = SKAction.run({
               self.cleanupEnemies(incDamage: 0)
            })
            
            
            let sequence = SKAction.sequence([codeBlock, SKAction.wait(forDuration: 0.3), finishedBlock])
            
            self.run(sequence)
            
            
         }
         
       // FOR JUMPING RULES
      // if player is in contact with the ground or world obj
      case objectCategory | playerCategory:
         
         //needed for reseting jump timer
         canJump = true
         justLanded = true
        
         
      default:
         break
      }
      
   
   }
   
   
   /************************************************
    * didEnd:
    *    This function handls detection of two objects
    * ending contact.
    *************************************************/
   func didEnd(_ contact: SKPhysicsContact)
   {
      
      let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
      
      
      switch contactMask
      {
      // cant jump if lost contact with ground or world obj
      case objectCategory | playerCategory:
          canJump = false
          justLanded = false
         
         
   
      case playerCategory | enemyCategory:
         //enemy no longer in range
         let enemy: Enemy = (contact.bodyA.categoryBitMask == enemyCategory ? contact.bodyA.node! as! Enemy: contact.bodyB.node! as! SKSpriteNode as! Enemy)
         
         enemy.isInContact = false
         
      default:
         break
         
      }
   }

   
   
   
   /************************************************
    * createBackground:
    *    Generates a new background.
    *************************************************/
   func createNewBackground()
   {
      let background = Background(color: UIColor.clear, size: CGSize(width: 800, height: 800))
      background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
      background.zPosition = -1
      self.addChild(background)
      
   }
   
   
   /************************************************
    * displayText:
    *     Lets you display a message on the screen
    *************************************************/
   func displayText(text: String)
   {
      let messageDisplay = SKLabelNode()
      
      messageDisplay.fontColor = UIColor.yellow
      messageDisplay.fontName = "Helvetica"
      messageDisplay.fontSize = 30
      messageDisplay.text = text
      messageDisplay.zPosition = 10
      messageDisplay.position = CGPoint(x: self.frame.midX, y: 145)
      
      self.addChild(messageDisplay)
      let fadeAction = SKAction.fadeAlpha(to: 0, duration: 2.0)
     
      //upon completetion delete the label from memory
      messageDisplay.run(fadeAction)
      {
         messageDisplay.removeFromParent()
      }
     
   }
   
   /************************************************
    * displayLabel:
    *     Lets you display a label on the screen
    *************************************************/
   func displayLabel(text: String, position: CGPoint)
   {
      let label = SKLabelNode()
      label.fontColor = UIColor.green
      label.fontName = "Helvetica"
      label.fontSize = 25
      label.text = text
      label.zPosition = 10
      label.position = position //CGPoint(x: self.frame.midX, y: 150)

      self.addChild(label)
      
   }
   
   
   
   
   
   // ****************************
   //
   //       MOVEMENT LOGIC
   //
   //    *******************
   //
   //
   // ****************************
   
   
   
   /************************************************
    * playerLeftMovement:
    *    This function has all the logic to move the
    * player left.
    *************************************************/
   func playerLeftMovement()
   {
      
      
      
      //Player movement Left
      if(leftMovementbutton.buttonPressed == true && rightMovementbutton.buttonPressed == false)
      {
      //generate trees while player is moving
         createTrees()
         
         isRunningLeft = true
         isRunningRight = false
         runOnce2 = false
         player.isRunning = true
         player.isFacingLeft = true
         player.isFacingRight = false

         // animate only if its the first time and the player isnt in the middle of shooting and is landed
         if((isRunningLeft == true && runOnce == false && player.playerIsFiring() == false && canJump) || player.justGotGun == true || justLanded == true)
         {
            print("animate left triggered")
            player.justGotGun = false
            player.animateLeft()
            runOnce = true
            justLanded = false

         }

         
         //move the background instead of the player if hes beyond a certain point on the screen
         if(player.position.x < -10)
         {
           
            moveBackground(direction: "left", isBeingKocked: false)
            moveObject(direction: "left", isBeingKocked: false)
            moveFromEnemy(direction: "left", isBeingKocked: false)
            
        
            
            //stich new background
            backgroundStiching(direction: "left")
         }
            
         else
         {
            //move player
            player.moveLeft()
           
         }
         
      }

   }
   
   
   
   /************************************************
    * playerRightMovement:
    *    This function has all the logic to move the 
    * player right.
    *************************************************/
   func playerRightMovement()
   {
      
      
      if(rightMovementbutton.buttonPressed == true && leftMovementbutton.buttonPressed == false)
      {
         //generate trees while player is moving
         createTrees()
         
         isRunningLeft = false
         isRunningRight = true
         runOnce = false
         player.isRunning = true
         
         player.isFacingRight = true
         player.isFacingLeft = false
         
         // animate only if its the first time and the player isnt in the middle of shooting and is landed
         if((isRunningRight == true && runOnce2 == false && player.playerIsFiring() == false && canJump) || player.justGotGun == true || justLanded == true)
         {
            
            print("animate right triggered")
            player.justGotGun = false
            player.animateRight()
            runOnce2 = true
            justLanded = false
            
         }

         
         //move the background instead of the player if hes beyond a certain point on the screen
         if(player.position.x > 10)
         {
            
            moveBackground(direction: "right", isBeingKocked: false)
            moveObject(direction: "right", isBeingKocked: false)
            moveFromEnemy(direction: "right", isBeingKocked: false)
            
            //stich new background
            backgroundStiching(direction: "right")
            
         }
         else
         {
            //move player
            player.moveRight()
            
         }
         
      }

   }
   
   
   /************************************************
    * playerJumpMovement:
    *    This function lets the player jump
    *************************************************/
   func playerJumpMovement()
   {
      if(jumpButton.buttonPressed == true)
      {
         
         player.playerIsTouchingGround = false
         
         if(!player.runningActionsHaveBeenRemovedOnce)
         {
            player.removeRunningActions()
            player.runningActionsHaveBeenRemovedOnce = true
         }
        
         player.displayJumpingAnimation()
         player.jump()
      }
      // reset timer
      else if(jumpButton.buttonPressed == false && canJump == true)
      {
         player.runningActionsHaveBeenRemovedOnce = false

         player.playerIsTouchingGround = true
         
         player.airTime = 15 // reset time allowed in air
      }
      
      
      
   }
   
   
   /************************************************
    * playerAnimationReset:
    *    This function resets the player to idle when
    * the player is not moving
    *************************************************/
   func playerAnimationReset()
   {
      
      if(rightMovementbutton.buttonPressed == false && leftMovementbutton.buttonPressed == false
         && player.playerIsFiring() == false && canJump)
      {
         
         self.player.isRunning = false
         player.finishedMoving()
//         player.animationResetHasBeenCalledOnce = true
         
      }
//      else if(rightMovementbutton.buttonPressed == false && leftMovementbutton.buttonPressed == false
//         && player.playerIsFiring() == false && !player.playerIsTouchingGround)
//      {
//         self.player.isRunning = false
//         player.displayJumpingAnimation()
//      }

   }
   
   
   
   
   
   /************************************************
    * moveBackground:
    *    This function moves the background along the
    * scence to simulate the player moving
    *************************************************/
   func moveBackground(direction: String, isBeingKocked: Bool)
   {
      if(isBeingKocked == false)
      {
         if(direction == "left")
         {
            background.position.x       += NORMAL_DISTANCE_LEFT
            backgroundSecond.position.x += NORMAL_DISTANCE_LEFT
         }
         if(direction == "right")
         {
            background.position.x       -= NORMAL_DISTANCE_RIGHT
            backgroundSecond.position.x -= NORMAL_DISTANCE_RIGHT
         }
      }
      
      if(isBeingKocked == true)
      {
         if(direction == "left")
         {
            background.position.x       += PUSH_BACK_DISTANCE_LEFT
            backgroundSecond.position.x += PUSH_BACK_DISTANCE_LEFT
         }
         if(direction == "right")
         {
            background.position.x       -= PUSH_BACK_DISTANCE_RIGHT
            backgroundSecond.position.x -= PUSH_BACK_DISTANCE_RIGHT
         }
      }

      
   
   }
   
   /************************************************
    * backgroundStiching:
    *    This function stiches a new part of the
    * background the current one to simuate an endless
    * area.
    *************************************************/
   func backgroundStiching(direction: String)
   {
      
      if(direction == "left")
      {
         if(background.position.x > background.size.width)
         {
            //stiching left
            background.position = CGPoint(x: backgroundSecond.position.x - backgroundSecond.size.width, y: background.position.y)
         }
         
         if(backgroundSecond.position.x > backgroundSecond.size.width)
         {
            backgroundSecond.position = CGPoint(x: background.position.x - background.size.width, y: backgroundSecond.position.y)
         }

      }
      if(direction == "right")
      {
         if(background.position.x < -background.size.width)
         {
           //stiching right
            background.position = CGPoint(x: backgroundSecond.position.x + backgroundSecond.size.width, y: background.position.y)
         }
         
         if(backgroundSecond.position.x < -backgroundSecond.size.width)
         {
            backgroundSecond.position = CGPoint(x: background.position.x + background.size.width, y: backgroundSecond.position.y)
         }
      }
      
      
   }
   
   
   
   /************************************************
    * moveObject:
    *    This function moves an object in the scence to
    * simuate the player moving towards it or away.
    *************************************************/
   func moveObject(direction: String, isBeingKocked: Bool)
   {
      // NEEDS WORK< MUST BE DYNAMIC!!!  an arry of objs? DONE FOR PICKUP OBJS
      if (isBeingKocked == false)
      {
         if(direction == "left")
         {
            for object in objectList
            {
               (object as! Object).position.x += NORMAL_DISTANCE_LEFT
            }
            for pickupobject in pickupList
            {
               (pickupobject as! PickupObject).position.x += NORMAL_DISTANCE_LEFT

            }
            
            for object in nonRemoveObjectList
            {
               (object as! Object).position.x += NORMAL_DISTANCE_LEFT
            }
            
         }
         if(direction == "right")
         {
            for object in objectList
            {
               
               (object as! Object).position.x -= NORMAL_DISTANCE_RIGHT
            }

            for pickupobject in pickupList
            {
               (pickupobject as! PickupObject).position.x -= NORMAL_DISTANCE_RIGHT
               
            }
            
            for object in nonRemoveObjectList
            {
               (object as! Object).position.x -= NORMAL_DISTANCE_RIGHT
            }

         }
      }
      
      if(isBeingKocked == true)
      {
         if(direction == "left")
         {
            //pipe.position.x   += PUSH_BACK_DISTANCE_LEFT
            for pickupobject in pickupList
            {
               (pickupobject as! PickupObject).position.x += PUSH_BACK_DISTANCE_LEFT
               
            }
         }
         if(direction == "right")
         {
            //pipe.position.x   -= PUSH_BACK_DISTANCE_RIGHT
            for pickupobject in pickupList
            {
               (pickupobject as! PickupObject).position.x -= PUSH_BACK_DISTANCE_RIGHT
               
            }
         }
      }
   }
   
   
   
   
   /************************************************
    * moveFromEnemy:
    *    This function lets you move closer or away
    * from an enemy charater.
    *************************************************/
   func moveFromEnemy(direction: String, isBeingKocked: Bool)
   {
      for enemy in enemyList
      {
         if(isBeingKocked == false)
         {
            if(direction == "left")
            {
               (enemy as! Enemy).resetPosistion(newPosistion: NORMAL_DISTANCE_LEFT)
            }
            if(direction == "right")
            {
               (enemy as! Enemy).resetPosistion(newPosistion: -NORMAL_DISTANCE_RIGHT)
            }
         }
         if(isBeingKocked == true)
         {
            if(direction == "left")
            {
               (enemy as! Enemy).resetPosistion(newPosistion: PUSH_BACK_DISTANCE_LEFT)
            }
            if(direction == "right")
            {
               (enemy as! Enemy).resetPosistion(newPosistion: -PUSH_BACK_DISTANCE_RIGHT)
            }
         }
      }
   }

   
   /************************************************
    * advanceBullet:
    *    This function iterates though each bullet
    * and moves them along the screen.
    *************************************************/
   func advanceBullets()
   {
      for bullet in bulletList
      {
         // Advance laser bolt
         if((bullet as! Bullet).bulletType == 1)
         {
            if ((bullet as! Bullet).wasBulletFiredLeft())
            {
               (bullet as! Bullet).moveLeft() // when the bullet moves, take a point away from its life
               (bullet as! Bullet).setBulletLifeTime(life: (bullet as! Bullet).getBulletLifeTime() - 1)
            }
            else
            {
               (bullet as! Bullet).moveRight()
               (bullet as! Bullet).setBulletLifeTime(life: (bullet as! Bullet).getBulletLifeTime() - 1)
            }
         }
         
         // advance Rocket
         if((bullet as! Bullet).bulletType == 2)
         {
            if ((bullet as! Bullet).wasBulletFiredLeft())
            {
               (bullet as! Bullet).moveLeft() // when the bullet moves, take a point away from its life
               (bullet as! Bullet).setBulletLifeTime(life: (bullet as! Bullet).getBulletLifeTime() - 1)
            }
            else
            {
               (bullet as! Bullet).moveRight()
               (bullet as! Bullet).setBulletLifeTime(life: (bullet as! Bullet).getBulletLifeTime() - 1)
            }
            // animate Rocket
            (bullet as! Bullet).animateMovement()
            
         }
      }
      
         // advance granade
         for object in objectList
         {
            if((object as! Object).isAGranade)
            {
               (object as! Object).expireTime -= 1
            }
            
         }
      
         
         
         
   }
   
   /************************************************
    * bulletCleanup:
    *    This function iterates though each bullet
    * and sees if its time to delete it.
    *************************************************/
   func bulletCleanup(killNow: Bool)
   {
     
      for bullet in bulletList
      {
         if((bullet as! Bullet).getBulletLifeTime() <= 0)
         {
            
            (bullet as! Bullet).removeFromParent()
            bulletList.remove(bullet)
            break
         }

      }
      
      
      // cleanup granade
      for object in objectList
      {
         if((object as! Object).isAGranade && (object as! Object).expireTime <= 0)
         {
            (object as! Object).removeFromParent() // remove granade
            
            let granadeExplotion = GranadeExplotion(skin: "", damage: 75)
            let codeBlock = SKAction.run({
               
               // Create explotion!
               granadeExplotion.position = (object as! Object).position
               self.objectList.add(granadeExplotion)
               self.addChild(granadeExplotion)
               granadeExplotion.physicsBody?.categoryBitMask = self.explosionCategory
               granadeExplotion.physicsBody?.contactTestBitMask = self.enemyCategory | self.objectCategory
               granadeExplotion.physicsBody?.collisionBitMask =  self.objectCategory
               granadeExplotion.explosion()
              
               
            })
            let finishedBlock = SKAction.run({
               granadeExplotion.removeFromParent()
               self.objectList.remove(granadeExplotion)
            })
            
            let sequence = SKAction.sequence([codeBlock, SKAction.wait(forDuration: 0.3), finishedBlock])
            
            self.run(sequence)
            self.objectList.remove((object as! Object)) // remove granade from memory
            break
         }
         
      }
   }
   
   
   /************************************************
    * createTree:
    *    This function generates the trees and rocks
    * randomly thoughout the enviroment.
    *************************************************/
   func createTrees()
   {
      if(objectList.count < MAX_NUM_OF_TREES)
      {
         let chanceToSpawnTree = arc4random_uniform(10) + 1
         
         if(chanceToSpawnTree == 1)
         {
            let newTree = Object(color: UIColor.clear, size: CGSize(width: 0.0, height: 0.0), posistion: CGPoint(x: 0, y: 0))
           
            //get random position
            let randomPosistion = arc4random_uniform(3) + 1
            
            
            
            
            //place trees to the right
            if(player.isFacingRight)
            {
               
               switch randomPosistion
               {
               // top
               case 1:
                  newTree.size = CGSize(width: 25.0, height: 50.0)
                  newTree.position = CGPoint(x: player.getPosistion() + 480, y: -30)
                  newTree.zPosition = -9
                  
               //middle
               case 2:
                  newTree.size = CGSize(width: 75.0, height: 100.0)
                  newTree.position = CGPoint(x: player.getPosistion() + 540, y: -20)
                  newTree.zPosition = -8
                  
               // Next to player
               case 3:
                  newTree.size = CGSize(width: 125.0, height: 175.0)
                  newTree.position = CGPoint(x: player.getPosistion() + 560, y: -10)
                  newTree.zPosition = -7
                  
                  
               default:
                  break
               }
            }
            
            //place trees to the left
            if(player.isFacingLeft)
            {
               switch randomPosistion
               {
               // top
               case 1:
                  newTree.size = CGSize(width: 25.0, height: 50.0)
                  newTree.position = CGPoint(x: player.getPosistion() - 480, y: -30)
                  newTree.zPosition = -9
                  
               //middle
               case 2:
                  newTree.size = CGSize(width: 75.0, height: 100.0)
                  newTree.position = CGPoint(x: player.getPosistion() - 520, y: -20)
                  newTree.zPosition = -8
                  
               // Next to player
               case 3:
                  newTree.size = CGSize(width: 125.0, height: 175.0)
                  newTree.position = CGPoint(x: player.getPosistion() - 560, y: -10)
                  newTree.zPosition = -7
                  
                  
               default:
                  break
               }
               
            }
            
            
           
            //space trees out
            if(objectList.count > 0)
            {
               for tree in objectList
               {
                  
                  // move tree up if there too close
                  if((tree as! Object).position.x >= (newTree.position.x + 30) || (tree as! Object).position.x <= (newTree.position.x - 30))
                  {
                     if(player.isFacingRight)
                     {
                        //print("moving tree right")
                        newTree.position.x -= 50
                        
                     }
                     if(player.isFacingLeft)
                     {
                       // print("moving tree left")
                        newTree.position.x += 50
                       
                     }
                     
                  }
                  break
               }
            }

            
            
            
            
            
            //get random tree skin
            let randomTreeSkin = arc4random_uniform(4) + 1
            
            switch randomTreeSkin
            {
            case 1:
               newTree.texture = SKTexture(imageNamed: "tree1")
            case 2:
               newTree.texture = SKTexture(imageNamed: "tree2")
            case 3:
               newTree.texture = SKTexture(imageNamed: "treeLeft3")
            case 4:
               newTree.texture = SKTexture(imageNamed: "treeRight3")
            default:
               break
            }
            
            
            
            
            
            //give it no physics
            newTree.physicsBody = nil
            objectList.add(newTree)
            self.addChild(newTree)
            
         }
      }
   }
   
   /************************************************
    * cleanupTrees:
    *    This function removes tree if the player goes
    * beyond the bounds of seeing the trees.
    *************************************************/
   func cleanupTrees()
   {
      if(objectList.count > 0)
      {
         for tree in objectList
         {
            
            //remove tree if its too far in front of the player
            if((tree as! Object).position.x > player.getPosistion() + 651)
            {
               (tree as! Object).removeFromParent()
               objectList.remove(tree)
               
            }
            //remove tree if its too far behind player
            if((tree as! Object).position.x < player.getPosistion() - 650)
            {
               (tree as! Object).removeFromParent()
               objectList.remove(tree)
            }
            // STOP THE LOOP!
            break
         }
      }
   }
   
   /************************************************
    * createBullet:
    *    This function generates a bullet
    *************************************************/
   func createBullet()
   {
       // CREATE LASER BOLT
      if(CURRENT_WEAPON == 1 && pickedupPistol == true)
      {
         
         //create bullet
         let newBullet = Bullet(skin: "", damage: 10)
         newBullet.setY(y: self.player.position.y - 30) // 40
         
         //make bullet face right direction
         if(self.player.isPlayerFacingLeft() == true)
         {
            newBullet.setX(x: self.player.getPosistion() - 25) // 50
            newBullet.wasFiredLeft = true
         }
         else
         {
            newBullet.setX(x: self.player.getPosistion() + 25) // 50
         }
         
         //give physics properties
         newBullet.physicsBody?.categoryBitMask = self.bulletCategory
         newBullet.physicsBody?.contactTestBitMask =  self.objectCategory | enemyCategory
         newBullet.physicsBody?.collisionBitMask =  self.objectCategory | enemyCategory
         
         //add to game
         
         self.bulletList.add(newBullet)
         self.addChild(newBullet)
      }
      
      // CREATE ROCKET
      if(CURRENT_WEAPON == 2 && pickedupLauncher == true)
      {
         //create bullet
         let newRocket = Rocket(skin: "", damage: 100)
         
         //spawn posistion of rocket
         newRocket.setY(y: self.player.position.y - 15) //20
         
         //make bullet face right direction
         if(self.player.isPlayerFacingLeft() == true)
         {
            newRocket.setX(x: self.player.getPosistion() - 40)
            newRocket.wasFiredLeft = true
         }
         else
         {
            newRocket.setX(x: self.player.getPosistion() + 40)//40
         }
         
         //give physics properties
         newRocket.physicsBody?.categoryBitMask = self.bulletCategory
         newRocket.physicsBody?.contactTestBitMask =  self.objectCategory | enemyCategory
         newRocket.physicsBody?.collisionBitMask =  self.objectCategory | enemyCategory
         
         //add to game
         
         self.bulletList.add(newRocket)
         self.addChild(newRocket)
      }
      
      // CREATE GRANADE
      if(CURRENT_WEAPON == 3 && pickedupGranade == true)
      {
         
         //create bullet
         let newGranade = TossedGranade(skin: "granadeExplo0", damage: 0)
         newGranade.size = CGSize(width: 20, height: 20)
         
         newGranade.setY(y: self.player.position.y - 15) //20
         
         //make bullet face right direction
         if(self.player.isPlayerFacingLeft() == true)
         {
            newGranade.setX(x: self.player.getPosistion() - 40)
            newGranade.wasFiredLeft = true
            newGranade.tossGranade(playerPosistion: player.position)
         }
         else
         {
            newGranade.wasFiredLeft = false
            newGranade.setX(x: self.player.getPosistion() + 40)//40
            newGranade.tossGranade(playerPosistion: player.position)
         }
         
         //give physics properties
         newGranade.physicsBody?.categoryBitMask = self.deadCategory
         newGranade.physicsBody?.contactTestBitMask =  self.objectCategory
         newGranade.physicsBody?.collisionBitMask =  self.objectCategory
         
         //add to game
         
        // self.bulletList.add(newGranade)
         self.objectList.add(newGranade)
         self.addChild(newGranade)
      }
      
   }
   

   
   
   // ****************
   //
   //     ENEMY Stuff
   //
   // ****************
   
   /************************************************
    * createEnemies:
    *    This function creates enemies randomly
    * player based on his posistion.
    *************************************************/
   func createEnemies()
   {
   //  print("enemy spawn rate is = \(ENEMY_SPAWN_RATE)")
      
      let creatureChance = arc4random_uniform(UInt32(ENEMY_SPAWN_RATE)) + 0 // chance of enemy spawning
      let randomSpawnPoint = arc4random_uniform(2) + 1 // spawn in front or back
      
//      let creatureChance = 1 // only temp
//      let randomSpawnPoint = 800

      
      
      if(creatureChance == 1)
      {
         
         let newEnemy =  Minion()
         //make enemy face player
         //  textures NEEDS TO BE MADE DYNAMIC
         if(self.player.isPlayerFacingLeft() == true)
         {
            newEnemy.faceLeft(textureName: "minionStandingLeft")
            newEnemy.spawn(spawnPoint: player.getPosistion() + CGFloat(-500))
         }
         else
         {
            newEnemy.faceLeft(textureName: "minionStandingLeft")
             newEnemy.spawn(spawnPoint: player.getPosistion() + CGFloat(500))
         }
         
         //location
         if(randomSpawnPoint == 1)
         {
            newEnemy.spawn(spawnPoint: player.getPosistion() + CGFloat(500))
         }
         
         if(randomSpawnPoint == 2)
         {
            newEnemy.spawn(spawnPoint: player.getPosistion() + CGFloat(-500))
         }
         
         //physics
         newEnemy.physicsBody!.categoryBitMask = enemyCategory
         newEnemy.physicsBody!.contactTestBitMask = bulletCategory | objectCategory | playerCategory | explosionCategory
         newEnemy.physicsBody!.collisionBitMask =  playerCategory | bulletCategory | objectCategory
         
         //add
         enemyList.add(newEnemy)
         self.addChild(newEnemy)
         
      }
       //  setEnemyIndex += 1 // increment
   }
   
   /************************************************
    * cleanupEnemies:
    *    This function deletes an enemy when he has been
    * killed.
    *************************************************/
   func cleanupEnemies(incDamage: Int)
   {
      //check to be sure that list has pop
      if(enemyList.count > 0)
      {
   
         for enemy in enemyList
         {
            
            if((enemy as! Enemy).getHitPoints() <= 0 && enemyList.count > 0)
            {
               
               self.enemyList.remove(enemy)
               (enemy as! Enemy).removeFromParent()
               
            
               //stop this DANG loop
               break
            }
         }
      }
   }
   
   /************************************************
    * advanceEnemies:
    *    This function moves the enemy closer to the
    * player based on his posistion.
    *************************************************/
   func advanceEnemies()
   {
      
      for enemy in enemyList
      {
         if(player.isAlive == true)
         {
            (enemy as! Enemy).attackAnimationRightFinished = true
            (enemy as! Enemy).attackAnimationLeftFinished = true
            
            //ENEMY NOT IN RANGE
            if((enemy as! Enemy).getInRangeToAttack(playerPosition: player.getPosistion(), playerPositionY: player.position.y) == false && (enemy as! Enemy).goRoam == false)
            {
               (enemy as! Enemy).goRoam = false
               
               // MOVE TO PLAYER
               if((enemy as! Enemy).attackAnimationLeftFinished && (enemy as! Enemy).attackAnimationRightFinished)
               {
                  
                  (enemy as! Enemy).runOnce3 = false
                  
                  (enemy as! Enemy).moveToPlayer(playerPosistion: player.getPosistion())
               }
               
            }
               //otherwise, roam
            else if(player.position.y > 70 && canJump == true)
            {
               (enemy as! Enemy).goRoam = true
               (enemy as! Enemy).Roam()
            }
            else if(player.position.y < 70)
            {
               (enemy as! Enemy).goRoam = false
            }
            
            //ENEMY IS IN RANGE
            if((enemy as! Enemy).getInRangeToAttack(playerPosition: player.getPosistion(), playerPositionY: player.position.y) == true && (enemy as! Enemy).goRoam == false)
            {
               
               //CALL ATTACK
               
               if((enemy as! Enemy).isInContact == false)
               {
                  //run attack sequnce
                  let attackSLQ = SKAction.run({
                     
                     (enemy as! Enemy).attackAnimationRightFinished = false
                     (enemy as! Enemy).attackAnimationLeftFinished = false
                     
                     (enemy as! Enemy).isAttacking = true
                     (enemy as! Enemy).attack(playerPosistion: self.player.getPosistion())
                     
                     
                  })
                  
                  self.run(attackSLQ, completion:
                     {
                        
                        (enemy as! Enemy).isAttacking = false
                        
                  })
               }
               if((enemy as! Enemy).isInContact == true)
               {
                  (enemy as! Enemy).backup()
               }
            }
               
            
            
         }
            //player is dead, just roam
         else
         {
            (enemy as! Enemy).Roam()
         }
      }
      
   }

   
   /************************************************
    * enemyMoveAway:
    *    This function moves the enemy closer to the
    * player based on his posistion.
    *************************************************/
   func enemyMoveAway()
   {
      
//      if((player.getPosistion() - 50) > badGuy.getPosistion())
//      {
//         badGuy.moveLeft()
//         badGuy.animateLeft()
//      }
//      else
//      {
//         badGuy.finishedMoving()
//         
//      }
//      
//      if((player.getPosistion() + 50) < badGuy.getPosistion())
//      {
//         badGuy.moveRight()
//         badGuy.animateRight()
//      }
//      else
//      {
//         badGuy.finishedMoving()
//      }
   }

   /************************************************
    * createPickupObjects:
    *    This function creates a pickup-able object for
    * the player.
    *************************************************/
   func createPickupObject(spawnPoint: CGPoint)
   {
      let pickupChance = arc4random_uniform(CHANCE_FOR_PICKUP) + 1 // chance of pickup spawning
      
    //  print("pickup Chance = \(pickupChance)")
      // Spwan Random item
      if(pickupChance == 1 || pickupChance == 2)
      {
         let randomItem = arc4random_uniform(RANDOM_ITEM) + 1 // chance of pickup spawning
       //  print("random item = \(randomItem)")
         //spawn health
         if(randomItem == 1 || randomItem == 2 || randomItem == 3)
         {
            //create a random object
            let newHealthPack = HealthPack()
            
            newHealthPack.position = spawnPoint
            
            newHealthPack.physicsBody!.categoryBitMask = pickupCategory
            newHealthPack.physicsBody!.contactTestBitMask = playerCategory | objectCategory
            newHealthPack.physicsBody!.collisionBitMask =  playerCategory | objectCategory
            
            pickupList.add(newHealthPack)
            self.addChild(newHealthPack)
         }
         
         //spawn pistol ammoo
         if(randomItem == 4 || randomItem == 5 || randomItem == 6)
         {
            if(pickedupPistol == true)
            {
               //create a random object
               let newPistolAmmp = PistolAmmo()
               
               newPistolAmmp.position = spawnPoint
               
               newPistolAmmp.physicsBody!.categoryBitMask = pickupCategory
               newPistolAmmp.physicsBody!.contactTestBitMask = playerCategory | objectCategory
               newPistolAmmp.physicsBody!.collisionBitMask =  playerCategory | objectCategory
               
               pickupList.add(newPistolAmmp)
               self.addChild(newPistolAmmp)
            }
         }
         //spawn granade ammo
         if(randomItem == 7 || randomItem == 8)
         {
            if(pickedupGranade == true)
            {
               //create a random object
               let newGranadeAmmo = GranadeAmmo()
               
               newGranadeAmmo.position = spawnPoint
               
               newGranadeAmmo.physicsBody!.categoryBitMask = pickupCategory
               newGranadeAmmo.physicsBody!.contactTestBitMask = playerCategory | objectCategory
               newGranadeAmmo.physicsBody!.collisionBitMask =  playerCategory | objectCategory
               
               pickupList.add(newGranadeAmmo)
               self.addChild(newGranadeAmmo)
            }
         }
         //spawn rocket ammo
         if(randomItem == 9 || randomItem == 10)
         {
            if(pickedupLauncher == true)
            {
               //create a random object
               let newRocketAmmo = RocketAmmo()
               
               newRocketAmmo.position = spawnPoint
               
               newRocketAmmo.physicsBody!.categoryBitMask = pickupCategory
               newRocketAmmo.physicsBody!.contactTestBitMask = playerCategory | objectCategory
               newRocketAmmo.physicsBody!.collisionBitMask =  playerCategory | objectCategory
               
               pickupList.add(newRocketAmmo)
               self.addChild(newRocketAmmo)
            }
         }

         
      }
      
   }
   
   
  
   
   /************************************************
    * retry:
    *    This function restarts the spesified level
    *************************************************/
   func retry(levelSelect: Int)
   {
      if(retryButton.buttonPressed == true)
      {
         
        // clearing screen
         pickedupPistol = false
         pickedupLauncher = false
         pickedupGranade = false
         
         player.setHasPistol(gotPistol: false)
         player.setHasLauncher(gotLauncher: false)
         player.hasGranades = false
         
         STARTING_GRANADE_AMMO = 0
         STARTING_LAUNCHER_AMMO = 0
         STARTING_PISTOL_AMMO = 0
         
         RANDOM_ITEM = 6
         
         player.removeAllChildren() // reset player
         self.removeAllChildren() // clear screen
         
         //clean memory
         enemyList.removeAllObjects()
         objectList.removeAllObjects()
         pickupList.removeAllObjects()
         bulletList.removeAllObjects()
         
         // Resetting all vars
         gameOver = false
         canJump = true
         jump = false
         
         isRunningLeft = false
         isRunningRight = false
         
         runOnce = false
         runOnce2 = false
         
         enemyInRange = false
         
         PLAYER_HAS_FINISHED_LEVEL = false
         HAS_SHIP_PART = false
         
         player.isFacingRight = true
         
         player.setTexture(skin: "standingRight")
         audioplayer.stop() // stop song
         
         levelInit(levelSelect: levelSelect)
      }
   }
   
   
   
   
   
   
   /************************************************
    * levelInit:
    *    This function creates the sepsified level.
    *************************************************/
   func levelInit(levelSelect: Int)
   {
      
      //gound
      ground.physicsBody?.restitution = 0.0
      ground.physicsBody?.categoryBitMask = objectCategory
      ground.physicsBody?.contactTestBitMask = playerCategory | pickupCategory | deadCategory
      ground.physicsBody?.collisionBitMask =   pickupCategory | playerCategory | deadCategory
      self.addChild(ground)
      
      //WALLs to keep player from moving off screen
      let rightWall = RightWall()
      rightWall.physicsBody?.restitution = 0.0
      rightWall.physicsBody?.categoryBitMask = wallCategory
      rightWall.physicsBody?.contactTestBitMask = playerCategory | deadCategory
      rightWall.physicsBody?.collisionBitMask =   playerCategory | deadCategory
      self.addChild(rightWall)
      
      let leftWall = LeftWall()
      leftWall.physicsBody?.restitution = 0.0
      leftWall.physicsBody?.categoryBitMask = wallCategory
      leftWall.physicsBody?.contactTestBitMask = playerCategory | deadCategory
      leftWall.physicsBody?.collisionBitMask =   playerCategory | deadCategory
      self.addChild(leftWall)
      
      
      // ATTACK
      let attackButton = Button(defaultButtonImage: "A.png", activeButtonImage: "A.png", buttonAction:
         {
            if(self.gamePaused == false)
            {
               if(self.player.isAlive == true)
               {
                  if(self.player.playerHasPistol() == false && self.player.hasRocketLauncher == false && self.player.hasGranades == false)
                  {
                     self.displayText(text: "No Weapon!")
                  }
                  //pistol
                  if(self.CURRENT_WEAPON == 1 && self.player.hasPistol == true)
                  {
                     if(self.STARTING_PISTOL_AMMO > 0)
                     {
                        // run animation
                        self.player.animateShooting()
                        self.run(self.laserSound)
                        self.createBullet()
                        
                        self.STARTING_PISTOL_AMMO -= 1
                        self.pistolAmmoLabel.text = String(self.STARTING_PISTOL_AMMO)
                     }
                     else if(self.STARTING_PISTOL_AMMO <= 0)
                     {
                        self.displayText(text: "No Pistol Ammo!")
                     }
                  }
                  
                  //rocket
                  if(self.CURRENT_WEAPON == 2 && self.player.hasRocketLauncher == true)
                  {
                     
                     
                     if(self.STARTING_LAUNCHER_AMMO > 0)
                     {
                        self.player.animateShooting()
                        self.createBullet()
                        self.STARTING_LAUNCHER_AMMO -= 1
                        self.launcherAmmoLabel.text = String(self.STARTING_LAUNCHER_AMMO)
                     }
                     else if(self.STARTING_LAUNCHER_AMMO <= 0)
                     {
                        self.displayText(text: "No Rocket Ammo!")
                     }
                     
                  }
                  //granade
//                  if(self.CURRENT_WEAPON == 3 && self.player.hasGranades == true)
//                  {
//
//
//                     if(self.STARTING_GRANADE_AMMO > 0)
//                     {
//                        self.player.animateShooting()
//                        self.createBullet()
//                        self.STARTING_GRANADE_AMMO -= 1
//                        self.granadeAmmoLabel.text = String(self.STARTING_GRANADE_AMMO)
//                     }
//                     else if(self.STARTING_GRANADE_AMMO <= 0)
//                     {
//                        self.displayText(text: "No Granades!")
//                     }
//
//                  }
                  
                  
               }
            }
      })
      attackButton.xScale /= 4.8
      attackButton.yScale /= 4.8
      
      attackButton.position = CGPoint(x: 330, y: -165) // 145
      addChild(attackButton)
      
      
      
      // TAP GRENADE BUTTON
      
      let grenadeButtonPink = Button(defaultButtonImage: "grenadeButton.png", activeButtonImage: "grenadeButton.png", buttonAction:{
         
         var oldWeapon = self.CURRENT_WEAPON
         self.CURRENT_WEAPON = 3
         
         if(self.STARTING_GRANADE_AMMO > 0)
         {
            self.CURRENT_WEAPON = 3
            self.player.animateShooting()
            self.createBullet()
            self.STARTING_GRANADE_AMMO -= 1
            self.granadeAmmoLabel.text = String(self.STARTING_GRANADE_AMMO)
         }
         else if(self.STARTING_GRANADE_AMMO <= 0)
         {
            self.displayText(text: "No Granades!")
         }
         
         self.CURRENT_WEAPON = oldWeapon
         
         
      })
      
      grenadeButtonPink.xScale /= 4.8
      grenadeButtonPink.yScale /= 4.8
      
      
      
      //ammo label
      granadeAmmoLabel.text = (String(self.STARTING_GRANADE_AMMO)) // reset label
      granadeAmmoLabel.position = CGPoint(x: 190, y: -173)//35  -130
      granadeAmmoLabel.zPosition = 2
      granadeAmmoLabel.fontSize = 15
      granadeAmmoLabel.fontColor = UIColor.white
      granadeAmmoLabel.fontName = "Courier-Bold"
      
      addChild(granadeAmmoLabel)
      
      grenadeButtonPink.position = CGPoint(x: 190, y: -165)
      addChild(grenadeButtonPink)
      
//      granadePointer = grenadeButtonPink
      
      // PISTOL SELECT BUTTON
      let pistolButton = Button(defaultButtonImage: "pistolRight", activeButtonImage: "pistolRight", buttonAction: {
         
         self.equipPistol()
         
      })
      pistolButton.position = CGPoint(x: -100, y: -140)
      
      pistolButton.yScale /= 3.25
      pistolButton.xScale /= 3.25
      
      //ammo label
      pistolAmmoLabel.position = CGPoint(x: -100, y: -130)
      pistolAmmoLabel.fontSize = 15
      pistolAmmoLabel.fontColor = UIColor.white
      pistolAmmoLabel.fontName = "Courier-Bold"
      
      pistolPointer = pistolButton
      
      
      
      // LAUNCHER SELECT BUTTON
      let LauncherButton = Button(defaultButtonImage: "launcherRight", activeButtonImage: "launcherRight", buttonAction: {
         
         self.equipRocket()
         
      })
      LauncherButton.position = CGPoint(x: -30, y: -140)
      
      LauncherButton.yScale /= 5
      LauncherButton.xScale /= 5
      
      //ammo label
      launcherAmmoLabel.position = CGPoint(x: -30, y: -130)
      launcherAmmoLabel.fontSize = 15
      launcherAmmoLabel.fontColor = UIColor.white
      launcherAmmoLabel.fontName = "Courier-Bold"
      
      //pointer
      LauncherPointer = LauncherButton
     
      
      
      // GRANADE SELECT BUTTON
//      let granadeButton = Button(defaultButtonImage: "granade", activeButtonImage: "granade", buttonAction: {
//
//         if(self.pickedupGranade == true)
//         {
//            self.CURRENT_WEAPON = 3
//            self.player.hasGranades = true
//            self.player.hasRocketLauncher = false
//            self.player.hasPistol = false
//            self.player.justGotGun = true
//            self.granadePointer?.setIcon(icon: "granadeSelected.png")
//            self.pistolPointer?.setIcon(icon: "pistolNotSelected")
//            self.LauncherPointer?.setIcon(icon: "launcherNotSelected")
//         }
//
//      })
//
//      granadeButton.position = CGPoint(x: 35, y: -139)
//
//      granadeButton.yScale /= 2.5
//      granadeButton.xScale /= 2.5
      
      
      
      // set granade pointer
//      granadePointer = granadeButton
      

      
      
      
      
      //Jump
      
      jumpButton.position = CGPoint(x: 260, y: -165) //160
      addChild(jumpButton)
      
     
      
      
      // *** RIGHT MOVEMENT ***
      
      // adjusting the size of the button
      
      rightMovementbutton.position = CGPoint(x: -205, y: -160) // -150
      addChild(rightMovementbutton)
      
      
      
      // *** LEFT MOVEMENT ***
      
      // adjusting the size of the button
      
      leftMovementbutton.position = CGPoint(x: -310, y: -160)
      addChild(leftMovementbutton)
      
      
      
      // *** retry button
      retryButton.isHidden = true
      retryButton.position = CGPoint(x: 0, y: 100)
      retryButton.zPosition = 50
      self.addChild(retryButton)
      
      
      
      //pauseButton setup
      pauseLabel.texture = SKTexture(imageNamed: "paused")
      pauseLabel.zPosition = 100
      pauseLabel.physicsBody = nil
      
      let pauseButton = Button(defaultButtonImage: "Pause.png", activeButtonImage: "Pause.png", buttonAction: {
         
         if(self.gamePaused == false)
         {
            
            let codeBlock = SKAction.run({
            
               
            self.addChild(self.dimPanel)
            })
            let finnishedCodeBlock = SKAction.run {
            
               self.scene?.view?.isPaused = true
               self.gamePaused = true
               self.addChild(self.pauseLabel)
            }
            
            
            let sequence = SKAction.sequence([codeBlock,finnishedCodeBlock])
            self.run(sequence)
            
            
            
         }
         else
         {
            
            self.scene?.view?.isPaused = false
            let codeBlock = SKAction.run({
               
              
            })
            let finnishedCodeBlock = SKAction.run {
               
                self.dimPanel.removeFromParent()
                self.gamePaused = false
                self.pauseLabel.removeFromParent()
            }
            
            let sequence = SKAction.sequence([codeBlock,finnishedCodeBlock])
            self.run(sequence)
            
            
         }
         
      })
      
      pauseButton.isHidden = false
      pauseButton.position = CGPoint(x: -330, y: 155)
      pauseButton.xScale /= 6.5
      pauseButton.yScale /= 6.5
      pauseButton.zPosition = 50
      self.addChild(pauseButton)
      

      
      
      
      // *** LEVEL INIT BEGINS HERE ***
      switch levelSelect
      {
      case 1:
         
         
         
         //adding background 1
         background.anchorPoint = CGPoint(x: 0.5, y: 0.4) // 0.5
         background.position = CGPoint(x: 0.5, y: 0.3)//0.5
         background.zPosition = -10
         background.changeBackGround(textureName: SKTexture(imageNamed: "NeptuneNew"))
         self.addChild(background)
         
         //adding backgroud2
         backgroundSecond.anchorPoint = CGPoint(x: 0.5, y: 0.4) //0.5
         backgroundSecond.position = CGPoint(x: backgroundSecond.size.width - 1, y: 0.3)//0.5
         backgroundSecond.zPosition = -10
         backgroundSecond.changeBackGround(textureName: SKTexture(imageNamed: "NeptuneNew"))
         self.addChild(backgroundSecond)
         
         healthBar.setHealthBarPoints(points: 20)
         self.addChild(healthBar)
         
         
         // *** LEVEL SETUP ***
         launcher.position.y = 1
         launcher.spawn(spawnPoint: 110) // 4650
         launcher.physicsBody?.categoryBitMask = pickupCategory
         launcher.physicsBody!.contactTestBitMask = playerCategory | objectCategory
         launcher.physicsBody!.collisionBitMask =  playerCategory | objectCategory

         self.pickupList.add(launcher)
         self.addChild(launcher)

         
         pistol.position.y = -10
         pistol.spawn(spawnPoint: 100)
         pistol.physicsBody?.categoryBitMask = pickupCategory
         pistol.physicsBody!.contactTestBitMask = playerCategory | objectCategory
         pistol.physicsBody!.collisionBitMask =  playerCategory | objectCategory

         self.pickupList.add(pistol)
         self.addChild(pistol)
         
         
         let grande = Granade()
         
         grande.position.y = 111
         grande.spawn(spawnPoint: 1400)
         grande.physicsBody?.categoryBitMask = pickupCategory
         grande.physicsBody!.contactTestBitMask = playerCategory | objectCategory
         grande.physicsBody!.collisionBitMask =  playerCategory | objectCategory
         
         self.pickupList.add(grande)
         self.addChild(grande)

         
         
         //crashed ship
         let crashedShip = Ship()
         
         // Assign a contact catagory for the pipe
         crashedShip.physicsBody!.categoryBitMask = pickupCategory
         crashedShip.physicsBody!.contactTestBitMask = playerCategory | objectCategory
         crashedShip.physicsBody!.collisionBitMask =  playerCategory | objectCategory
         
         crashedShip.physicsBody?.isDynamic = false
         pickupList.add(crashedShip)
         self.addChild(crashedShip)

         // add ship part
         let shipPart1 = shipPart()
         
         shipPart1.physicsBody!.categoryBitMask = pickupCategory
         shipPart1.physicsBody!.contactTestBitMask = playerCategory | objectCategory
         shipPart1.physicsBody!.collisionBitMask =  playerCategory | objectCategory
         shipPart1.position = CGPoint(x: 7000, y: -30)
         pickupList.add(shipPart1)
         self.addChild(shipPart1)
         
         // PIPES N STUFF
         
         let building = Object(color: UIColor.clear, size: CGSize(width: 500, height: 200), posistion: CGPoint(x: 1600, y: -50))
         
         building.texture = SKTexture(imageNamed: "hill")
         
         building.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 2), center: CGPoint(x: 0, y: 100))
         building.physicsBody?.restitution = 0.0
         
         // Assign a contact catagory for the pipe
         building.physicsBody!.categoryBitMask = objectCategory
         building.physicsBody!.contactTestBitMask = playerCategory | bulletCategory | enemyCategory | objectCategory | pickupCategory
         building.physicsBody!.collisionBitMask =  playerCategory | bulletCategory | enemyCategory | objectCategory | pickupCategory
         
         building.position = CGPoint(x: 1600, y: 0)
         building.zPosition = -1
         building.physicsBody?.isDynamic = false
         building.physicsBody?.affectedByGravity = false
        
         nonRemoveObjectList.add(building)
         self.addChild(building)
         
         
         
         
         let pipe2 = Object(color: UIColor.clear, size: CGSize(width: 50, height: 5), posistion: CGPoint(x: 2100, y: 0))
         
         pipe2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 2), center: CGPoint(x: 0, y: 0))
         pipe2.physicsBody?.restitution = 0.0
         
         // Assign a contact catagory for the pipe
         pipe2.physicsBody!.categoryBitMask = objectCategory
         pipe2.physicsBody!.contactTestBitMask = playerCategory | objectCategory | pickupCategory
         pipe2.physicsBody!.collisionBitMask =  playerCategory  | objectCategory | pickupCategory
         
         
         pipe2.zPosition = -1
         pipe2.physicsBody?.isDynamic = false
         pipe2.physicsBody?.affectedByGravity = false

         nonRemoveObjectList.add(pipe2)
         self.addChild(pipe2)
         
         
         
         
         
         
         let pipe3 = Object(color: UIColor.clear, size: CGSize(width: 50, height: 5), posistion: CGPoint(x: 2000, y: 40))
         
         pipe3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 2), center: CGPoint(x: 0, y: 0))
         pipe3.physicsBody?.restitution = 0.0
         
         // Assign a contact catagory for the pipe
         pipe3.physicsBody!.categoryBitMask = objectCategory
         pipe3.physicsBody!.contactTestBitMask = playerCategory | objectCategory | pickupCategory
         pipe3.physicsBody!.collisionBitMask =  playerCategory  | objectCategory | pickupCategory
         
         
         pipe3.zPosition = -1
         pipe3.physicsBody?.isDynamic = false
         pipe3.physicsBody?.affectedByGravity = false
         
         nonRemoveObjectList.add(pipe3)
         self.addChild(pipe3)
         
         
         let pipe4 = Object(color: UIColor.clear, size: CGSize(width: 50, height: 5), posistion: CGPoint(x: 4650, y: 0))
         
         pipe4.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 2), center: CGPoint(x: 0, y: 0))
         pipe4.physicsBody?.restitution = 0.0
         
         // Assign a contact catagory for the pipe
         pipe4.physicsBody!.categoryBitMask = objectCategory
         pipe4.physicsBody!.contactTestBitMask = playerCategory | objectCategory | pickupCategory
         pipe4.physicsBody!.collisionBitMask =  playerCategory  | objectCategory | pickupCategory
         
         
         pipe4.zPosition = -1
         pipe4.physicsBody?.isDynamic = false
         pipe4.physicsBody?.affectedByGravity = false

//
         nonRemoveObjectList.add(pipe4)
         self.addChild(pipe4)
         
         //load enviroment objs
         
         
         //Setting up player stats
         player.physicsBody?.isDynamic = true
         player.anchorPoint = CGPoint(x: 0.5, y: 1.0)
         player.position = CGPoint(x: 0.0, y: 1.0)
         player.zPosition = 1
         player.physicsBody?.restitution = 0.0
         
         player.physicsBody?.categoryBitMask = playerCategory
         player.physicsBody?.contactTestBitMask = pickupCategory | objectCategory | enemyCategory | wallCategory
         player.physicsBody?.collisionBitMask = pickupCategory | objectCategory | enemyCategory | wallCategory
         
         player.hasPistol = false
         player.isAlive = true
         player.runOnce4 = false
         player.setHitPoints(setHP: 20)
         self.addChild(player)
         
         
         // SCRIPTED EVENTS
         if(pickedupPistol == true)
         {
            ENEMY_SPAWN_RATE = 20
         }
         
         
         /************************************************
          *playMainSong:
          *    This function plays music for the level.
          *************************************************/
         func playMainSong()
         {
            //Play Audio!
            let audioPath = Bundle.main.path(forResource: "SpaceSong", ofType: "mp3")!
            do
            {
               try audioplayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
               audioplayer.numberOfLoops = -1 // loop the song!
               audioplayer.play()
               
               
            }
            catch
            {
               print("error playing audio")
            }
            
         }

         playMainSong()
         
      default:
         break
      }
   }
   
   /************************************************
    * equipPistol:
    *    This function executes all the required code
    * to switch the players weapon to the pistol.
    *************************************************/
   func equipPistol()
   {
      if(self.pickedupPistol == true)
      {
         self.CURRENT_WEAPON = 1
         self.player.hasRocketLauncher = false
         self.player.hasGranades = false
         self.player.hasPistol = true
         
         self.player.justGotGun = true
         self.pistolPointer?.setIcon(icon: "pistolSelected")
         self.LauncherPointer?.setIcon(icon: "launcherNotSelected")
         self.granadePointer?.setIcon(icon: "granadeNotSelected.png")
      }
   }
   
   /************************************************
    * equipRocket:
    *    This function executes all the required code
    * to switch the players weapon to the rocket.
    *************************************************/
   func equipRocket()
   {
      if(self.pickedupLauncher == true)
      {
         self.CURRENT_WEAPON = 2
         self.player.hasRocketLauncher = true
         self.player.hasPistol = false
         self.player.hasGranades = false
         self.player.justGotGun = true
         self.LauncherPointer?.setIcon(icon: "launcherSelected")
         self.pistolPointer?.setIcon(icon: "pistolNotSelected")
         self.granadePointer?.setIcon(icon: "granadeNotSelected.png")
         
      }
   }
   
   
   /************************************************
    * swipeRight:
    *    This function switches the players weapon
    * when it detects a swipe on the screen.
    *************************************************/
  @objc func swipeRight(sender:UISwipeGestureRecognizer)
   {
      
      if(NUM_OF_WEAPONS > 0)
      {
         CURRENT_WEAPON += 1
         if(CURRENT_WEAPON > NUM_OF_WEAPONS)
         {
            CURRENT_WEAPON = 1
         }
      }
      
      if(CURRENT_WEAPON == 1)
      {
         equipPistol()
      }
      else if(CURRENT_WEAPON == 2)
      {
         equipRocket()
      }
   }
   
   /************************************************
    * swipeLeft:
    *    This function switches the players weapon
    * when it detects a swipe on the screen.
    *************************************************/
  @objc func swipeLeft(sender:UISwipeGestureRecognizer)
   {
      
      if(NUM_OF_WEAPONS > 0)
      {
         CURRENT_WEAPON -= 1
         
         if(CURRENT_WEAPON < 1)
         {
            CURRENT_WEAPON = 2
         }
      }
      
      if(CURRENT_WEAPON == 1)
      {
         equipPistol()
      }
      else if(CURRENT_WEAPON == 2)
      {
         equipRocket()
      }
   }
   
   
   
   
   
   
   
   
   
   
}

