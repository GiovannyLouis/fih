//
//  EquipementController.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

@Observable
class EquipmentController {
    
    // inisiasi semua equipment yang ada
    var availableEquipment: [Equipment] = Equipment.allEquipment
    
    var equippedItems: [Equipment] = []
  
    // Logic to equip or unequip an item when tapped
    func toggleEquipment(_ item: Equipment) {
        if let index = equippedItems.firstIndex(where: { $0.id == item.id }) {
            // If it's already equipped, unequip it
            equippedItems.remove(at: index)
        } else if equippedItems.count < 2 {
            // If we have an empty slot, equip it
            equippedItems.append(item)
        } else {
            // Optional: You could trigger a "Slots Full!" warning here
            print("No slots available!")
        }
    }
}
