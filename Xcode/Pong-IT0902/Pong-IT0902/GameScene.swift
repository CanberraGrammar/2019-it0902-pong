//
//  GameScene.swift
//  Pong-IT0902
//
//  Created by MPP on 9/9/19.
//  Copyright © 2019 Matthew Purcell. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var topPaddle: SKSpriteNode?
    var fingerOnTopPaddle: Bool = false
    
    var bottomPaddle: SKSpriteNode?
    var fingerOnBottomPaddle: Bool = false
       
    override func didMove(to view: SKView) {
        
        topPaddle = childNode(withName: "topPaddle") as? SKSpriteNode
        bottomPaddle = childNode(withName: "bottomPaddle") as? SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name == "topPaddle" {
            fingerOnTopPaddle = true
        }
        
        if touchedNode.name == "bottomPaddle" {
            fingerOnBottomPaddle = true
        }
                
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let previousTouchLocation = touch.previousLocation(in: self)
                
        let distanceToMove = touchLocation.x - previousTouchLocation.x
        
        if fingerOnTopPaddle && touchLocation.y > 0 {
        
            topPaddle!.position.x = topPaddle!.position.x + distanceToMove
            
        }
        
        if fingerOnBottomPaddle && touchLocation.y < 0 {
         
            bottomPaddle!.position.x = bottomPaddle!.position.x + distanceToMove
            
        }
                
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if fingerOnTopPaddle {
            fingerOnTopPaddle = false
        }
        
        if fingerOnBottomPaddle {
            fingerOnBottomPaddle = false
        }
        
    }
    
}
