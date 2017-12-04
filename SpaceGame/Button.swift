//
//  Button.swift
//  SpaceGame
//
//  Created by Sam Trent on 12/18/16.
//  Copyright © 2016 Trent&McLerranStudios. All rights reserved.
//

//import Foundation
import SpriteKit

class Button: SKNode
{
   var defaultButton: SKSpriteNode // defualt state
   var activeButton: SKSpriteNode  // active state
   
   
   var timer = Timer()
   
   @objc var action: () -> Void
   
   var buttonPressed = false
   
   
   //default constructor
   init(defaultButtonImage: String, activeButtonImage: String, buttonAction: @escaping () -> Void )
   {
      //get the images for both button states
      defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
      activeButton = SKSpriteNode(imageNamed: activeButtonImage)
      
      //hide it while not in use
      activeButton.isHidden = true
      
      action = buttonAction
      
      super.init()
      

      isUserInteractionEnabled = true
      self.zPosition = 1
     
      
      addChild(defaultButton)
      addChild(activeButton)
      
      
   }
   
   
   
   //When user touches button
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
   {
      buttonPressed = true
      action()
      self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getter: Button.action), userInfo: nil, repeats: true)
      
      
      
      //swtich the image of our button
      activeButton.isHidden = false
      defaultButton.isHidden = true
   
   }
   
   //Determine if a user moved their finger on or off the button...
   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
   {
      
      let touch: UITouch = touches.first!
      let location: CGPoint = touch.previousLocation(in: self)
      
      if defaultButton.contains(location)
      {
         activeButton.isHidden = false
         defaultButton.isHidden = true
      }
      else
      {
         activeButton.isHidden = true
         defaultButton.isHidden = false
      }
   }
   
   //Determine if the button was actually tapped...
   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
   {
      let touch: UITouch = touches.first!
      let location: CGPoint = touch.previousLocation(in: self)
      
      buttonPressed = false
      
      if defaultButton.contains(location)
      {
           //call the action of the button...
          // action()
      }
   
      activeButton.isHidden = true
      defaultButton.isHidden = false
      timer.invalidate()
   }
   
   public func isPressed() -> Bool
   {
      return buttonPressed
   }
   
   func setIcon(icon: String)
   {
       defaultButton.texture = SKTexture(imageNamed: icon)
      
   }
  
  
   
   
   //throw warning...
   required init?(coder aDecoder: NSCoder)
   {
      fatalError("init(coder:) has not been implemented")
   }
}
