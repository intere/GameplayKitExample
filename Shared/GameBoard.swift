//
//  GameBoard.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/18/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit

enum BoardType: Int {
    case wall = 0
    case open = 1
    case unknown = -1

    static func from(value: Int) -> BoardType {
        let types: [BoardType] = [.wall, .open]
        for type in types {
            if type.rawValue == value {
                return type
            }
        }
        return .unknown
    }
}

class GameBoard {

    /// 0 = wall, 1 = open
    var board: [[Int]]
    var container: SKSpriteNode?
    var scene: SKScene

    /// Default initializer
    init(inScene scene: SKScene) {
        board = [
            [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
            [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0 ],
            [ 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0 ],
            [ 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0 ],
            [ 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0 ],
            [ 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0 ],
            [ 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0 ],
            [ 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0 ],
            [ 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0 ],
            [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 ],
            [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],

        ]
        self.scene = scene
        drawBoard(in: scene)
    }

}

// MARK: - API

extension GameBoard {

}

// MARK: - Helpers

fileprivate extension GameBoard {

    /// Assumes the number of rows and columns is the same (a square)
    func drawBoard(in scene: SKScene) {
        let boardSize = min(scene.size.width, scene.size.height) - 100   // buffered by at least 25px on all sides
        let count = CGFloat(board.count)
        let unitSize = boardSize/count

        let container = SKSpriteNode(color: .clear, size: CGSize(width: boardSize, height: boardSize))
        print("Scene Info: \(scene.frame)")
        container.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        print("Container anchor: \(container.anchorPoint)")
        print("Container position: \(container.position)")

        for row in 0..<Int(count) {
            let y = position(container: container, unitSize: unitSize, index: row, count: count)
            for column in 0..<Int(count) {
                let x = position(container: container, unitSize: unitSize, index: column, count: count, row: false)
                guard let node = draw(a: board[row][column], atX: x, andY: y, unitSize: unitSize) else {
                    continue
                }
                container.addChild(node)
            }
        }

        self.container = container
        container.physicsBody = SKPhysicsBody(rectangleOf: container.size)
        container.physicsBody?.affectedByGravity = false
        scene.addChild(container)
    }


    /// Figures out where to position the object in the specified container at the specified index
    ///
    /// - Parameters:
    ///   - container: The container to be positioned within
    ///   - unitSize: The size of each unit
    ///   - index: The index of the unit to be placed
    ///   - count: The total number of units in the row
    /// - Returns: The value for placement
    func position(container: SKNode, unitSize: CGFloat, index: Int, count: CGFloat, row: Bool = true) -> CGFloat {
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

    func draw(a type: Int, atX x: CGFloat, andY y: CGFloat, unitSize: CGFloat) -> SKSpriteNode? {
        switch BoardType.from(value: type) {
        case .wall:
            let node = SKSpriteNode(color: .green, size: CGSize(width: unitSize, height: unitSize))
            node.position = CGPoint(x: x, y: y)
            node.anchorPoint = CGPoint(x: 0, y: 0)
            return node
        default:
            return nil
        }
    }
}
