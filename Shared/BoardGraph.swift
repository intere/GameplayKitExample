//
//  BoardGraph.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/18/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit
import SpriteKit

// Notes: 
// As a discrete two-dimensional grid, where the only valid locations are those with integer coordinates. Use the GKGridGraph and GKGridGraphNode classes to create grid-based graphs. Figure 6-3 illustrates this format, which appears in many classic arcade games, board games, and tactical role-playing games.

class BoardGraph {
    let board: [[Int]]
    var graph: GKGridGraph<GKGridGraphNode>

    init(withBoard board: [[Int]]) {
        self.board = board
        self.graph = BoardGraph.createGrid(from: board)
    }

}

// MARK: - API

extension BoardGraph {

    

}

// MARK: - Helpers

fileprivate extension BoardGraph {

    static func createGrid(from board: [[Int]]) -> GKGridGraph<GKGridGraphNode> {
        let width = Int32(board[0].count)
        let height = Int32(board.count)

        let graph = GKGridGraph(fromGridStartingAt: vector_int2(0,0), width: width, height: height, diagonalsAllowed: false)
        var walls = [GKGridGraphNode]()

        for row in 0..<Int(height) {
            for column in 0..<Int(width) {
                let type = BoardType.from(value: board[row][column])
                if type == .wall {
                    guard let node = graph.node(atGridPosition: vector_int2(Int32(row), Int32(column))) else {
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
