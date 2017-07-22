//
//  BoardEntity.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit

/// Represents an entity on the board
class BoardEntity: GKEntity {
    
    var gridIndex: BoardPoint
    var entityType: EntityType

    init(gridIndex: BoardPoint, type: EntityType) {
        self.gridIndex = gridIndex
        self.entityType = type
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Gets you the sprite for this Board Entity (if one exists)
    var sprite: SKNode? {
        for component in components {
            guard let spriteComponent = component as? SpriteComponent else {
                continue
            }
            return spriteComponent.node
        }
        return nil
    }

    /// Gets you the Intelligence Component (AI) for this Board Entity.
    var intelligence: IntelligenceComponent? {
        for component in components {
            guard let intelligenceComponent = component as? IntelligenceComponent else {
                continue
            }
            return intelligenceComponent
        }
        return nil
    }
}
