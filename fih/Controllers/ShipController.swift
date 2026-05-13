//
//  ShipController.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 12/05/26.
//

import SwiftUI

@Observable
class ShipController {

    // inisiasi semua data kapal yang tersedia
    var availableShips: [Ship] = Ship.allShips
    
    // melacak kapal apa yang dipilih
    var selectedShip: Ship? = nil
}
