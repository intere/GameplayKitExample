//
//  SpriteComponent.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/18/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
    let boardEntity: BoardEntity
    let node: SKSpriteNode
    let level: Level
    let gridMapper: GridMapping

    init(with entity: BoardEntity, color: SKColor, unitSize: CGFloat, level: Level, gridMapper: GridMapping) {
        boardEntity = entity
        node = SKSpriteNode(color: color, size: CGSize(width: unitSize, height: unitSize))
        node.anchorPoint = CGPoint(x: 0, y: 0)

        node.position = gridMapper.convert(gridPoint: entity.gridIndex)
        self.level = level
        self.gridMapper = gridMapper
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - API

extension SpriteComponent {

    func move(to gridPoint: BoardPoint) {
        boardEntity.gridIndex = gridPoint
        move(to: gridMapper.convert(gridPoint: gridPoint))
    }

}

// MARK: - Helpers

fileprivate extension SpriteComponent {

    func move(to point: CGPoint) {
        node.run(SKAction.move(to: point, duration: 0.3))
    }
    
}
