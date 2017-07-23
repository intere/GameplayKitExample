//
//  BoardType.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit

/// The Individual cells in the board
enum BoardType: Int {
    case unknown = -1
    case wall = 0
    case open = 1
    case playerStart = 2
    case enemy = 3
    case powerUp = 4

    /// Gets you a BoardType from an Integer value
    ///
    /// - Parameter value: The value you want converted to a board type
    /// - Returns: The BoardType if it could be inferred, or `.unknown` if not
    static func from(value: Int) -> BoardType {
        let types: [BoardType] = [.wall, .open, .playerStart, .enemy, .powerUp]
        for type in types {
            if type.rawValue == value {
                return type
            }
        }
        return .unknown
    }

}
