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
                // ==================== ZONE 1 (Starter Zone) ====================
                Fish(zone: 1, name: "Flatfish", info: "Popular saltwater fish known for its speed and commercial value.", iconName: "icon_tuna", isUnlocked: false),
                Fish(zone: 1, name: "Sawfish", info: "Famous for migrating from the ocean to freshwater rivers.", iconName: "icon_salmon", isUnlocked: false),
                Fish(zone: 1, name: "Satfish", info: "Often found swimming together in massive schools.", iconName: "icon_sardine", isUnlocked: false),
                Fish(zone: 1, name: "Mackerel", info: "Rich in omega-3 and typically dwells in shallow waters.", iconName: "icon_mackerel", isUnlocked: false),
                Fish(zone: 1, name: "Anchovy", info: "Tiny marine species characterized by a very strong flavor.", iconName: "icon_anchovy", isUnlocked: false),
                Fish(zone: 1, name: "Snapper", info: "Frequently spotted near coral reefs with distinct reddish scales.", iconName: "icon_snapper", isUnlocked: false),
                
                // ==================== ZONE 2 (Reef Zone) ====================
                Fish(zone: 2, name: "Clownfish", info: "Hides safely among venomous sea anemones.", iconName: "icon_clownfish", isUnlocked: false),
                Fish(zone: 2, name: "Blue Tang", info: "Recognized by its striking blue coloration and yellow tail.", iconName: "icon_bluetang", isUnlocked: false),
                Fish(zone: 2, name: "Pufferfish", info: "Capable of inflating its body when threatened by predators.", iconName: "icon_pufferfish", isUnlocked: false),
                Fish(zone: 2, name: "Grouper", info: "Heavy-bodied predator lurking within coral crevices.", iconName: "icon_grouper", isUnlocked: false),
                Fish(zone: 2, name: "Mahi Mahi", info: "Swift tropical swimmer displaying vibrant green and yellow hues.", iconName: "icon_mahimahi", isUnlocked: false),
                Fish(zone: 2, name: "Gibfish", info: "Fierce ocean predator equipped with razor-sharp teeth.", iconName: "icon_barracuda", isUnlocked: false),
                
                // ==================== ZONE 3 (Deep Sea Zone) ====================
                Fish(zone: 3, name: "Anglerfish", info: "Uses a natural glowing lure on its head to attract prey.", iconName: "icon_anglerfish", isUnlocked: false),
                Fish(zone: 3, name: "Coelacanth", info: "Living fossil rarely encountered by modern humans.", iconName: "icon_coelacanth", isUnlocked: false),
                Fish(zone: 3, name: "Oarfish", info: "Giant ribbon-like species swimming in the ocean depths.", iconName: "icon_oarfish", isUnlocked: false),
                Fish(zone: 3, name: "Blobfish", info: "Possesses a gelatinous body adapted to extreme underwater pressure.", iconName: "icon_blobfish", isUnlocked: false),
                Fish(zone: 3, name: "Lanternfish", info: "Illuminates the pitch-black ocean using bioluminescence.", iconName: "icon_lanternfish", isUnlocked: false),
                Fish(zone: 3, name: "Goblin Shark", info: "Bizarre deep-water shark featuring an elongated, protruding jaw.", iconName: "icon_goblinshark", isUnlocked: false),
                
                // ==================== ZONE 4 (Legendary Zone) ====================
                Fish(zone: 4, name: "Golden Koi", info: "Legend says this magnificent creature brings great fortune.", iconName: "icon_goldenkoi", isUnlocked: false),
                Fish(zone: 4, name: "Megawafish", info: "Colossal prehistoric shark that once ruled the ancient seas.", iconName: "icon_megalodon", isUnlocked: false),
                Fish(zone: 4, name: "Leviathan", info: "Mythical deep-ocean monster of enormous proportions.", iconName: "icon_leviathan", isUnlocked: false),
                Fish(zone: 4, name: "Abyssal Ray", info: "Gigantic glowing ray dwelling in the deepest ocean abyss.", iconName: "icon_abyssalray", isUnlocked: false),
                Fish(zone: 4, name: "Ghost Fish", info: "Features a completely transparent body, making it nearly invisible.", iconName: "icon_ghostfish", isUnlocked: false),
                Fish(zone: 4, name: "Cosmic Whale", info: "Mysterious entity rumored to be the size of an island.", iconName: "icon_cosmicwhale", isUnlocked: false)
            ]
        }}
