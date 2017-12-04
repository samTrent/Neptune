//
//  Gun.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/20/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Gun: PickupObject
{
   var skin:String = ""
   var damage = 0
   
   
   
   
   
   
   
   
   
   func getDamage() -> Int
   {
      return damage
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

   
   func setDamage(damageAmount: Int)
   {
      damage = damageAmount
   }
   
   
   func setSkin(skinName: String)
   {
      skin = skinName
   }
   
   
   
   
   
}
