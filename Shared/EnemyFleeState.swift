//
//  EnemyFleeState.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/20/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit

class EnemyFleeState: EnemyState {

    var target: BoardPoint?

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == EnemyChaseState.self ||
            stateClass == EnemyDefeatedState.self
    }

    override func didEnter(from previousState: GKState?) {
        guard let game = game else {
            return
        }
        guard let target = game.random.arrayByShufflingObjects(in: game.level.enemyStartPositions).first as? BoardPoint else {
            return
        }
        self.target = target
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let target = target else {
            return
        }
        let pathway = path(to: target)
        start(following: pathway)
    }
}
