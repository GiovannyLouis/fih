////
////  PersistanceServices.swift
////  fih
////
////  Created by Muhammad Dzakki Abdullah on 13/05/26.
////
//
//import Foundation
//import SwiftData
//
//import Foundation
//import SwiftData
//
//
//@Model
//final class PersistedGameState {
//    var dayCount: Int
//    var totalFishCollected: Int
//    var collectedFishNames: [String]
//
//    init() {
//        self.dayCount             = 1
//        self.totalFishCollected   = 0
//        self.collectedFishNames   = []
//    }
//}
//
//final class PersistenceService {
//
//    private let modelContainer: ModelContainer
//    private let context: ModelContext
//
//    init() {
//        let schema    = Schema([PersistedGameState.self])
//        let config    = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        modelContainer = try! ModelContainer(for: schema, configurations: [config])
//        context        = ModelContext(modelContainer)
//    }
//
//    func save(gameState: GameState) {
//        let existing = fetchPersisted()
//        let record   = existing ?? PersistedGameState()
//
//        record.dayCount             = gameState.dayCount
//        record.totalFishCollected   = gameState.totalFishCollected
//        record.collectedFishNames   = gameState.fishCollection.map { $0.name }
//
//        if existing == nil {
//            context.insert(record)
//        }
//
//        do {
//            try context.save()
//        } catch {
//            print("[PersistenceService] Save failed: \(error)")
//        }
//    }
//
//    func load() -> GameState {
//        var state = GameState()
//        guard let record = fetchPersisted() else { return state }
//
//        state.dayCount           = record.dayCount
//        state.totalFishCollected = record.totalFishCollected
//        
//        let nameSet = Set(record.collectedFishNames)
//        state.fishCollection = Fish.catalogue
//            .filter { nameSet.contains($0.name) }
//            .map { fish in
//                var f = fish
//                f.isCollected = true
//                return f
//            }
//
//        return state
//    }
//
//
//    func reset() {
//        if let record = fetchPersisted() {
//            context.delete(record)
//            try? context.save()
//        }
//    }
//
//    private func fetchPersisted() -> PersistedGameState? {
//        let descriptor = FetchDescriptor<PersistedGameState>()
//        return try? context.fetch(descriptor).first
//    }
//}
