//
//  Joystick.swift
//  ProjectOmega
//
//  Created by Marc Viricel on 29/12/2018.
//  Copyright © 2018 Marc Viricel. All rights reserved.
//

import Foundation
import UIKit

protocol JoystickDelegate: class {
    func joystickOrientationChanged(to newAngleInRadian: CGFloat)
    func joystickPowerChanged(to newValueInPercent:Double)
}

class JoystickView: UIView {
    
    override var frame: CGRect {
        didSet {
            let minSide = min(frame.size.width, frame.size.height)
            layer.cornerRadius = 0.5 * minSide
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 2
            
            centerCircleView?.removeFromSuperview()
            centerCircleView = UIView()
            centerCircleView?.clipsToBounds = true
            let centerCircleViewSize = 0.5 * minSide
            centerCircleView?.frame = CGRect(x: 0, y: 0, width: centerCircleViewSize, height: centerCircleViewSize)
            centerCircleView?.center = CGPoint(x: 0.5 * frame.size.width, y: 0.5 * frame.size.height)
            centerCircleView?.layer.cornerRadius = 0.5 * centerCircleViewSize
            centerCircleView?.layer.borderColor = UIColor.green.cgColor
            centerCircleView?.layer.borderWidth = 2
            addSubview(centerCircleView!)
        }
    }
    
    private var centerCircleView: UIView?
    
    weak var joystickDelegate: JoystickDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        touchHappened(touch: touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        touchHappened(touch: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystickDelegate?.joystickPowerChanged(to: 0)
    }

    private func touchHappened(touch: UITouch) {
        let location = touch.location(in: superview)
        let distanceToCenter = location.distance(to: center)
        let minSide = min(frame.size.width, frame.size.height)
        let internalRingSize = 0.25 * minSide
        if distanceToCenter <= 0.5 * minSide {
            let dx = location.x - center.x
            let dy = location.y - center.y
            let angle = -atan2(dy, dx) - CGFloat.pi / 2.0
            joystickDelegate?.joystickOrientationChanged(to: angle)

            var powerInPercent: CGFloat = 0
            if distanceToCenter > internalRingSize {
                powerInPercent = (distanceToCenter - internalRingSize) / (internalRingSize)
                powerInPercent = min(powerInPercent, 1.0)
            }
            joystickDelegate?.joystickPowerChanged(to: Double(powerInPercent))
        }
    }
}
