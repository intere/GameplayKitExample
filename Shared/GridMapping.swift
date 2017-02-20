//
//  GridMapping.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import SpriteKit
import GameplayKit


/// Protocol that handles Grid Mapping features
protocol GridMapping {

    /// Given the provided Grid Position (BoardPoint) this function will give you the SpriteKit position to move to
    ///
    /// - Parameter forGridPosition: The position in the Grid to convert to a SpriteKit location
    /// - Returns: The Point that the grid position correlates to
    func point(forGridPosition: BoardPoint) -> CGPoint

    

}
