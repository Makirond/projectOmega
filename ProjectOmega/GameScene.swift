//
//  GameScene.swift
//  ProjectOmega
//
//  Created by Marc Viricel on 23/07/2018.
//  Copyright © 2018 Marc Viricel. All rights reserved.
//

import SpriteKit
import GameplayKit

class Spaceship: SKSpriteNode {
    var propulsorForceDirection: CGVector? {
        didSet {
            if let vector = propulsorForceDirection {
                let vectorLength: CGFloat = 0.2
                let adaptingRatio = sqrt((pow(vector.dx, 2) + pow(vector.dy, 2)) / pow(vectorLength, 2))
                propulsorForceDirection = CGVector(dx: vector.dx / adaptingRatio, dy: vector.dy / adaptingRatio)
            }
        }
    }
}

class GameScene: SKScene {

    private var spaceship: Spaceship?

    override func didMove(to view: SKView) {
        physicsWorld.speed = 0.2
        physicsWorld.gravity = .zero
        addBackground()
        addPlanet()
        addSpaceship()
    }

    override func update(_ currentTime: TimeInterval) {
        if let propulsorVector = spaceship?.propulsorForceDirection {
            spaceship?.physicsBody?.applyImpulse(propulsorVector)
        }
    }

    private func addBackground() {
        let spaceBackground = SKSpriteNode(imageNamed: "BlueSpace.jpg")
        spaceBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        spaceBackground.zPosition = -2
        addChild(spaceBackground)
    }

    private func addPlanet() {
        let planetGround = SKShapeNode(circleOfRadius: 50)
        planetGround.position = CGPoint(x: size.width/2, y: size.height/2)
        planetGround.fillColor = .white
        planetGround.zPosition = -1
        let planetGroundPhysic = SKPhysicsBody(circleOfRadius: 50)
        planetGroundPhysic.friction = 0.8
        planetGroundPhysic.isDynamic = false
        planetGround.physicsBody = planetGroundPhysic
        let gravity = SKFieldNode.radialGravityField()
        gravity.strength = 3
        planetGround.addChild(gravity)
        addChild(planetGround)
    }

    private func addSpaceship() {
        let spaceship = Spaceship(imageNamed: "Spaceship")
        spaceship.size = CGSize(width: 20, height: 20)
        spaceship.position = CGPoint(x: size.width / 2, y: 0.8 * size.height)
        spaceship.zPosition = 0
        let bodySize = CGSize(width: 0.8 * spaceship.size.width, height: 0.8 * spaceship.size.height)
        let spaceshipPhysics = SKPhysicsBody(rectangleOf: bodySize)
        spaceshipPhysics.friction = 0.8
        spaceshipPhysics.linearDamping = 0
        spaceshipPhysics.angularDamping = 0
        spaceship.physicsBody = spaceshipPhysics
        self.spaceship = spaceship
        addChild(spaceship)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let mainTouchLocation = touches.first?.location(in: self),
        let spaceship = spaceship else {
            return
        }
        let dx = mainTouchLocation.x - spaceship.position.x
        let dy = mainTouchLocation.y - spaceship.position.y
        spaceship.propulsorForceDirection = CGVector(dx: dx, dy: dy)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let mainTouchLocation = touches.first?.location(in: self),
            let spaceship = spaceship else {
                return
        }
        let dx = mainTouchLocation.x - spaceship.position.x
        let dy = mainTouchLocation.y - spaceship.position.y
        spaceship.propulsorForceDirection = CGVector(dx: dx, dy: dy)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        spaceship?.propulsorForceDirection = nil
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        spaceship?.propulsorForceDirection = nil
    }
}
