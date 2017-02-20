//
//  CGPoint.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit
import GameplayKit

extension CGPoint {

    var vector: vector_int2 {
        return vector_int2(Int32(x), Int32(y))
    }

    var boardPoint: BoardPoint {
        return BoardPoint(x: Int(x), y: Int(y))
    }

}
