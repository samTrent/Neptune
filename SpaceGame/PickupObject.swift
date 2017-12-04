//
//  PickupObject.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/23/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class PickupObject: SKSpriteNode
{
   
   var pickupObjectType = 1 // pickup object , gun or ship part
   var weaponType = 0 // for guns
   var pickupType = 0 // the type of pick up (ammo, health, ect...)
   init()
   {
      
      
      super.init(texture: SKTexture(imageNamed: ""), color: UIColor.clear, size: CGSize(width: 50, height: 50))
      
      self.zPosition = 1
      
      
      
      
      
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}
