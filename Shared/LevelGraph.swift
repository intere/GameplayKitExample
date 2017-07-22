//
//  BoardGraph.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/18/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit
import SpriteKit


/// Manages the graph for a level
class LevelGraph {
    let level: Level
    let pathFindingGraph: GKGridGraph<GKGridGraphNode>
    var startPosition: BoardPoint!
    var enemyStartPositions: [BoardPoint]
    var powerUps: [BoardPoint]

    init(with level: Level) {
        self.level = level
        self.pathFindingGraph = LevelGraph.createPathFindingGraph(from: level)
        self.startPosition = LevelGraph.findStartPosition(from: level)
        self.enemyStartPositions = LevelGraph.findEnemyStartPositions(from: level)
        self.powerUps = LevelGraph.findPowerUps(from: level)
    }
}

// MARK: - API

extension LevelGraph {

    /// Gets you the new board point based on the current board point and the direction you want to go
    ///
    /// - Parameters:
    ///   - point: The point you want to move from
    ///   - direction: The direction you want to head in
    /// - Returns: The new point for the direction you want to head, or nil if it's an invalid direction
    func newPosition(from point: BoardPoint, inDirection direction: Direction) -> BoardPoint? {
        guard let position = node(from: point, inDirection: direction) else {
            return nil
        }
        return position.gridPosition.boardPoint
    }

    func path(from fromPoint: BoardPoint, to toPoint: BoardPoint) -> [GKGraphNode] {
        guard let from = node(at: fromPoint), let to = node(at: toPoint) else {
            return []
        }
        return pathFindingGraph.findPath(from: from, to: to)
    }

    func node(at point: BoardPoint) -> GKGridGraphNode? {
        return pathFindingGraph.node(atGridPosition: point.vector)
    }
}

// MARK: - Helpers

fileprivate extension LevelGraph {

    func node(from point: BoardPoint, inDirection direction: Direction) -> GKGridGraphNode? {
        guard let position = node(at: point)?.gridPosition else {
            return nil
        }
        var nextPosition: BoardPoint?

        switch direction {
        case .left:
            nextPosition = BoardPoint(x: position.x - 1, y: Int(position.y))
        case .right:
            nextPosition = BoardPoint(x: Int(position.x) + 1, y: Int(position.y))
        case .down:
            nextPosition = BoardPoint(x: Int(position.x), y: Int(position.y) + 1)
        case .up:
            nextPosition = BoardPoint(x: Int(position.x), y: Int(position.y) - 1)
        default:
            nextPosition = nil
        }

        guard let newPosition = nextPosition else {
            return nil
        }

        return pathFindingGraph.node(atGridPosition: newPosition.vector)
    }

    /// Finds the starting locations for the enemies
    ///
    /// - Parameter level: The level to scan for enemy start positions
    /// - Returns: an array of enemy start positions
    static func findEnemyStartPositions(from level: Level) -> [BoardPoint] {
        var startPoints = [BoardPoint]()

        for row in 0..<Int(level.height) {
            for column in 0..<Int(level.width) {
                if level.get(row: row, column: column) == .enemy {
                    startPoints.append(BoardPoint(x: column, y: row))
                }
            }
        }

        return startPoints
    }

    /// Finds the power up locations on the board
    ///
    /// - Parameter level: The level to scan for power ups
    /// - Returns: an array of power up positions
    static func findPowerUps(from level: Level) -> [BoardPoint] {
        var powerUps = [BoardPoint]()

        for row in 0..<Int(level.height) {
            for column in 0..<Int(level.width) {
                if level.get(row: row, column: column) == .powerUp {
                    powerUps.append(BoardPoint(x: column, y: row))
                }
            }
        }

        return powerUps
    }

    /// Finds the starting point for the player
    ///
    /// - Parameter level: The level to scan for the player start position
    /// - Returns: an array of enemy start positions
    static func findStartPosition(from level: Level) -> BoardPoint? {
        for row in 0..<Int(level.height) {
            for column in 0..<Int(level.width) {
                if level.get(row: row, column: column) == .playerStart {
                    return BoardPoint(x: column, y: row)
                }
            }
        }

        assertionFailure("There is no player starting position on this board")
        return nil
    }

    /// Creates the path finding graph
    ///
    /// - Parameter level: The level to create the graph from
    /// - Returns: A Path finding graph
    static func createPathFindingGraph(from level: Level) -> GKGridGraph<GKGridGraphNode> {
        let width = Int32(level.width)
        let height = Int32(level.height)

        let graph = GKGridGraph(fromGridStartingAt: vector_int2(0,0), width: width, height: height, diagonalsAllowed: false)
        var walls = [GKGridGraphNode]()

        for row in 0..<Int(height) {
            for column in 0..<Int(width) {
                if level.get(row: row, column: column) == .wall {
                    guard let node = graph.node(atGridPosition: vector_int2(Int32(column), Int32(row))) else {
                        continue
                    }
                    walls.append(node)
                }
            }
        }

        graph.remove(walls)

        return graph
    }
}
