//
//  PlayerController.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 20/05/26.
//

import Foundation
import SwiftData

@Observable
class PlayerController {
    
    var filteredFishes: [Fish] = []
    
    var leftPageFishes: [Fish] {
        return stride(from: 0, to: filteredFishes.count, by: 2).map { filteredFishes[$0] }
    }
    
    var rightPageFishes: [Fish] {
        return stride(from: 1, to: filteredFishes.count, by: 2).map { filteredFishes[$0] }
    }
    
    var currentDays: Int = 0
    
    @MainActor
    static func seedInitialData(context: ModelContext) {
        
        let descriptor = FetchDescriptor<Player>()
        let existingPlayer = (try? context.fetchCount(descriptor)) ?? 0
        let collectedFish: [Fish] = Fish.allFish
        
        if existingPlayer == 0 {
            let initialPlayer = Player(intialDays: 1, collectedFish: collectedFish)
            
            context.insert(initialPlayer)
            
            try? context.save()
            print("Seeding berhasil! data player berhasil dimasukkan.")
            
        } else {
            print("Database sudah berisi player, Aman.")

        }
    }
    
    // --- KODE YANG DIPERBARUI ---
    func filterFishes(byZone zone: Int, context: ModelContext) {
        print("Mencari ikan untuk Zona \(zone)...")
        
        // 1. Buat perintah pencarian untuk mengambil Player
        let descriptor = FetchDescriptor<Player>()
        
        do {
            // 2. Tarik data Player dari SwiftData
            let players = try context.fetch(descriptor)
            
            // 3. Pastikan Player ditemukan (ambil yang pertama)
            if let currentPlayer = players.first {
                
                // 4. Saring array 'collectedFish' pakai fungsi .filter bawaan Swift
                let fishesInZone = currentPlayer.collectedFish.filter { $0.zone == zone }
                
                // 5. Urutkan ikan berdasarkan nama sesuai abjad
                let sortedFishes = fishesInZone.sorted { $0.name < $1.name }
                
                // 6. Masukkan hasilnya ke variabel yang ditampilkan di layar
                self.filteredFishes = sortedFishes
                
                print("Ditemukan \(filteredFishes.count) ikan di Zona \(zone).")
            } else {
                print("Data Player tidak ditemukan di database.")
                self.filteredFishes = []
            }
            
        } catch {
            print("Gagal mengambil data player: \(error.localizedDescription)")
            self.filteredFishes = []
        }
    }
    
    func getDays(context: ModelContext) {
        let descriptor = FetchDescriptor<Player>()

        do {
            //print("berhasil mengambil data hari")
            let players = try context.fetch(descriptor)
            if let currentPlayer = players.first {
                self.currentDays = currentPlayer.totalDays
            }
        } catch {
            //print("gagal mengambil data hari")
            self.currentDays = 0
        }
        
    }
}
