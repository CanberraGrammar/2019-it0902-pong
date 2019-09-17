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
        topPaddle!.physicsBody = SKPhysicsBody(rectangleOf: topPaddle!.frame.size)
        topPaddle!.physicsBody!.isDynamic = false
        
        bottomPaddle = childNode(withName: "bottomPaddle") as? SKSpriteNode
        bottomPaddle!.physicsBody = SKPhysicsBody(rectangleOf: bottomPaddle!.frame.size)
        bottomPaddle!.physicsBody!.isDynamic = false
        
        ball = childNode(withName: "ball") as? SKSpriteNode
        ball!.physicsBody = SKPhysicsBody(rectangleOf: ball!.frame.size)
        ball!.physicsBody!.restitution = 1
        ball!.physicsBody!.friction = 0
        ball!.physicsBody!.linearDamping = 0
        ball!.physicsBody!.angularDamping = 0
        ball!.physicsBody!.allowsRotation = false
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // Apply an impulse to the ball
        ball!.physicsBody!.applyImpulse(CGVector(dx: 10, dy: 10))
        
        let topNode = SKNode()
        let topLeftPoint = CGPoint(x: -(self.size.width / 2), y: self.size.height / 2)
        let topRightPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        topNode.physicsBody = SKPhysicsBody(edgeFrom: topLeftPoint, to: topRightPoint)
        
        let bottomNode = SKNode()
        let bottomLeftPoint = CGPoint(x: -(self.size.width / 2), y: -(self.size.height / 2))
        let bottomRightPoint = CGPoint(x: self.size.width / 2, y: -(self.size.height / 2))
        bottomNode.physicsBody = SKPhysicsBody(edgeFrom: bottomLeftPoint, to: bottomRightPoint)
        
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
