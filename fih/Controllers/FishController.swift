//
//  FishController.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 18/05/26.
//

import Foundation
import SwiftData

@Observable
class FishController {
    
    var filteredFishes: [Fish] = []
    
    var leftPageFishes: [Fish] {
        return stride(from: 0, to: filteredFishes.count, by: 2).map { filteredFishes[$0] }
    }
    
    var rightPageFishes: [Fish] {
        return stride(from: 1, to: filteredFishes.count, by: 2).map { filteredFishes[$0] }
    }
    
    @MainActor
    static func seedInitialData(context: ModelContext) {
        let descriptor = FetchDescriptor<Fish>()
        let existingFishCount = (try? context.fetchCount(descriptor)) ?? 0
        
        if existingFishCount == 0 {
            print("Database kosong. Memulai Seeding Data Ikan dari Controller...")
            
            let initialFishes = [
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
            
            for fish in initialFishes {
                context.insert(fish)
            }
            
            try? context.save()
            print("Seeding berhasil! \(initialFishes.count) ikan dimasukkan.")
        } else {
            print("Database sudah berisi \(existingFishCount) ikan. Aman.")
        }
    }
    
    func filterFishes(byZone zone: Int, context: ModelContext) {
        print("Mencari ikan untuk Zona \(zone)...")
        
        let targetZone = zone // Pindahkan ke variabel lokal agar Predicate SwiftData tidak bingung
        
        // Buat perintah pencarian: Cari ikan yang zonanya sama, lalu urutkan sesuai nama
        let descriptor = FetchDescriptor<Fish>(
            predicate: #Predicate { $0.zone == targetZone },
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            // Jalankan pencarian dan simpan hasilnya ke array
            filteredFishes = try context.fetch(descriptor)
            print("Ditemukan \(filteredFishes.count) ikan di Zona \(zone).")
        } catch {
            print("Gagal mengambil data ikan: \(error.localizedDescription)")
            filteredFishes = []
        }
    }
}
