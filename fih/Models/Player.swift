//
//  Player.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 20/05/26.
//

import SwiftData
import Foundation


@Model
class Player {
    @Attribute(.unique) var id: UUID
    var totalDays: Int = 1
    var collectedFish: [Fish]
    var isNewFishUnlocked: Bool = false
    
    init(id: UUID = UUID(), intialDays: Int, collectedFish: [Fish], isNewFishUnlocked: Bool = false) {
        self.id = id
        self.totalDays = intialDays
        self.collectedFish = collectedFish
    }
}
