//
//  PlayingController.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 13/05/26.
//

import SwiftUI

@Observable
class InGameController {

    // terima kapal apa yang dipilih
    let selectedShip: Ship
    
    // terima equipment yang dipilih
    let equippedItems: [Equipment]
    
    init (ship: Ship, equippedItems: [Equipment]) {
        self.selectedShip = ship
        self.equippedItems = equippedItems
    }

}
