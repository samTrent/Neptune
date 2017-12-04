//
//  Pistol.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/20/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Pistol: Gun
{
  
   override init()
   {
      //super.init(texture: SKTexture(imageNamed: "pistolRight"), color: UIColor.clear, size: CGSize(width: 20, height: 20))
      
      super.init()
      self.texture = SKTexture(imageNamed: "newPistol")
      self.size = CGSize(width: 45, height: 70) //15
      pickupObjectType = 2
      setSkin(skinName: skin)
      setDamage(damageAmount: 25)
      
      self.xScale = 2
     // self.position.y = -75
      self.weaponType = 1
      self.pickupObjectType = 2
      
      self.physicsBody = SKPhysicsBody(circleOfRadius: skin.size().height / 2, center: CGPoint(x: 1, y: 0))
      
      self.physicsBody?.isDynamic = true
      self.physicsBody?.allowsRotation = false
   }
   
      
   
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
