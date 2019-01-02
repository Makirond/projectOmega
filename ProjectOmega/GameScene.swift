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

private struct Constants {
    static let planetRadius: CGFloat = 50
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
        let spaceship = Spaceship.defaultSpaceship()
        self.spaceship = spaceship
        addChild(spaceship)
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
