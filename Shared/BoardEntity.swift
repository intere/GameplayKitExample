//
//  BoardEntity.swift
//  GameplayKitExample
//
//  Created by Eric Internicola on 2/19/17.
//  Copyright © 2017 iColasoft. All rights reserved.
//

import GameplayKit

class BoardEntity: GKEntity {
    var gridIndex: BoardPoint
    var entityType: EntityType

    init(gridIndex: BoardPoint, type: EntityType) {
        self.gridIndex = gridIndex
        self.entityType = type
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
