//
//  VisualComponent.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/18/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit
import SpriteKit

class VisualComponent: GKComponent {
    let node: SKNode

    init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - API

extension VisualComponent {

    func move(to point: CGPoint) {
        node.run(SKAction.move(to: point, duration: 0.3))
    }

}
