//
//  GameScene.swift
//  ProjectOmega
//
//  Created by Marc Viricel on 23/07/2018.
//  Copyright © 2018 Marc Viricel. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var spaceship: SKSpriteNode?

    override func didMove(to view: SKView) {
        addBackground()
        addPlanetGround()
        addSpaceship()
        addLandingPlatform()
    }

    private func addBackground() {
        let spaceBackground = SKSpriteNode(imageNamed: "BlueSpace.jpg")
        spaceBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        spaceBackground.zPosition = -2
        addChild(spaceBackground)
    }

    private func addPlanetGround() {
        let planetGround = SKSpriteNode(imageNamed: "MoonSurface")
        planetGround.scale(to: CGSize(width: size.width, height: size.height/4))
        planetGround.position = CGPoint(x: planetGround.size.width/2, y: 0)
        planetGround.zPosition = -1
        let planetGroundPhysic = SKPhysicsBody(rectangleOf: planetGround.frame.size)
        planetGroundPhysic.friction = 0.8
        planetGroundPhysic.isDynamic = false
        planetGround.physicsBody = planetGroundPhysic
        addChild(planetGround)
    }

    private func addSpaceship() {
        let spaceship = SKSpriteNode(imageNamed: "Spaceship")
        spaceship.size = CGSize(width: 100, height: 100)
        spaceship.position = CGPoint(x: 100, y: size.height)
        spaceship.zPosition = 0
        let bodySize = CGSize(width: 0.8 * spaceship.size.width, height: 0.8 * spaceship.size.height)
        let spaceshipPhysics = SKPhysicsBody(rectangleOf: bodySize)
        spaceshipPhysics.friction = 0.8
        spaceship.physicsBody = spaceshipPhysics
        self.spaceship = spaceship
        addChild(spaceship)
    }

    private func addLandingPlatform() {
        let landingNode = SKShapeNode(rectOf: CGSize(width: 200, height: 40), cornerRadius: 10)
        landingNode.fillColor = .gray
        landingNode.position = CGPoint(x: 0.8 * size.width, y: 0.5 * size.height)
        let landingNodeBody = SKPhysicsBody(rectangleOf: landingNode.frame.size)
        landingNodeBody.isDynamic = false
        landingNode.physicsBody = landingNodeBody
        addChild(landingNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let mainTouchLocation = touches.first?.location(in: self),
        let spaceship = self.spaceship else {
            return
        }
        var forceVector = CGVector(dx: mainTouchLocation.x - spaceship.position.x, dy: mainTouchLocation.y - spaceship.position.y)
        forceVector.dx = forceVector.dx < 0 ? -40 : 40
        forceVector.dy = forceVector.dy < 0 ? -120 : 120
        spaceship.physicsBody?.applyImpulse(forceVector)
    }
}
