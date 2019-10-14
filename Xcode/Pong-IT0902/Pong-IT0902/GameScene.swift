//
//  GameScene.swift
//  Pong-IT0902
//
//  Created by MPP on 9/9/19.
//  Copyright © 2019 Matthew Purcell. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCategory: UInt32 = 0x1 << 0
    let TopCategory: UInt32 = 0x1 << 1
    let BottomCategory: UInt32 = 0x1 << 2
    
    var topPaddle: SKSpriteNode!
    var fingerOnTopPaddle: Bool = false
    var topScoreLabel: SKLabelNode!
    
    var bottomPaddle: SKSpriteNode!
    var fingerOnBottomPaddle: Bool = false
    var bottomScoreLabel: SKLabelNode!
    
    var ball: SKSpriteNode!
    
    var gameRunning: Bool = false
    
    var topScore = 0
    var bottomScore = 0
       
    override func didMove(to view: SKView) {
        
        topPaddle = childNode(withName: "topPaddle") as? SKSpriteNode
        topPaddle.physicsBody = SKPhysicsBody(rectangleOf: topPaddle.frame.size)
        topPaddle.physicsBody!.isDynamic = false
        
        topScoreLabel = childNode(withName: "topScoreLabel") as? SKLabelNode
        
        bottomPaddle = childNode(withName: "bottomPaddle") as? SKSpriteNode
        bottomPaddle.physicsBody = SKPhysicsBody(rectangleOf: bottomPaddle.frame.size)
        bottomPaddle.physicsBody!.isDynamic = false
        
        bottomScoreLabel = childNode(withName: "bottomScoreLabel") as? SKLabelNode
        
        ball = childNode(withName: "ball") as? SKSpriteNode
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.frame.size)
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.friction = 0
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.angularDamping = 0
        ball.physicsBody!.categoryBitMask = BallCategory
        ball.physicsBody!.contactTestBitMask = TopCategory | BottomCategory
        ball.physicsBody!.allowsRotation = false
        
        let smokeEmitterNode = SKEmitterNode(fileNamed: "SmokeEmitter")
        smokeEmitterNode!.targetNode = self
        ball.addChild(smokeEmitterNode!)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
                
        let topNode = SKNode()
        let topLeftPoint = CGPoint(x: -(self.size.width / 2), y: self.size.height / 2)
        let topRightPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        topNode.physicsBody = SKPhysicsBody(edgeFrom: topLeftPoint, to: topRightPoint)
        topNode.physicsBody!.categoryBitMask = TopCategory
        self.addChild(topNode)
        
        let bottomNode = SKNode()
        let bottomLeftPoint = CGPoint(x: -(self.size.width / 2), y: -(self.size.height / 2))
        let bottomRightPoint = CGPoint(x: self.size.width / 2, y: -(self.size.height / 2))
        bottomNode.physicsBody = SKPhysicsBody(edgeFrom: bottomLeftPoint, to: bottomRightPoint)
        bottomNode.physicsBody!.categoryBitMask = BottomCategory
        self.addChild(bottomNode)
        
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
        
        if gameRunning == false {
            
            // Generate a random number between 0 and 1 (inclusive)
            let randomNumber = Int(arc4random_uniform(2))
            
            if randomNumber == 0 {
            
                // Apply an impulse to the ball
                ball.physicsBody!.applyImpulse(CGVector(dx: 10, dy: 10))
                
            }
            
            else {
                
                ball.physicsBody!.applyImpulse(CGVector(dx: -10, dy: -10))
                
            }
            
            gameRunning = true
            
        }
                
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let previousTouchLocation = touch.previousLocation(in: self)
                
        let distanceToMove = touchLocation.x - previousTouchLocation.x
        
        if fingerOnTopPaddle && touchLocation.y > 0 {
            
            let paddleNewX = topPaddle.position.x + distanceToMove
            
            if (paddleNewX - topPaddle.size.width / 2) > -(self.size.width / 2) && (paddleNewX + topPaddle.size.width / 2 < (self.size.width / 2)) {
        
                topPaddle.position.x = paddleNewX
                
            }
            
        }
        
        if fingerOnBottomPaddle && touchLocation.y < 0 {
         
            let paddleNewX = bottomPaddle.position.x + distanceToMove
            
            if (paddleNewX - bottomPaddle.size.width / 2) > -(self.size.width / 2) && (paddleNewX + bottomPaddle.size.width / 2 < (self.size.width / 2)) {
            
                bottomPaddle.position.x = paddleNewX
                
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
    
    func resetGame() {
        
        // Reset the ball - center of the screen
        ball.position.x = 0
        ball.position.y = 0
        
        // Reset the paddles to their original location
        topPaddle.position.x = 0
        bottomPaddle.position.x = 0
        
        // Stop the ball from moving
        ball.physicsBody!.isDynamic = false
        ball.physicsBody!.isDynamic = true
        
        // Alternative way to stop the ball from moving
        // ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        
        // Unpause the view
        self.view!.isPaused = false
        
    }
    
    func gameOver() {
        
        // Pause the game
        self.view!.isPaused = true
        self.gameRunning = false
        
        // Show an alert
        let gameOverAlert = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
        let gameOverAction = UIAlertAction(title: "Okay", style: .default) { (theAlertAction) in
            
            // Reset game
            self.resetGame()
            
        }
        
        gameOverAlert.addAction(gameOverAction)
        
        self.view!.window!.rootViewController!.present(gameOverAlert, animated: true, completion: nil)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == BottomCategory) || (contact.bodyB.categoryBitMask == BottomCategory) {
            print("Bottom collision")
            
            topScore += 1
            topScoreLabel.text = String(topScore)
            
            gameOver()
        }
        
        else if (contact.bodyA.categoryBitMask == TopCategory) || (contact.bodyB.categoryBitMask == TopCategory) {
            print("Top collision")
            
            bottomScore += 1
            bottomScoreLabel.text = String(bottomScore)
            
            gameOver()
        }
        
        
    }
    
}
