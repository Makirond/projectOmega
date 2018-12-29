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

private struct Constants {
    static let joystickSize: CGFloat = 200.0
    static let centerJoystickZoneSize: CGFloat = 0.5 * joystickSize
}

class GameViewController: UIViewController {
    
    private let scene: GameScene = {
        let scene = GameScene()
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    private let joystickView = UIView()
    private let joystickCenterView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else {
            return
        }
        view.addSubview(joystickView)
        joystickView.backgroundColor = .white
        joystickView.clipsToBounds = true
        joystickView.frame = CGRect(x: view.bounds.size.width - Constants.joystickSize,
                                    y: view.bounds.size.height - Constants.joystickSize,
                                    width: Constants.joystickSize,
                                    height: Constants.joystickSize)
        joystickView.layer.cornerRadius = 0.5 * Constants.joystickSize
        let leftGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                           action: #selector(handleJoystickPan(gesture:)))
        joystickView.addGestureRecognizer(leftGestureRecognizer)
        
        view.addSubview(joystickCenterView)
        joystickCenterView.backgroundColor = .black
        joystickCenterView.clipsToBounds = true
        joystickCenterView.frame = CGRect(x: 0,
                                          y: 0,
                                          width: Constants.centerJoystickZoneSize,
                                          height: Constants.centerJoystickZoneSize)
        joystickCenterView.layer.cornerRadius = 0.5 * Constants.centerJoystickZoneSize
        joystickCenterView.center = joystickView.center
        joystickCenterView.isUserInteractionEnabled = false
        
        scene.size = view.bounds.size
        view.presentScene(scene)
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
    
    @objc private func handleJoystickPan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: scene.view)
        let distanceToCenter = location.distance(to: joystickView.center)
        if distanceToCenter <= 0.5 * Constants.joystickSize {
            let dx = location.x - joystickView.center.x
            let dy = location.y - joystickView.center.y
            let angle = -atan2(dy, dx) - CGFloat.pi / 2.0
            scene.joystickOrientationChanged(to: angle)

            if distanceToCenter > 0.5 * Constants.centerJoystickZoneSize {
                let powerInPercent = (distanceToCenter - 0.5 * Constants.centerJoystickZoneSize)
                    / (0.5 * (Constants.joystickSize - Constants.centerJoystickZoneSize))
                scene.joystickPowerChanged(to: Double(powerInPercent))
            }
        }
    }
}

extension CGPoint {
    fileprivate func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
