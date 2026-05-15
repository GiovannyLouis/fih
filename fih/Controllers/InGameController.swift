//
//  PlayingController.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 13/05/26.
//

import SwiftUI

struct fishZoneInfo{
    let name : String
    let startKm: Double
    let endKm: Double
}

@Observable
class InGameController {

    let selectedShip: Ship
    let equippedItems: [Equipment]
    
    let timer = GameTimerServices()
    
    var currentHealth : Double
    var currentSpeed : Double
    var isAlive : Bool {currentHealth > 0}
    
    var distanceTravelledKm : Double = 0
    var catchLog : [String] = []
    var isExpeditionOver : Bool = false
    var expeditionResults : ExpeditionResult = .inProgress
    
    var latestEventMessage : String = ""
    var showEventPopup: Bool = false
    
    private var movementTimer: Timer?
    private var eventTimer: Timer?
    private let movementInterval: TimeInterval = 1.0
    private let eventInterval: TimeInterval = 3.0
    
    let zones: [fishZoneInfo] = [
        fishZoneInfo(name: "Zone 1",startKm: 0,endKm: 5),
        fishZoneInfo(name: "Zone 2",startKm: 5,endKm: 15),
        fishZoneInfo(name: "Zone 3",startKm: 15,endKm: 30),
        fishZoneInfo(name: "Zone 4",startKm: 30,endKm: 50),
    ]
    var currentZone: fishZoneInfo? {
        zones.first { distanceTravelledKm >= $0.startKm && distanceTravelledKm < $0.endKm }
    }
    
    // MARK: - Equipment helpers
    var hasShield: Bool       { equippedItems.contains { $0.type == .shield } }
    var hasScarecrow: Bool    { equippedItems.contains { $0.type == .scarecrow } }
    var hasPredatorBait: Bool { equippedItems.contains { $0.type == .predatorBait } }
    var hasSoulEater: Bool    { equippedItems.contains { $0.type == .soulEater } }
    var hasLuckyHat: Bool     { equippedItems.contains { $0.type == .luckyHat } }   // does nothing :)

    var guardianAngelHitsRemaining: Int = 3
    var hasGuardianAngel: Bool {
        equippedItems.contains { $0.type == .guardianAngel } && guardianAngelHitsRemaining > 0
    }
    
    var damageMultiplier: Double { hasShield ? 0.7 : 1.0 }
    
    init (ship : Ship, equippedItems : [Equipment]) {
        self.selectedShip = ship
        self.equippedItems = equippedItems
        self.currentHealth = Double(ship.maxDurability)
        
        let hasThrusters = equippedItems.contains(where: { $0.type == .rocketThrusters })
        self.currentSpeed = Double (ship.maxSpeed) + (hasThrusters ? 1.25 : 1.0)
    }
    
    func startExpedition() {
        guard !isExpeditionOver else { return }
        
        timer.onTimeup = { [weak self] in
            self?.endExpedition(result: .timeUp)
        }
        timer.start()
        
        movementTimer = Timer.scheduledTimer(withTimeInterval: movementInterval, repeats: true) { [weak self] _ in
            self?.moveShip()
        }
        
        eventTimer = Timer.scheduledTimer(withTimeInterval: eventInterval, repeats: true) { [weak self] _ in
            self?.spawnEvent()
        }
    }
    
    func abortExpedition () {
        endExpedition(result: .safeReturn)
    }
    
    private func moveShip() {
        let kmPerSecond = currentSpeed / GameTimerServices.realSecondPerGameHour
        distanceTravelledKm += kmPerSecond
    }
    
    private func spawnEvent() {
        let roll = Double.random(in: 0...1)
        if roll < 0.6 {
            catchFish()
        } else {
            triggerObstacle()
        }
    }
    private func catchFish() {
        let fishNames = ["Sardine", "Mackerel", "Tuna", "Snapper", "Barracuda",
                         "Swordfish", "Marlin", "Anglerfish", "Viperfish", "Kraken"]
        guard let fish = fishNames.randomElement() else { return }
        catchLog.append(fish)
        
        // Soul Eater: heal 3% max HP per ikan
        if hasSoulEater {
            let heal = Double(selectedShip.maxDurability) * 0.03
            currentHealth = min(Double(selectedShip.maxDurability), currentHealth + heal)
        }
        showEvent("Caught \(fish)!")
    }
    
    func triggerObstacle() {
        // Placeholder dengan ObstacleController (LUIS)
        let rawDamage = Double.random(in: 10...40)
        let finalDamage = rawDamage * damageMultiplier
        applyDamage(finalDamage)
        showEvent("Obstacle! -\(Int(finalDamage)) HP")
    }
    
    func applyDamage(_ amount: Double) {
        if hasGuardianAngel {
            guardianAngelHitsRemaining -= 1
            
            if guardianAngelHitsRemaining == 0 {
                
            }
            return
        }
        
        let finalDamage = amount * damageMultiplier
        currentHealth = max(0, currentHealth - finalDamage)
        if currentHealth <= 0 {
            endExpedition(result: .shipDestroyed)
        }
    }
    
    private func showEvent(_ message: String) {
        latestEventMessage = message
        showEventPopup = true
        // Auto-hide popup setelah 2 detik
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showEventPopup = false
        }
    }
    
    private func endExpedition(result: ExpeditionResult) {
        @Environment(AppStateManager.self) var appState

        guard !isExpeditionOver else { return }
        
        timer.stop()
        movementTimer?.invalidate()
        movementTimer = nil
        eventTimer?.invalidate()
        eventTimer = nil
        
        if result == .shipDestroyed {
            catchLog.removeAll()  // semua ikan hilang
        }
        expeditionResults = result
        isExpeditionOver = true
        appState.resetForecast()
    }
    
    var healthPercentage: Double {
        guard selectedShip.maxDurability > 0 else { return 0 }
        return currentHealth / Double(selectedShip.maxDurability)
    }
    
    var healthColor: String {
        if healthPercentage > 0.5 { return "healthGreen" }
        if healthPercentage > 0.25 { return "healthOrange" }
        return "healthRed"
    }
}
enum ExpeditionResult {
    case inProgress
    case timeUp
    case safeReturn
    case shipDestroyed
}
