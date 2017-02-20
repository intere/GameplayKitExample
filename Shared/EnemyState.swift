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

    func path(to node: BoardPoint) -> [GKGridGraphNode] {
        // TODO(egi): Implement Me
        return []
    }

    func start(following path: [GKGridGraphNode]) {
        // TODO(egi): Implement Me
    }
}
