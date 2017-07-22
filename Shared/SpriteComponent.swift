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
    fileprivate var nextGridPosition: BoardPoint?
    typealias Block = () -> Void

    init(with entity: BoardEntity, color: SKColor, unitSize: CGFloat, level: Level, gridMapper: GridMapping, type: EntityType) {
        boardEntity = entity
        switch type {
        case .player, .enemy:
            node = SKSpriteNode(color: color, size: CGSize(width: unitSize, height: unitSize))
            node.position = gridMapper.convert(gridPoint: entity.gridIndex)
        case .powerUp:
            node = SKSpriteNode(texture: SKTexture(imageNamed: "oval"))
            node.size = CGSize(width: unitSize, height: unitSize)
            node.position = gridMapper.convert(gridPoint: entity.gridIndex)
            node.position = CGPoint(x: node.position.x + unitSize/2, y: node.position.y + unitSize/2)
        }

        node.entity = entity
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.physicsBody = type.physicsBody(node: node)

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

    func update(nextGridPosition point: BoardPoint) {
        nextGridPosition = point
        move(to: gridMapper.convert(gridPoint: point)) {
            self.boardEntity.gridIndex = point
        }
    }

    func warp(toGridPosition point: BoardPoint) {
        node.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.move(to: gridMapper.convert(gridPoint: point), duration: 0.5),
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.run {
                self.boardEntity.gridIndex = point
            }
        ]))
    }

    func follow(path: [GKGridGraphNode], completion: Block?) {
        var sequence = [SKAction]()

        for node in path.dropFirst() {
            let gridPoint = node.gridPosition.boardPoint
            let point = gridMapper.convert(gridPoint: gridPoint)
            sequence.append(SKAction.move(to: point, duration: 0.15))
            sequence.append(SKAction.run {
                self.boardEntity.gridIndex = gridPoint
            })
        }
        if let completion = completion {
            sequence.append(SKAction.run {
                completion()
            })
        }
        node.run(SKAction.sequence(sequence))
    }

    /// Temporarily changes the color of this sprite Node
    ///
    /// - Parameters:
    ///   - color: The temporary color change
    ///   - time: The amount of time to change the color for
    ///   - callback: optional callback that executes once the actions have completed
    func temporaryChange(color: NSColor, time: TimeInterval, callback: (() -> Void)? = nil) {
        let originalColor = node.color

        // Change the color now
        node.run(SKAction.customAction(withDuration: 0.3, actionBlock: { (node, value) in
            (node as? SKSpriteNode)?.color = color
        }))

        // Queue up the color switch back
        DispatchQueue.main.asyncAfter(deadline: .now() + time - 0.3) {
            self.node.run(SKAction.customAction(withDuration: 0.3, actionBlock: { (node, value) in
                (node as? SKSpriteNode)?.color = originalColor
            })) {
                callback?()
            }
        }
    }

    /// Repeats a flash action a number of times for you
    ///
    /// - Parameters:
    ///   - color: The flash color action
    ///   - repetitions: the numer of repetitions (each rep is a half a second), so 2 reps = 1 second, 10 reps = 5 seconds
    ///   - callback: optional callback that executes once the actions have completed
    func flash(color: NSColor, repetitions: Int, callback: (() -> Void)? = nil) {
        let originalColor = node.color

        let flashColorAction = SKAction.customAction(withDuration: 0.25) { (node, value) in
            (node as? SKSpriteNode)?.color = color
        }
        let originalColorAction = SKAction.customAction(withDuration: 0.25) { (node, value) in
            (node as? SKSpriteNode)?.color = originalColor
        }

        node.run(SKAction.repeat(SKAction.sequence([flashColorAction, originalColorAction]), count: repetitions)) {
            callback?()
        }
    }
}

// MARK: - Helpers

fileprivate extension SpriteComponent {

    func move(to point: CGPoint, block: Block? = nil) {
        guard !node.hasActions() else {
            return
        }
        node.run(SKAction.sequence([
            SKAction.move(to: point, duration: 0.35),
            SKAction.run {
                block?()
            }
        ]), withKey: "move")
    }
    
}
