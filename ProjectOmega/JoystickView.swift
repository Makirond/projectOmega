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
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 4
            
            centerCircleView?.removeFromSuperview()
            centerCircleView = UIView()
            centerCircleView?.clipsToBounds = true
            let centerCircleViewSize = 0.5 * minSide
            centerCircleView?.frame = CGRect(x: 0, y: 0, width: centerCircleViewSize, height: centerCircleViewSize)
            centerCircleView?.center = CGPoint(x: 0.5 * frame.size.width, y: 0.5 * frame.size.height)
            centerCircleView?.layer.cornerRadius = 0.5 * centerCircleViewSize
            centerCircleView?.layer.borderColor = UIColor.white.cgColor
            centerCircleView?.layer.borderWidth = 2
            addSubview(centerCircleView!)
        }
    }
    
    private var centerCircleView: UIView?
    private var fingerTipView: UIView = {
        let fingerViewSize: CGFloat = 40
        let fingerView = UIView(frame: CGRect(x: 0, y: 0, width: fingerViewSize, height: fingerViewSize))
        fingerView.layer.cornerRadius = 0.5 * fingerViewSize
        fingerView.backgroundColor = UIColor.white
        return fingerView
    }()
    
    weak var joystickDelegate: JoystickDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(fingerTipView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        touchHappened(touch: touch, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        touchHappened(touch: touch, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystickDelegate?.joystickPowerChanged(to: 0)
    }

    private func touchHappened(touch: UITouch, with event: UIEvent?) {
        let location = touch.location(in: superview)
        let distanceToCenter = location.distance(to: center)
        let minSide = min(frame.size.width, frame.size.height)
        let internalRingSize = 0.25 * minSide
        if distanceToCenter <= 0.5 * minSide {
            fingerTipView.center = touch.location(in: self)
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
