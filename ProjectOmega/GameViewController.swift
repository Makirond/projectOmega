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

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {

            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill

            view.presentScene(scene)

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
}
