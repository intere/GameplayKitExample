//
//  EnemyChaseState.swift
//  GameplayKitExample
//
//  Created by Internicola, Eric on 2/20/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit


class EnemyChaseState: EnemyState {

    fileprivate let ruleSystem = GKRuleSystem()
    fileprivate var scatterTarget: GKGridGraphNode?

    /// Is the enemy in the hunting state?
    var hunting = false {
        didSet {
            huntingToggled()
        }
    }

    override init(with game: Game, entity: BoardEntity) {
        super.init(with: game, entity: entity)

        let playerFar = NSPredicate(format: "$distanceToPlayer.floatValue >= 10.0")
        ruleSystem.add(GKRule(predicate: playerFar, assertingFact:"hunt" as NSString, grade: 1))

        let playerNear = NSPredicate(format: "$distanceToPlayer.floatValue < 10.0")
        ruleSystem.add(GKRule(predicate: playerNear, retractingFact:"hunt" as NSString, grade: 1))
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        // The only valid next state is "flee"
        return [EnemyFleeState.self].contains(where: { $0 == stateClass })
    }

    override func didEnter(from previousState: GKState?) {
        // TODO(EGI): what the next comment says
        // Set the enemy sprite to its normal appearance, undoing any changes that happened in other states.
        super.didEnter(from: previousState)
    }

    override func update(deltaTime seconds: TimeInterval) {
        let position = entity.gridIndex
        if position == scatterTarget?.gridPosition.boardPoint {
            hunting = true
        }
        let distanceToPlayer = pathToPlayer.count
        ruleSystem.state["distanceToPlayer"] = NSNumber(value: distanceToPlayer)
        ruleSystem.reset()
        ruleSystem.evaluate()

        hunting = ruleSystem.grade(forFact: "hunt" as NSString) > 0
        if hunting {
            start(following: pathToPlayer)
        } else {
            guard let scatterTargetGridPoint = scatterTarget?.gridPosition.boardPoint else {
                return
            }
            start(following: path(to: scatterTargetGridPoint))
        }
    }

}

// MARK: - Implementation

extension EnemyChaseState {

    /// Gets you the path to the player (from the position of the enemy)
    var pathToPlayer: [GKGridGraphNode] {
        guard let game = game else {
            return []
        }
        return path(to: game.player.gridIndex)
    }

    func huntingToggled() {
        guard !hunting else {
            return
        }
        guard let game = game else {
            print("No Game object")
            return
        }
        guard let scatterTarget = game.random.arrayByShufflingObjects(in: game.level.enemyStartPositions).first as? BoardPoint else {
            assertionFailure("Failed to get a Scatter Target")
            return
        }
        self.scatterTarget = game.level.graph.node(at: scatterTarget)
    }

}
