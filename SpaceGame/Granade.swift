//
//  Granade.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/30/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Granade: Gun
{
   
   override init()
   {
      super.init()
      
      self.texture = SKTexture(imageNamed: "granade")
      self.size = CGSize(width: 10, height: 20)
      pickupObjectType = 2
      setSkin(skinName: skin)
      setDamage(damageAmount: 25)
      
      self.xScale = 2
      // self.position.y = -75
      self.weaponType = 3
     
      
      self.physicsBody = SKPhysicsBody(circleOfRadius: skin.size().height / 2, center: CGPoint(x: 1, y: 0))
      
      self.physicsBody?.isDynamic = true
      self.physicsBody?.allowsRotation = false
   }
   
   
   
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
