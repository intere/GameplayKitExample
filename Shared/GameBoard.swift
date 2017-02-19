//
//  GameBoard.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/18/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit

// MARK: Board Type

enum BoardType: Int {
    case unknown = -1
    case wall = 0
    case open = 1
    case playerStart = 2
    case enemy = 3

    /// Gets you a BoardType from an Integer value
    ///
    /// - Parameter value: The value you want converted to a board type
    /// - Returns: The BoardType if it could be inferred, or `.unknown` if not
    static func from(value: Int) -> BoardType {
        let types: [BoardType] = [.wall, .open, .playerStart, .enemy]
        for type in types {
            if type.rawValue == value {
                return type
            }
        }
        return .unknown
    }

    var isEmpty: Bool {
        switch self {
        case .open, .playerStart, .enemy:
            return true
        default:
            return false
        }
    }
}

struct BoardPoint {
    var x: Int = 0
    var y: Int = 0
}

// MARK: - Game Board

class GameBoard {

    /// 0 = wall, 1 = open
    var board: [[Int]]
    var container: SKSpriteNode!
    var scene: SKScene
    var player: SKSpriteNode!
    var playerLocation = BoardPoint()

    /// Default initializer
    init(inScene scene: SKScene) {
        board = [
            [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
            [ 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0 ],
            [ 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0 ],
            [ 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0 ],
            [ 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0 ],
            [ 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0 ],
            [ 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0 ],
            [ 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0 ],
            [ 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0 ],
            [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 0 ],
            [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
        ]
        self.scene = scene
        drawBoard(in: scene)
    }

}

// MARK: - API

extension GameBoard {

    func movePlayer(direction: Direction) {
        let newPosition = move(direction: direction, from: playerLocation)
        guard canMove(to: newPosition) else {
            print("Illegal move: \(direction)")
            return
        }
        move(node: player, to: newPosition, duration: 0.3)
        playerLocation = newPosition
    }

    /// Maps you from a given point to a new point using the direction and point you provide
    ///
    /// - Parameters:
    ///   - direction: The direction you want to move
    ///   - point: The current location that you want to move from
    /// - Returns: A point that represents where you want to move to
    func move(direction: Direction, from point: BoardPoint) -> BoardPoint {
        var x = point.x
        var y = point.y

        switch direction {
        case .up:
            y -= 1
        case .down:
            y += 1
        case .left:
            x -= 1
        case .right:
            x += 1
        default:
            break
        }
        return BoardPoint(x: x, y: y)
    }

    /// Tells you if a node can move to the given position
    ///
    /// - Parameter point: The board point you wish to move to
    /// - Returns: True if you can move there, false otherwise
    func canMove(to point: BoardPoint) -> Bool {
        guard point.x >= 0, point.y >= 0, point.x < board.count, point.y < board[0].count else {
            return false
        }

        return BoardType.from(value: board[point.y][point.x]).isEmpty
    }

    /// Moves the provided node to the provided location on the board and takes the specified duration to do it
    ///
    /// - Parameters:
    ///   - node: The node to be moved
    ///   - point: The board location to move it to
    ///   - duration: how long to take to animate the motion
    func move(node: SKNode, to point: BoardPoint, duration: TimeInterval) {
        let position = convert(boardPoint: point)
        node.run(SKAction.move(to: position, duration: duration))
    }
}

// MARK: - Helpers

fileprivate extension GameBoard {

    var boardSize: CGFloat {
        return min(scene.size.width, scene.size.height) - 10   // buffered by at least 5px on all sides
    }
    var count: CGFloat {
        return CGFloat(board.count)
    }
    var unitSize: CGFloat {
        return boardSize / count
    }

    func convert(boardPoint: BoardPoint) -> CGPoint {
        let x = position(index: boardPoint.x, row: false)
        let y = position(index: boardPoint.y)

        return CGPoint(x: x, y: y)
    }

    /// Assumes the number of rows and columns is the same (a square)
    func drawBoard(in scene: SKScene) {
        container = SKSpriteNode(color: .clear, size: CGSize(width: boardSize, height: boardSize))
        print("Scene Info: \(scene.frame)")
        guard let container = container else {
            assertionFailure("We just created the container but it doesn't exist, something fishy is going on")
            return
        }
        container.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        print("Container anchor: \(container.anchorPoint)")
        print("Container position: \(container.position)")

        for row in 0..<Int(count) {
            for column in 0..<Int(count) {
                guard let node = draw(a: board[row][column], at: BoardPoint(x: column, y: row)) else {
                    continue
                }
                container.addChild(node)
            }
        }

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

    func draw(a type: Int, at boardPoint: BoardPoint) -> SKSpriteNode? {
        let location = convert(boardPoint: boardPoint)

        switch BoardType.from(value: type) {
        case .playerStart:
            if let _ = self.player {
                assertionFailure("Only 1 player per board")
                return nil
            }
            let node = SKSpriteNode(color: .white, size: CGSize(width: unitSize, height: unitSize))
            node.position = location
            node.anchorPoint = CGPoint(x: 0, y: 0)
            playerLocation = boardPoint
            player = node
            return node

        case .wall:
            let node = SKSpriteNode(color: .blue, size: CGSize(width: unitSize, height: unitSize))
            node.position = location
            node.anchorPoint = CGPoint(x: 0, y: 0)
            return node

        case .enemy:
            let node = SKSpriteNode(color: .red, size: CGSize(width: unitSize, height: unitSize))
            node.position = location
            node.anchorPoint = CGPoint(x:0, y:0)
            return node

        default:
            return nil
        }
    }
}
