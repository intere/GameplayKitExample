//
//  vector_int2.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit
import GameplayKit

extension vector_int2 {

    var point: CGPoint {
        return CGPoint(x: Int(x), y: Int(y))
    }

    var boardPoint: BoardPoint {
        return BoardPoint(x: Int(x), y: Int(y))
    }

}
