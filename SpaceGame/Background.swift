//
//  Background.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/19/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKSpriteNode
{
   //var skin = SKTexture(imageNamed: "desert")
   //var skin = SKTexture(imageNamed: "forest")
   var skin:SKTexture
   
   
   // default constuctor
   init(color: UIColor, size: CGSize)
   {
      skin = SKTexture(imageNamed: "NeptuneNew")
      super.init(texture: skin, color: UIColor.clear, size: size)
      
      
   }
   
   
   
   func changeBackGround(textureName: SKTexture)
   {
      skin = textureName
   }
   
   
   
   
   
   
   
   
   
   
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
   
   

}
