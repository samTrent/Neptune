//
//  HealthBar.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/22/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBar: SKSpriteNode
{
  
   
   init()
   {
      
      
      super.init(texture: SKTexture(imageNamed: "10"), color: UIColor.clear, size: CGSize(width: 300, height: 50))
      
      self.zPosition = 1

//      self.xScale /= 1.5
      self.yScale /= 1.5
      self.position = CGPoint(x: 0, y: -168) // 160
      
   
      
   }
   
   func setHealthBarPoints(points: Int)
   {
      if (points <= 0)
      {
         self.texture = SKTexture(imageNamed: "Ded")
        
      }
      else
      {
         self.texture = SKTexture(imageNamed: String(points))
        
      }
    
   }
   
   
   
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
