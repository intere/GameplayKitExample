//
//  PlayerControlComponent.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/20/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit

class PlayerControlComponent: GKComponent {

    let player: BoardEntity
    let level: Level

    init(withPlayer player: BoardEntity, andLevel level: Level) {
        self.player = player
        self.level = level
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func move(inDirection direction: Direction) {
        guard let newPoint = level.graph.newPosition(from: player.gridIndex, inDirection: direction) else {
            print("Player cannot move in direction \(direction)")
            return
        }
        guard let skComponent = player.component(ofType: SpriteComponent.self) else {
            print("Player has no SpriteComponent")
            return
        }
        skComponent.move(to: newPoint)
    }
}
