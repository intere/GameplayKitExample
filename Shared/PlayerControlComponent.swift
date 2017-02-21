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
    fileprivate var direction = Direction.unknown
    var attemptedDirection = Direction.unknown
    fileprivate var nextNode: GKGridGraphNode?

    init(withPlayer player: BoardEntity, andLevel level: Level) {
        self.player = player
        self.level = level
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeNextMove() {
        let nNext = nextNode(inDirection: direction)
        let attempted = nextNode(inDirection: attemptedDirection)

        if let attempted = attempted {
            direction = attemptedDirection
            self.nextNode = attempted
            player.component(ofType: SpriteComponent.self)?.update(nextGridPosition: attempted.gridPosition.boardPoint)
        } else if let nNext = nNext {
            self.nextNode = nNext
            player.component(ofType: SpriteComponent.self)?.update(nextGridPosition: nNext.gridPosition.boardPoint)
        } else {
            direction = .unknown
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        makeNextMove()
    }

}

// MARK: - API

extension PlayerControlComponent {

    func reset() {
        direction = .unknown
        attemptedDirection = .unknown
    }

}

// MARK: - Helpers

fileprivate extension PlayerControlComponent {

    func move(to gridPoint: BoardPoint) {
        guard let newPoint = nextPoint(inDirection: direction) else {
            print("Player cannot move in direction \(direction)")
            return
        }
        guard let skComponent = player.component(ofType: SpriteComponent.self) else {
            print("Player has no SpriteComponent")
            return
        }
        skComponent.move(to: newPoint)
    }

    func nextNode(inDirection direction: Direction) -> GKGridGraphNode? {
        guard let newPoint = nextPoint(inDirection: direction) else {
            return nil
        }
        return level.graph.node(at: newPoint)
    }

    func nextPoint(inDirection direction: Direction) -> BoardPoint? {
        return level.graph.newPosition(from: player.gridIndex, inDirection: direction)
    }

}
