//
//  GameScene.swift
//  ProjectOmega
//
//  Created by Marc Viricel on 23/07/2018.
//  Copyright © 2018 Marc Viricel. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class Spaceship: SKSpriteNode {

    var reactorNode: SKEmitterNode?

    var speedPercent: CGFloat = 0 {
        didSet {
            let maxParticules: CGFloat = 200
            reactorNode?.particleBirthRate = speedPercent * maxParticules
        }
    }

    var propulsorForceVector: CGVector?

    func updatePropulsorForceVector() {
        let maxSpeed: CGFloat = 0.2
        let vectorLength = speedPercent * maxSpeed
        let dx = vectorLength * sin(-zRotation)
        let dy = vectorLength * cos(-zRotation)
        propulsorForceVector = CGVector(dx: dx, dy: dy)
    }
}

private struct Constants {
    static let planetRadius: CGFloat = 50
    static let spaceshipSize: CGFloat = 20
}

class GameScene: SKScene {

    private var planet: SKShapeNode?
    private var spaceship: Spaceship?
    private var pinchRecognizer: UIPinchGestureRecognizer?


    // MARK: - Life cycle

    override func didMove(to view: SKView) {
        physicsWorld.speed = 0.2
        physicsWorld.gravity = .zero

        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handleZoom(for:)))
        view.addGestureRecognizer(pinchRecognizer!)

        addCamera()
        addPlanet()
        addSpaceship()
    }

    @objc
    private func handleZoom(for gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .changed {
//            let newScale = (camera?.xScale ?? 1) + (1.0 - gestureRecognizer.scale)
            let oldScale = 1.0/gestureRecognizer.scale
            camera?.setScale(oldScale)
        }
    }

    // MARK: - Run loop

    override func update(_ currentTime: TimeInterval) {
        spaceship?.updatePropulsorForceVector()
        if let propulsorVector = spaceship?.propulsorForceVector {
            spaceship?.physicsBody?.applyImpulse(propulsorVector)
        }
    }
    
    override func didSimulatePhysics() {
        if let spaceshipPosition = spaceship?.position {
            camera?.position = spaceshipPosition
        }
    }

    // MARK: - Nodes creation

    private func addCamera() {
        let cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
    }

    private func addPlanet() {
        let planet = SKShapeNode(circleOfRadius: Constants.planetRadius)
        planet.fillColor = .white
        planet.zPosition = -1
        planet.physicsBody = createPlanetBody()
        planet.addChild(smallGravityNode())
        self.planet = planet
        addChild(planet)
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
        spaceship.zPosition = 0
        spaceship.physicsBody = createSpaceshipBody()
        if let emitterNode = SKEmitterNode(fileNamed: "fireParticles.sks") {
            emitterNode.xScale = 0.3
            emitterNode.yScale = 0.3
            emitterNode.particleBirthRate = 0
            emitterNode.zPosition = -1
            spaceship.addChild(emitterNode)
            spaceship.reactorNode = emitterNode
        }
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
}

extension GameScene: JoystickDelegate {
    
    func joystickOrientationChanged(to newAngleInRadian: CGFloat){
        spaceship?.zRotation = newAngleInRadian
        physicsBody?.angularVelocity = 0
    }
    
    func joystickPowerChanged(to newValueInPercent:Double){
        spaceship?.speedPercent = CGFloat(newValueInPercent)
    }

}
