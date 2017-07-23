//
//  IntelligenceComponent.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/20/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit

class IntelligenceComponent: GKComponent {

    var stateMachine: GKStateMachine!

    var game: Game!
    var enemy: BoardEntity!
    var origin: BoardPoint!

    init(with game: Game, enemy: BoardEntity, origin: BoardPoint) {
        self.game = game
        self.enemy = enemy
        self.origin = origin

        let chase = EnemyChaseState(with: game, entity: enemy)
        let flee = EnemyFleeState(with: game, entity: enemy)
        let defeated = EnemyDefeatedState(with: game, entity: enemy)
        defeated.respawnPosition = origin
        let respawn = EnemyRespawnState(with: game, entity: enemy)

        stateMachine = GKStateMachine(states: [chase, flee, defeated, respawn])
        stateMachine.enter(EnemyChaseState.self)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        stateMachine.update(deltaTime: seconds)
    }
}
