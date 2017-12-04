//
//  HealthPack.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/23/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

// HEALTH PACK
class HealthPack: PickupObject
{
   var healthRestore = 1
  
   
   
   override init()
   {
      
      super.init()
      self.size = CGSize(width: 25, height: 25) ///wasnt here before
     
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
      self.texture = SKTexture(imageNamed: "health")
      
      self.zPosition = 1
      self.physicsBody?.isDynamic = true
      pickupType = 1 // the type of pick up (ammo, health, ect...)
      pickupObjectType = 1
     
      
      
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}

//PISTOL AMMO
class PistolAmmo: PickupObject
{
   var ammo = 16
  
   
   override init()
   {
      
      super.init()
      self.size = CGSize(width: 25, height: 25) ///wasnt here before
      
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
      self.texture = SKTexture(imageNamed: "pistolAmmo")
      
      self.zPosition = 1
      self.physicsBody?.isDynamic = true
      pickupType = 2 // the type of pick up (ammo, health, ect...)
      pickupObjectType = 1
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

}

//ROCKET AMMO
class RocketAmmo: PickupObject
{
   var ammo = 2
   
   
   override init()
   {
      
      super.init()
      self.size = CGSize(width: 50, height: 25) ///wasnt here before
      
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
      self.texture = SKTexture(imageNamed: "rocketAmmo")
      
      self.zPosition = 1
      self.physicsBody?.isDynamic = true
      pickupType = 3 // the type of pick up (pistol ammo, rocket ammo, health, ect...)
      pickupObjectType = 1
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}

//ROCKET AMMO
class GranadeAmmo: PickupObject
{
   var ammo = 6
   
   
   override init()
   {
      
      super.init()
      self.size = CGSize(width: 25, height: 25) ///wasnt here before
      
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
      self.texture = SKTexture(imageNamed: "granade")
      
      self.zPosition = 1
      self.physicsBody?.isDynamic = true
      pickupType = 4 // the type of pick up (pistol ammo, rocket ammo, health, ect...)
      pickupObjectType = 1
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}






// SHIP PARTS
class shipPart: PickupObject
{
   
   
   override init()
   {
      
      super.init()
      self.size = CGSize(width: 300, height: 300)
    
      
      self.texture = SKTexture(imageNamed: "shipPart.png")
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width / 15, height: self.frame.size.height / 15)) //15
      self.physicsBody?.restitution = 0.0
      self.physicsBody?.affectedByGravity = true
      
      
      
      
      self.zPosition = 1
      self.physicsBody?.isDynamic = true
      
      self.pickupObjectType = 3
      
      
      
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}

// PLAYERS SHIP
class Ship: PickupObject
{
   
   
   override init()
   {
      
      super.init()
      
      self.size = CGSize(width: 570, height: 175)
      
      
      self.position = CGPoint(x: -350, y: -15)
      
      self.texture = SKTexture(imageNamed: "playerShip.png")
      self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width / 4, height: self.frame.size.height))
      self.physicsBody?.restitution = 0.0
      self.physicsBody?.affectedByGravity = true
      
      
      
      self.zPosition = -1
      self.physicsBody?.isDynamic = true
      
      pickupObjectType = 4
      
      
      
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}
