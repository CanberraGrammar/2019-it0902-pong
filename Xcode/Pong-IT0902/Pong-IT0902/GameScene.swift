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
    
    var ball: SKSpriteNode?
       
    override func didMove(to view: SKView) {
        
        topPaddle = childNode(withName: "topPaddle") as? SKSpriteNode
        bottomPaddle = childNode(withName: "bottomPaddle") as? SKSpriteNode
        
        ball = childNode(withName: "ball") as? SKSpriteNode
        ball!.physicsBody = SKPhysicsBody(rectangleOf: ball!.frame.size)
        
        // self.physicsWorld.gravity = CGVector(dx: 0.3, dy: 0.3)
        
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
            
            let paddleNewX = topPaddle!.position.x + distanceToMove
            
            if (paddleNewX - topPaddle!.size.width / 2) > -(self.size.width / 2) && (paddleNewX + topPaddle!.size.width / 2 < (self.size.width / 2)) {
        
                topPaddle!.position.x = paddleNewX
                
            }
            
        }
        
        if fingerOnBottomPaddle && touchLocation.y < 0 {
         
            let paddleNewX = bottomPaddle!.position.x + distanceToMove
            
            if (paddleNewX - bottomPaddle!.size.width / 2) > -(self.size.width / 2) && (paddleNewX + bottomPaddle!.size.width / 2 < (self.size.width / 2)) {
            
                bottomPaddle!.position.x = paddleNewX
                
            }
            
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
