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
    var info: String
    var iconName: String
    var isUnlocked: Bool
    
    // 2. Class wajib memiliki fungsi init()
    init(id: UUID = UUID(), zone: Int, name: String, info: String, iconName: String, isUnlocked: Bool) {
        self.id = id
        self.zone = zone
        self.name = name
        self.info = info
        self.iconName = iconName
        self.isUnlocked = isUnlocked
    }
}

extension Fish {
    static let allFish: [Fish] = [
        
        // ==================== ZONA 1 (Starter Zone) ====================
        Fish(zone: 1, name: "Tuna", info: "Ikan perenang cepat di lautan dangkal.", iconName: "fish_blue", isUnlocked: true),
        Fish(zone: 1, name: "Salmon", info: "Suka berenang melawan arus sungai.", iconName: "fish_red", isUnlocked: false),
        Fish(zone: 1, name: "Sardine", info: "Sering ditemukan berkelompok dalam jumlah besar.", iconName: "fish_blue", isUnlocked: false),
        Fish(zone: 1, name: "Mackerel", info: "Ikan kecil yang kaya akan omega-3.", iconName: "fish_red", isUnlocked: false),
        Fish(zone: 1, name: "Anchovy", info: "Ukurannya kecil tapi rasanya sangat kuat.", iconName: "fish_blue", isUnlocked: false),
        Fish(zone: 1, name: "Snapper", info: "Ikan karang dengan warna sisik kemerahan.", iconName: "fish_red", isUnlocked: true),
        
        // ==================== ZONA 2 (Reef Zone) ====================
        Fish(zone: 2, name: "Clownfish", info: "Bersembunyi di balik anemon beracun.", iconName: "fish_red", isUnlocked: true),
        Fish(zone: 2, name: "Blue Tang", info: "Ikan hias dengan warna biru yang mencolok.", iconName: "fish_blue", isUnlocked: false),
        Fish(zone: 2, name: "Pufferfish", info: "Bisa menggembungkan tubuhnya saat terancam.", iconName: "fish_red", isUnlocked: false),
        Fish(zone: 2, name: "Grouper", info: "Kerapu besar yang bersembunyi di celah karang.", iconName: "fish_blue", isUnlocked: true),
        Fish(zone: 2, name: "Mahi Mahi", info: "Perenang lincah dengan warna hijau-kuning.", iconName: "fish_red", isUnlocked: false),
        Fish(zone: 2, name: "Barracuda", info: "Predator ganas dengan gigi setajam pisau.", iconName: "fish_blue", isUnlocked: true),
        
        // ==================== ZONA 3 (Deep Sea Zone) ====================
        Fish(zone: 3, name: "Anglerfish", info: "Memiliki lampu alami di atas kepalanya.", iconName: "fish_red", isUnlocked: true),
        Fish(zone: 3, name: "Coelacanth", info: "Fosil hidup purba yang langka ditemukan.", iconName: "fish_blue", isUnlocked: false),
        Fish(zone: 3, name: "Oarfish", info: "Ikan pita raksasa yang sangat panjang.", iconName: "fish_red", isUnlocked: false),
        Fish(zone: 3, name: "Blobfish", info: "Ikan berwajah murung dari laut dalam.", iconName: "fish_blue", isUnlocked: true),
        Fish(zone: 3, name: "Lanternfish", info: "Bisa bercahaya dalam kegelapan abadi.", iconName: "fish_red", isUnlocked: false),
        Fish(zone: 3, name: "Goblin Shark", info: "Hiu aneh dengan rahang yang bisa memanjang.", iconName: "fish_blue", isUnlocked: false),
        
        // ==================== ZONA 4 (Legendary Zone) ====================
        Fish(zone: 4, name: "Golden Koi", info: "Mitos mengatakan ikan ini membawa keberuntungan.", iconName: "fish_red", isUnlocked: false),
        Fish(zone: 4, name: "Megalodon", info: "Hiu purba raksasa pelindung lautan.", iconName: "fish_blue", isUnlocked: false),
        Fish(zone: 4, name: "Leviathan", info: "Monster laut dalam yang sangat legendaris.", iconName: "fish_red", isUnlocked: true),
        Fish(zone: 4, name: "Abyssal Ray", info: "Pari raksasa bercahaya dari jurang terdalam.", iconName: "fish_blue", isUnlocked: false),
        Fish(zone: 4, name: "Ghost Fish", info: "Tubuhnya transparan dan nyaris tak terlihat.", iconName: "fish_red", isUnlocked: false),
        Fish(zone: 4, name: "Cosmic Whale", info: "Spesies misterius berukuran sebesar pulau.", iconName: "fish_blue", isUnlocked: true)
    ]
    
    
    
}
