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

private struct Constants {
    static let planetRadius: CGFloat = 50
    static let spaceshipSize: CGFloat = 20
}

class GameScene: SKScene {

    private var spaceship: Spaceship?

    // MARK: - Life cycle

    override func didMove(to view: SKView) {
        physicsWorld.speed = 0.2
        physicsWorld.gravity = .zero
        addBackground()
        addPlanet()
        addSpaceship()
    }

    // MARK: - Run loop

    override func update(_ currentTime: TimeInterval) {
        if let propulsorVector = spaceship?.propulsorForceDirection {
            spaceship?.physicsBody?.applyImpulse(propulsorVector)
        }
    }

    // MARK: - Nodes creation

    private func addBackground() {
        let spaceBackground = SKSpriteNode(imageNamed: "BlueSpace.jpg")
        spaceBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        spaceBackground.zPosition = -2
        addChild(spaceBackground)
    }

    private func addPlanet() {
        let planetGround = SKShapeNode(circleOfRadius: Constants.planetRadius)
        planetGround.position = CGPoint(x: size.width/2, y: size.height/2)
        planetGround.fillColor = .white
        planetGround.zPosition = -1
        planetGround.physicsBody = createPlanetBody()
        planetGround.addChild(smallGravityNode())
        addChild(planetGround)
    }

    private func createPlanetBody() -> SKPhysicsBody {
        let body = SKPhysicsBody(circleOfRadius: Constants.planetRadius)
        body.friction = 0.8
        body.isDynamic = false
        return body
    }

    private func smallGravityNode() -> SKFieldNode {
        let gravity = SKFieldNode.radialGravityField()
        gravity.strength = 3
        return gravity
    }

    private func addSpaceship() {
        let spaceship = Spaceship(imageNamed: "Spaceship")
        spaceship.size = CGSize(width: Constants.spaceshipSize, height: Constants.spaceshipSize)
        spaceship.position = CGPoint(x: size.width / 2, y: 0.8 * size.height)
        spaceship.zPosition = 0
        spaceship.physicsBody = createSpaceshipBody()
        self.spaceship = spaceship
        addChild(spaceship)
    }

    private func createSpaceshipBody() -> SKPhysicsBody {
        let bodySize = CGSize(width: 0.8 * Constants.spaceshipSize, height: 0.8 * Constants.spaceshipSize)
        let body = SKPhysicsBody(rectangleOf: bodySize)
        body.friction = 0.8
        body.linearDamping = 0
        body.angularDamping = 0
        return body
    }

    // MARK: - Events handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let mainTouchLocation = touches.first?.location(in: self),
        let spaceship = spaceship else {
            return
        }
        spaceship.propulsorForceDirection = vector(for: mainTouchLocation, comparedTo: spaceship)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let mainTouchLocation = touches.first?.location(in: self),
            let spaceship = spaceship else {
                return
        }
        spaceship.propulsorForceDirection = vector(for: mainTouchLocation, comparedTo: spaceship)
    }

    private func vector(for touchPosition: CGPoint, comparedTo node:SKNode) -> CGVector {
        let dx = touchPosition.x - node.position.x
        let dy = touchPosition.y - node.position.y
        return CGVector(dx: dx, dy: dy)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        spaceship?.propulsorForceDirection = nil
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        spaceship?.propulsorForceDirection = nil
    }
}
