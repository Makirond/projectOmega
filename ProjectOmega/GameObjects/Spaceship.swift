//
//  Spaceship.swift
//  ProjectOmega
//
//  Created by Marc Viricel on 02/01/2019.
//  Copyright © 2019 Marc Viricel. All rights reserved.
//

import Foundation
import GameplayKit
import UIKit

struct SpaceshipConstants {
    static let spaceshipSize: CGFloat = 20
}

class Spaceship: SKSpriteNode {
    
    var reactorNode: SKEmitterNode?
    
    var speedPercent: CGFloat = 0 {
        didSet {
            let maxParticules: CGFloat = 200
            reactorNode?.particleBirthRate = speedPercent * maxParticules
        }
    }
    
    var propulsorForceVector: CGVector?
    
    static func defaultSpaceship() -> Spaceship {
        let spaceship = Spaceship(imageNamed: "Spaceship")
        spaceship.size = CGSize(width: SpaceshipConstants.spaceshipSize, height: SpaceshipConstants.spaceshipSize)
        spaceship.zPosition = 0
        spaceship.physicsBody = defaultSpaceshipBody()
        if let emitterNode = SKEmitterNode(fileNamed: "fireParticles.sks") {
            emitterNode.xScale = 0.3
            emitterNode.yScale = 0.3
            emitterNode.particleBirthRate = 0
            emitterNode.zPosition = -1
            spaceship.addChild(emitterNode)
            spaceship.reactorNode = emitterNode
        }
        return spaceship
    }
    
    private static func defaultSpaceshipBody() -> SKPhysicsBody {
        let bodySize = CGSize(width: 0.8 * SpaceshipConstants.spaceshipSize, height: 0.8 * SpaceshipConstants.spaceshipSize)
        let body = SKPhysicsBody(rectangleOf: bodySize)
        body.friction = 0.8
        body.linearDamping = 0
        body.angularDamping = 0
        body.allowsRotation = false
        return body
    }
    
    func updatePropulsorForceVector() {
        let maxSpeed: CGFloat = 0.2
        let vectorLength = speedPercent * maxSpeed
        let dx = vectorLength * sin(-zRotation)
        let dy = vectorLength * cos(-zRotation)
        propulsorForceVector = CGVector(dx: dx, dy: dy)
    }
}
