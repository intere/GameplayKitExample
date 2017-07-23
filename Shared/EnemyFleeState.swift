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
    var originalColor: NSColor?

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return [EnemyChaseState.self, EnemyDefeatedState.self].contains(where: {$0 == stateClass})
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        guard let game = game else {
            return
        }
        guard let target = game.random.arrayByShufflingObjects(in: game.level.enemyStartPositions).first as? BoardPoint else {
            return
        }
        self.target = target

        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            assertionFailure("No sprite component for enemy")
            return
        }

        // Phase 1: Change the color to purple for 7 seconds
        spriteComponent.temporaryChange(color: .purple, time: 7) {
            
            // Phase 2: Flash the color for 3 seconds:
            spriteComponent.flash(color: .purple, repetitions: 6) {

                // Phase 3: Switch back to Chase State.
                self.entity.intelligence?.stateMachine.enter(EnemyChaseState.self)
            }
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let target = target else {
            return
        }
        let pathway = path(to: target)
        start(following: pathway)
    }
}
