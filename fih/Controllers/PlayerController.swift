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
    
    var totalUnlockedFish: Int = 0
    
    var isNewFishUnlocked = false
    
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
                
                if currentPlayer.isNewFishUnlocked {
                    currentPlayer.isNewFishUnlocked = false
                    try context.save()
                }
                                
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
            print("Gagal mengambil data hari: \(error.localizedDescription)")
        }
        
    }
    
    func getNewFishUnlocked(context: ModelContext) {
        let descriptor = FetchDescriptor<Player>()
        
        do {
            let players = try context.fetch(descriptor)
            if let currentPlayer = players.first {
                self.isNewFishUnlocked = currentPlayer.isNewFishUnlocked
            }
        } catch {
            self.isNewFishUnlocked = false
        }
    }
    
    
    func incrementDays(context: ModelContext) {
        let descriptor = FetchDescriptor<Player>()
        
        do {
            let players = try context.fetch(descriptor)
            if let currentPlayer = players.first {
                currentPlayer.totalDays += 1
                try context.save()
            }
        } catch {
            print("Gagal meng-update hari: \(error.localizedDescription)")
        }
    }
    
    
    func collectFish(context: ModelContext, catchFish: [Fish]) {
        // Jika tidak ada ikan yang ditangkap, hentikan fungsi
        guard !catchFish.isEmpty else { return }
            
        // 1. HAPUS DUPLIKAT
        // ambil nama ikan nya saja
        // menggunakan SET agar otomatis hanya mengambil unique valuenya saja
        let uniqueCaughtNames = Set(catchFish.map { $0.name })
            
        let descriptor = FetchDescriptor<Player>()
            
        do {
            let players = try context.fetch(descriptor)
            guard let currentPlayer = players.first else {
                return
            }
            
            var isDataChanged = false
            
            // 2. LOOP SEPANJANG ARRAY IKAN (Tangkapan Unik):
            for caughtName in uniqueCaughtNames {
                // Cari ikan yang namanya cocok di dalam "buku koleksi" Player
                if let matchedFish = currentPlayer.collectedFish.first(where: { $0.name == caughtName }) {
                    // 3. CEK JIKA STATUS IKAN MASIH TERKUNCI:
                    if !matchedFish.isUnlocked {
                        matchedFish.isUnlocked = true
                        isDataChanged = true
                    }
                }
            }
            
            // 4. SIMPAN PERUBAHAN:
            // hanya akan save jika minimal ada 1 ikan yang berubah/terbuka
            if isDataChanged {
                currentPlayer.isNewFishUnlocked = true
                try context.save()
            } else {
                return
            }
            
        } catch {
            print("Gagal meng-update koleksi ikan: \(error.localizedDescription)")
        }
    }
    
    func getTotalUnlockedFish(context: ModelContext) {
        let descriptor = FetchDescriptor<Player>()
        
        do {
            let players = try context.fetch(descriptor)
            if let currentPlayer = players.first {
                self.totalUnlockedFish = currentPlayer.collectedFish.filter {
                    $0.isUnlocked
                }.count
            }
        } catch {
            print("Gagal menghitung ikan yang terbuka: \(error.localizedDescription)")
        }
    }
    
    func resetData(context: ModelContext) {
        let descriptor = FetchDescriptor<Player>()
        
        do {
            let existingPlayers = try context.fetch(descriptor)
            
            for player in existingPlayers {
                context.delete(player)
            }
            
            let defaultFishCollection = Fish.allFish
            
            let newPlayer = Player(intialDays: 1, collectedFish: defaultFishCollection)
            
            context.insert(newPlayer)
            try context.save()
            
            self.currentDays = 1
            self.totalUnlockedFish = 0

            self.filteredFishes = []
        } catch {
            print("Gagal mereset data player: \(error.localizedDescription)")
        }
    }
}
