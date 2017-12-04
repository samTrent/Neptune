//
//  Object.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/20/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit


class Object: SKSpriteNode
{
   var isAGranade = false // needed for granded...
   var expireTime = 0 // remove obj from scene if time is expired.
   var explosionDamage = 0 // if the object explodes it does damage.
   
   var skin = SKTexture(imageNamed: "pipeUpbigger")
   
   init(color: UIColor, size: CGSize, posistion: CGPoint)
   {
      super.init(texture: skin, color: UIColor.clear, size: size)
      
      
      self.position = posistion
      // line on the bottom of the screen
       self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
      //self.physicsBody = SKPhysicsBody(circleOfRadius: 50)
      //no gravity for gound
      self.physicsBody?.isDynamic = true
      
   
   }   
   
   
   
   
   
   func explosion()
   {
      //stubb
   }
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
   
   
   
}
