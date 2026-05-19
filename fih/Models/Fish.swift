//
//  Fish.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 18/05/26.
//

import SwiftData
import Foundation


@Model
class Fish {
    @Attribute(.unique) var id: UUID
    var zone: Int
    var name: String
    var info: String // Hindari menggunakan nama variabel 'description' karena sering bentrok dengan bawaan Swift
    var iconName: String
    var totalCollected: Int = 0
    var isUnlocked: Bool
    
    init(id: UUID = UUID(), zone: Int, name: String, info: String, iconName: String, isUnlocked: Bool = false) {
        self.id = id
        self.zone = zone
        self.name = name
        self.info = info
        self.iconName = iconName
        self.isUnlocked = isUnlocked
    }
}
