//
//  EntityType.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/20/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit
import GameplayKit

enum EntityType {
    case player
    case enemy
    case powerUp

    /// Gets you the collision bitmask for the entity type
    var mask: UInt32 {
        switch self {
        case .player:
            return 1 << 1

        case .enemy:
            return 1 << 2

        case .powerUp:
            return 1 << 3
        }
    }

    /// Gets you the contact test bitmask for the entity type
    var contactMask: UInt32 {
        switch self {
        case .player:
            return EntityType.enemy.mask | EntityType.powerUp.mask

        case .enemy:
            return EntityType.player.mask

        case .powerUp:
            return EntityType.player.mask
        }
    }

    /// Creates and returns you the appropriate physics body for the node type.
    ///
    /// - Parameter node: The SpriteNode to create the physics body for.
    /// - Returns: The Physics Body for the provided node
    func physicsBody(node: SKSpriteNode) -> SKPhysicsBody? {
        let center = CGPoint(x: node.size.width * (node.anchorPoint.x + 0.5), y: node.size.height * (0.5 - node.anchorPoint.y))
        let physicsBody = SKPhysicsBody(rectangleOf: node.size, center: center)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = mask
        physicsBody.contactTestBitMask = contactMask
        physicsBody.collisionBitMask = 0


        return physicsBody
    }
}
