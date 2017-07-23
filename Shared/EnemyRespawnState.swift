//
//  EnemyRespawnState.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/20/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit

class EnemyRespawnState: EnemyState {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return [EnemyChaseState.self, EnemyFleeState.self].contains(where: {$0 == stateClass})
    }


    override func didEnter(from previousState: GKState?) {
        entity.intelligence?.stateMachine.enter(EnemyChaseState.self)
    }
    
}
