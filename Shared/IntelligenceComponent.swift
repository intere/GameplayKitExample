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

        // TODO(egi): Implement States
        stateMachine = GKStateMachine(states: [])
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
