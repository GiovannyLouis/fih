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
                // ZONA 1
                Fish(zone: 1, name: "Tuna", info: "Short explanation of the fish", iconName: "fish_blue", isUnlocked: true),
                Fish(zone: 1, name: "Tuna 2", info: "Short explanation of the fish", iconName: "fish_red", isUnlocked: false),
                Fish(zone: 1, name: "Tuna 3", info: "Short explanation of the fish", iconName: "fish_blue", isUnlocked: false),
                
                // ZONA 2
                Fish(zone: 2, name: "Salmon", info: "Loves swimming upstream", iconName: "fish_red", isUnlocked: false),
                
                // Tambahkan sisa ikan lainnya...
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
