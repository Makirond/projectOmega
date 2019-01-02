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
        
        joystickView.joystickDelegate = scene
        joystickView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: Constants.joystickSize,
                                    height: Constants.joystickSize)
        
        
        scene.size = view.bounds.size
        view.presentScene(scene)
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
            let location = touches.first?.location(in: view) else {
                return
        }
        joystickView.center = location
        view.addSubview(joystickView)
        joystickView.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else {
            return
        }
        joystickView.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else {
            return
        }
        joystickView.touchesEnded(touches, with: event)
        joystickView.removeFromSuperview()
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
