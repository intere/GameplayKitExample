//
//  Game.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit
import GameplayKit

class Game {
    let scene: SKScene
    let level: Level
    var player: BoardEntity!
    var enemies = [BoardEntity]()
    var intelligenceSystem: GKComponentSystem<GKComponent>!
    var container: SKSpriteNode!
    var prevUpdateTime: TimeInterval = -1
    var random = GKRandomSource()

    init(level: Level, scene: SKScene) {
        self.level = level
        self.scene = scene
        drawBoard()
        createEntities()
        renderEntites()
    }
}

// MARK: - API

extension Game {

    func update(currentTime: TimeInterval, forScene scene: SKScene) {
        if prevUpdateTime < 0 {
            prevUpdateTime = currentTime
        }
        let dt = currentTime - prevUpdateTime
        prevUpdateTime = currentTime

        intelligenceSystem.update(deltaTime: dt)
        player.update(deltaTime: dt)
    }

}

// MARK: - GridMapping

extension Game: GridMapping {

    func convert(gridPoint: BoardPoint) -> CGPoint {
        return convert(boardPoint: gridPoint)
    }

    func movePlayer(direction: Direction) {
        guard let controlComponent = player.component(ofType: PlayerControlComponent.self) else {
            return
        }
        controlComponent.attemptedDirection = direction
    }
    
}

// MARK: - Helpers

fileprivate extension Game {

    var unitSize: CGFloat {
        return boardSize / count
    }

    var boardSize: CGFloat {
        return min(scene.size.width, scene.size.height) - 10   // buffered by at least 5px on all sides
    }

    var count: CGFloat {
        return CGFloat(level.height)
    }

    func convert(boardPoint: BoardPoint) -> CGPoint {
        let x = position(index: boardPoint.x, row: false)
        let y = position(index: boardPoint.y)

        return CGPoint(x: x, y: y)
    }

    /// Figures out where to position the object in the specified container at the specified index
    ///
    /// - Parameters:
    ///   - container: The container to be positioned within
    ///   - unitSize: The size of each unit
    ///   - index: The index of the unit to be placed
    ///   - count: The total number of units in the row
    /// - Returns: The value for placement
    func position(index: Int, row: Bool = true) -> CGFloat {
        let halfCount = count / 2
        let offset = abs(halfCount - CGFloat(index))

        if row {
            if CGFloat(index) < halfCount {
                return offset * unitSize - unitSize
            } else {
                return 0 - offset * unitSize - unitSize
            }
        } else {
            if CGFloat(index) < halfCount {
                return 0 - offset * unitSize
            } else {
                return offset * unitSize
            }
        }
    }

    /// Assumes the number of rows and columns is the same (a square)
    func drawBoard() {
        container = SKSpriteNode(color: .clear, size: CGSize(width: boardSize, height: boardSize))
        guard let container = container else {
            assertionFailure("We just created the container but it doesn't exist, something fishy is going on")
            return
        }
        container.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)

        for row in 0..<Int32(level.height) {
            for column in 0..<Int32(level.width) {
                guard let _ = level.graph.pathFindingGraph.node(atGridPosition: vector_int2(row, column)),
                    let node = drawPath(at: BoardPoint(x: Int(row), y: Int(column))) else
                {
                        continue
                }
                container.addChild(node)
            }
        }
        scene.addChild(container)
    }

    /// Draws the given object type on the board
    ///
    /// - Parameters:
    ///   - type: The type of object to draw
    ///   - boardPoint: The point to draw the board at.
    /// - Returns: The SKSpriteNode that was rendered
    func drawPath(at boardPoint: BoardPoint) -> SKSpriteNode? {
        let location = convert(boardPoint: boardPoint)

        let node = SKSpriteNode(color: .blue, size: CGSize(width: unitSize, height: unitSize))
        node.position = location
        node.anchorPoint = CGPoint(x: 0, y: 0)
        return node
    }

    /// Responsible for the creation of the game entities
    func createEntities() {
        player = BoardEntity(gridIndex: level.startPosition)
        player.addComponent(SpriteComponent(with: player, color: .white, unitSize: unitSize, level: level, gridMapper: self))
        player.addComponent(PlayerControlComponent(withPlayer: player, andLevel: level))
        player.component(ofType: SpriteComponent.self)?.node.zPosition = 15

        let enemyColors: [SKColor] = [.red, .green, .yellow, .magenta]
        intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)

        for i in 0..<level.enemyStartPositions.count {
            let position = level.enemyStartPositions[i]
            let enemy = BoardEntity(gridIndex: position)
            enemy.addComponent(SpriteComponent(with: enemy, color: enemyColors[i], unitSize: unitSize, level: level, gridMapper: self))
            enemy.addComponent(IntelligenceComponent(with: self, enemy: enemy, origin: position))
            intelligenceSystem.addComponent(foundIn: enemy)
            enemies.append(enemy)
        }
    }

    /// This is responsible for adding the sprite component of the entities to the game board
    func renderEntites() {
        var entities = [BoardEntity]()
        entities.append(player)
        entities.append(contentsOf: enemies)

        for entity in entities {
            guard let skComponent = entity.component(ofType: SpriteComponent.self) else {
                continue
            }
            container.addChild(skComponent.node)
        }
    }

}
