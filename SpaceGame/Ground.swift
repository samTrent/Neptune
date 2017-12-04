//
//  Ground.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/19/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit


class Ground: SKNode, SKPhysicsContactDelegate
{
   
   override init()
   {
      super.init()
      
      self.position = CGPoint(x: 0, y: -100)
      // line on the bottom of the screen
     // self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 1000, height: 1))
      self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -100000, y: 0), to: CGPoint(x: 100000, y: 0))
      //no gravity for gound
      self.physicsBody?.isDynamic = true
      self.physicsBody?.affectedByGravity = false
   
      

   }
   
   
   
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
   
}


class LeftWall: SKNode, SKPhysicsContactDelegate
{
   
   override init()
   {
      super.init()
      
      self.position = CGPoint(x: -350, y: 0)
      // line on the bottom of the screen
      // self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 1000, height: 1))
      self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -100000), to: CGPoint(x: 0, y: 100000))
      //no gravity for gound
      self.physicsBody?.isDynamic = true
      self.physicsBody?.affectedByGravity = false
      
      
      
   }
   
   
   
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
   
}



class RightWall: SKNode, SKPhysicsContactDelegate
{
   
   override init()
   {
      super.init()
      
      self.position = CGPoint(x: 350, y: 0)
      // line on the bottom of the screen
      // self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 1000, height: 1))
      self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -100000), to: CGPoint(x: 0, y: 100000))
      //no gravity for gound
      self.physicsBody?.isDynamic = true
      self.physicsBody?.affectedByGravity = false
      
      
      
   }
   
   
   
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
   
}

