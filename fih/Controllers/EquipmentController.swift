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
    
    // terima object kapal yang dipilih dari page SelectShipPage
    let ship: Ship
    
    var equippedItems: [Equipment] = []
    
    init(ship: Ship) {
        self.ship = ship
    }
    
    // Logic to equip or unequip an item when tapped
    func toggleEquipment(_ item: Equipment) {
        if let index = equippedItems.firstIndex(where: { $0.id == item.id }) {
            // If it's already equipped, unequip it
            equippedItems.remove(at: index)
        } else if equippedItems.count < ship.equipmentSlots {
            // If we have an empty slot, equip it
            equippedItems.append(item)
        } else {
            // Optional: You could trigger a "Slots Full!" warning here
            print("No slots available!")
        }
    }
}
