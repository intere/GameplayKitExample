//
//  EnemyDefeatedState.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/20/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit

class EnemyDefeatedState: EnemyState {

    var respawnPosition: BoardPoint?

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == EnemyRespawnState.self
    }

    override func didEnter(from previousState: GKState?) {
        guard let respawnPosition = respawnPosition else {
            assertionFailure("No respawn position for enemy")
            return
        }
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            assertionFailure("No sprite component for enemy")
            return
        }
        let respawnPath = path(to: respawnPosition)
        spriteComponent.follow(path: respawnPath) {
            self.stateMachine?.enter(EnemyRespawnState.self)
        }
    }
}
