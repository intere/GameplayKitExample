//
//  GameScene.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/18/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit
#if os(watchOS)
    import WatchKit
    // <rdar://problem/26756207> SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif

class GameScene: SKScene {
    fileprivate var game: Game!

    override init(size: CGSize) {
        super.init(size: size)
        game = Game(level: Level(), scene: self)
        physicsWorld.contactDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(_ currentTime: TimeInterval) {
        game.update(currentTime: currentTime, forScene: self)
    }
}

// MARK: - SKPhysicsContactDelegate {

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == EntityType.enemy.mask {
            handleCollision(withEnemy: contact.bodyA.node)
        } else if contact.bodyB.categoryBitMask == EntityType.enemy.mask {
            handleCollision(withEnemy: contact.bodyB.node)
        }

        if contact.bodyA.categoryBitMask == EntityType.powerUp.mask {
            handleCollision(withPowerUp: contact.bodyA.node)
        } else if contact.bodyB.categoryBitMask == EntityType.powerUp.mask {
            handleCollision(withPowerUp: contact.bodyB.node)
        }
    }
    
}

// MARK: - Helpers

fileprivate extension GameScene {

    func handleCollision(withPowerUp powerUp: SKNode?) {
        guard let powerUp = powerUp else {
            return
        }
        powerUp.run(SKAction.fadeOut(withDuration: 0.5)) {
            powerUp.run(SKAction.removeFromParent())
        }

        // TODO: Make enemies transition to flee state
        for enemy in game.enemies {
            guard let ai = enemy.intelligence else {
                continue
            }
            ai.stateMachine.enter(EnemyFleeState.self)
        }
    }

    func handleCollision(withEnemy enemy: SKNode?) {
        guard let entity = enemy?.entity else {
            assertionFailure("Enemy has no entity")
            return
        }
        guard let aiComponent = entity.component(ofType: IntelligenceComponent.self) else {
            assertionFailure("Enemy has no AI")
            return
        }
        if aiComponent.stateMachine.currentState is EnemyChaseState {
            game.playerDied()
        } else {
            // The enemy enters the defeated state
            aiComponent.stateMachine.enter(EnemyDefeatedState.self)
        }
    }

}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
   
}
#endif

enum Direction {
    case up
    case down
    case left
    case right
    case unknown

    static func from(keyCode: UInt16) -> Direction {
        for direction in [up, down, left, right] {
            if Int(keyCode) == direction.keyCode {
                return direction
            }
        }
        return .unknown
    }

    var keyCode: Int {
        switch self {
        case .up:
            return 126
        case .down:
            return 125
        case .left:
            return 123
        case .right:
            return 124
        default:
            return -1
        }
    }
}

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func keyDown(with event: NSEvent) {
        let direction = Direction.from(keyCode: event.keyCode)
//        print("keyDown:  \(direction)")
        game.movePlayer(direction: direction)
    }

    override func keyUp(with event: NSEvent) {
//        let direction = Direction.from(keyCode: event.keyCode)
//        print("keyUp:  \(direction)")
    }

//    func moveBoard(toPoint point: CGPoint) {
//        board.container?.position = point
//    }

}
#endif

