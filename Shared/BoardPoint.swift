//
//  BoardPoint.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit
import SpriteKit

struct BoardPoint {
    var x: Int = 0
    var y: Int = 0

    /// Converts this BoardPoint to a point
    var point: CGPoint {
        return CGPoint(x: x, y: y)
    }

    /// Converts this BoardPoint to a vector_int2 point
    var vector: vector_int2 {
        return vector_int2(Int32(x), Int32(y))
    }
}

func==(first: BoardPoint?, second: BoardPoint?) -> Bool {
    return first?.x == second?.x && first?.y == second?.y
}
