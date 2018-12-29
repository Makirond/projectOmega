//
//  GameViewController.swift
//  ProjectOmega
//
//  Created by Marc Viricel on 23/07/2018.
//  Copyright © 2018 Marc Viricel. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private let scene: GameScene = {
        let scene = GameScene()
        scene.scaleMode = .aspectFill
        return scene
    }()

    private let leftJoystick = UIView()
    private let rightJoystick = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as? SKView else {
            return
        }
            view.addSubview(leftJoystick)
            leftJoystick.backgroundColor = .red
            leftJoystick.clipsToBounds = true
            leftJoystick.frame = CGRect(x: 0, y: 0, width: 50, height: view.bounds.size.height)
            let leftGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleLeftJoystickPan(gesture:)))
            leftJoystick.addGestureRecognizer(leftGestureRecognizer)

            view.addSubview(rightJoystick)
            rightJoystick.backgroundColor = .blue
            rightJoystick.clipsToBounds = true
            rightJoystick.frame = CGRect(x: view.bounds.size.width - 50, y: 0, width: 50, height: view.bounds.size.height)
            let rightGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleRightJoystickPan(gesture:)))
            rightJoystick.addGestureRecognizer(rightGestureRecognizer)

            var sceneSize = view.bounds.size
            sceneSize.width -= leftJoystick.frame.size.width
            sceneSize.width -= rightJoystick.frame.size.width
            scene.size = sceneSize
            view.presentScene(scene)

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
    }

    @objc private func handleLeftJoystickPan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: leftJoystick)
        let powerInPercent = 1.0 - location.y / view.bounds.size.height
        scene.leftJoystickPowerChanged(to: Double(powerInPercent))
    }

    @objc private func handleRightJoystickPan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: rightJoystick)
        let powerInPercent = 1.0 - location.y / view.bounds.size.height
        scene.rightJoystickPowerChanged(to: Float(powerInPercent))
    }
}
