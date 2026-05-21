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
    // 💡 KUNCI: Ubah 'let' menjadi 'var' dan tambahkan kurung kurawal '{ return [...] }'
    static var allFish: [Fish] {
        return [
            // ==================== ZONA 1 (Starter Zone) ====================
            Fish(zone: 1, name: "Tuna", info: "Ikan perenang cepat di lautan dangkal.", iconName: "icon_tuna", isUnlocked: false),
            Fish(zone: 1, name: "Salmon", info: "Suka berenang melawan arus sungai.", iconName: "icon_salmon", isUnlocked: false),
            Fish(zone: 1, name: "Sardine", info: "Sering ditemukan berkelompok dalam jumlah besar.", iconName: "icon_sardine", isUnlocked: false),
            Fish(zone: 1, name: "Mackerel", info: "Ikan kecil yang kaya akan omega-3.", iconName: "icon_mackerel", isUnlocked: false),
            Fish(zone: 1, name: "Anchovy", info: "Ukurannya kecil tapi rasanya sangat kuat.", iconName: "icon_anchovy", isUnlocked: false),
            Fish(zone: 1, name: "Snapper", info: "Ikan karang dengan warna sisik kemerahan.", iconName: "icon_snapper", isUnlocked: false),
            
            // ==================== ZONA 2 (Reef Zone) ====================
            Fish(zone: 2, name: "Clownfish", info: "Bersembunyi di balik anemon beracun.", iconName: "icon_clownfish", isUnlocked: false),
            Fish(zone: 2, name: "Blue Tang", info: "Ikan hias dengan warna biru yang mencolok.", iconName: "icon_bluetang", isUnlocked: false),
            Fish(zone: 2, name: "Pufferfish", info: "Bisa menggembungkan tubuhnya saat terancam.", iconName: "icon_pufferfish", isUnlocked: false),
            Fish(zone: 2, name: "Grouper", info: "Kerapu besar yang bersembunyi di celah karang.", iconName: "icon_grouper", isUnlocked: false),
            Fish(zone: 2, name: "Mahi Mahi", info: "Perenang lincah dengan warna hijau-kuning.", iconName: "icon_mahimahi", isUnlocked: false),
            Fish(zone: 2, name: "Barracuda", info: "Predator ganas dengan gigi setajam pisau.", iconName: "icon_barracuda", isUnlocked: false),
            
            // ==================== ZONA 3 (Deep Sea Zone) ====================
            Fish(zone: 3, name: "Anglerfish", info: "Memiliki lampu alami di atas kepalanya.", iconName: "icon_anglerfish", isUnlocked: false),
            Fish(zone: 3, name: "Coelacanth", info: "Fosil hidup purba yang langka ditemukan.", iconName: "icon_coelacanth", isUnlocked: false),
            Fish(zone: 3, name: "Oarfish", info: "Ikan pita raksasa yang sangat panjang.", iconName: "icon_oarfish", isUnlocked: false),
            Fish(zone: 3, name: "Blobfish", info: "Ikan berwajah murung dari laut dalam.", iconName: "icon_blobfish", isUnlocked: false),
            Fish(zone: 3, name: "Lanternfish", info: "Bisa bercahaya dalam kegelapan abadi.", iconName: "icon_lanternfish", isUnlocked: false),
            Fish(zone: 3, name: "Goblin Shark", info: "Hiu aneh dengan rahang yang bisa memanjang.", iconName: "icon_goblinshark", isUnlocked: false),
            
            // ==================== ZONA 4 (Legendary Zone) ====================
            Fish(zone: 4, name: "Golden Koi", info: "Mitos mengatakan ikan ini membawa keberuntungan.", iconName: "icon_goldenkoi", isUnlocked: false),
            Fish(zone: 4, name: "Megalodon", info: "Hiu purba raksasa pelindung lautan.", iconName: "icon_megalodon", isUnlocked: false),
            Fish(zone: 4, name: "Leviathan", info: "Monster laut dalam yang sangat legendaris.", iconName: "icon_leviathan", isUnlocked: false),
            Fish(zone: 4, name: "Abyssal Ray", info: "Pari raksasa bercahaya dari jurang terdalam.", iconName: "icon_abyssalray", isUnlocked: false),
            Fish(zone: 4, name: "Ghost Fish", info: "Tubuhnya transparan dan nyaris tak terlihat.", iconName: "icon_ghostfish", isUnlocked: false),
            Fish(zone: 4, name: "Cosmic Whale", info: "Spesies misterius berukuran sebesar pulau.", iconName: "icon_cosmicwhale", isUnlocked: false)
        ]
    }
}
