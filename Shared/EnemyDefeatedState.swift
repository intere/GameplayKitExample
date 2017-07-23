//
//  EnemyDefeatedState.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/20/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit

/// The State that represents when the enemy has been defeated.
class EnemyDefeatedState: EnemyState {

    var respawnPosition: BoardPoint?

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return [EnemyRespawnState.self].contains(where: {$0 == stateClass})
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        guard let respawnPosition = respawnPosition else {
            assertionFailure("No respawn position for enemy")
            return
        }
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            assertionFailure("No sprite component for enemy")
            return
        }
        spriteComponent.node.removeAllActions()
        let respawnPath = path(to: respawnPosition)
        spriteComponent.follow(path: respawnPath) {
            self.stateMachine?.enter(EnemyRespawnState.self)
        }
    }
}
