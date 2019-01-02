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
    static let joystickSize: CGFloat = 150.0
    static let centerJoystickZoneSize: CGFloat = 0.5 * joystickSize
    static let joystickMargin: CGFloat = 40.0
}

class GameViewController: UIViewController {
    
    private let scene: GameScene = {
        let scene = GameScene()
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    private let joystickView = JoystickView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else {
            return
        }
        
        view.addSubview(joystickView)
        joystickView.joystickDelegate = scene
        joystickView.frame = CGRect(x: view.bounds.size.width - Constants.joystickSize - Constants.joystickMargin,
                                    y: view.bounds.size.height - Constants.joystickSize - Constants.joystickMargin,
                                    width: Constants.joystickSize,
                                    height: Constants.joystickSize)

        
        scene.size = view.bounds.size
        view.presentScene(scene)
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
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
