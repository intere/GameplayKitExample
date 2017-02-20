//
//  GameBoard.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/18/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit


class Level {

    fileprivate var board: [[Int]]
    var player: SKSpriteNode!
    var playerLocation = BoardPoint()
    var graph: LevelGraph!

    /// Default initializer
    init() {
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
        graph = LevelGraph(with: self)
    }
}

// MARK: - API

extension Level {

    func get(row: Int, column: Int) -> BoardType {
        guard row > -1 && row < height else {
            return .unknown
        }
        guard column > -1 && column < width else {
            return .unknown
        }
        return BoardType.from(value: board[row][column])
    }

    var startPosition: BoardPoint! {
        return graph.startPosition
    }

    var enemyStartPositions: [BoardPoint] {
        return graph.enemyStartPositions
    }

    var width: Int {
        return board[0].count
    }

    var height: Int {
        return board.count
    }

//    /// Moves the player
//    ///
//    /// - Parameter direction: The direction you want to move the player
//    func movePlayer(direction: Direction) {
//        let newPosition = move(direction: direction, from: playerLocation)
//        guard canMove(to: newPosition) else {
//            print("Illegal move: \(direction)")
//            return
//        }
////        move(node: player, to: newPosition, duration: 0.3)
//        playerLocation = newPosition
//    }

//    /// Maps you from a given point to a new point using the direction and point you provide
//    ///
//    /// - Parameters:
//    ///   - direction: The direction you want to move
//    ///   - point: The current location that you want to move from
//    /// - Returns: A point that represents where you want to move to
//    func move(direction: Direction, from point: BoardPoint) -> BoardPoint {
//        var x = point.x
//        var y = point.y
//
//        switch direction {
//        case .up:
//            y -= 1
//        case .down:
//            y += 1
//        case .left:
//            x -= 1
//        case .right:
//            x += 1
//        default:
//            break
//        }
//        return BoardPoint(x: x, y: y)
//    }

//    /// Tells you if a node can move to the given position
//    ///
//    /// - Parameter point: The board point you wish to move to
//    /// - Returns: True if you can move there, false otherwise
//    func canMove(to point: BoardPoint) -> Bool {
//        guard point.x >= 0, point.y >= 0, point.x < board.count, point.y < board[0].count else {
//            return false
//        }
//
//        return BoardType.from(value: board[point.y][point.x]).isEmpty
//    }

//    /// Moves the provided node to the provided location on the board and takes the specified duration to do it
//    ///
//    /// - Parameters:
//    ///   - node: The node to be moved
//    ///   - point: The board location to move it to
//    ///   - duration: how long to take to animate the motion
//    func move(node: SKNode, to point: BoardPoint, duration: TimeInterval) {
//        let position = convert(boardPoint: point)
//        node.run(SKAction.move(to: position, duration: duration))
//    }
}
