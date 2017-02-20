//
//  EnemyState.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit
import SpriteKit

class EnemyState: GKState {
    weak var game: Game?
    let entity: BoardEntity

    init(with game: Game, entity: BoardEntity) {
        self.game = game
        self.entity = entity
        super.init()
    }

}

// MARK: - API

extension EnemyState {

    func path(to point: BoardPoint) -> [GKGridGraphNode] {
        guard let game = game else {
            assertionFailure("We don't have a game to use")
            return []
        }
        guard let path = game.level.graph.path(from: entity.gridIndex, to: point) as? [GKGridGraphNode] else {
            return []
        }
        return path
    }

    func start(following path: [GKGridGraphNode]) {
        guard path.count > 1 else {
            return
        }
        guard let skComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }
        let firstMove = path[1].gridPosition.boardPoint
        skComponent.update(nextGridPosition: firstMove)
    }
}
