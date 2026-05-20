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
    let fish: [String]
}

enum ExpeditionResult{
    case inProgress
    case timeUp
    case safeReturn
    case shipDestroyed
}

@Observable
class InGameController {

    let selectedShip: Ship
    let equippedItems: [Equipment]
    let actualWeather: WeatherType
    weak var gameScene: GameScene?
    
    let timer = GameTimerServices()
    
    var currentHealth : Double
    var currentSpeed : Double
    var isEngineFailing: Bool = false
    var guardianAngelHitsRemaining: Int = 3
    
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
        fishZoneInfo(name: "Zone 1", startKm: 0,  endKm: 10,fish: ["Tuna", "Salmon", "Sardine", "Mackerel", "Anchovy", "Snapper"]),
        fishZoneInfo(name: "Zone 2", startKm: 10, endKm: 25,fish: ["Clownfish", "Blue Tang", "Pufferfish", "Grouper", "Mahi Mahi", "Barracuda"]),
        fishZoneInfo(name: "Zone 3", startKm: 25, endKm: 45, fish: ["Anglerfish", "Coelacanth", "Oarfish", "Blobfish", "Lanternfish", "Goblin Shark"]),
        fishZoneInfo(name: "Zone 4", startKm: 45, endKm: 100,fish: ["Golden Koi", "Megalodon", "Leviathan", "Abyssal Ray", "Ghost Fish", "Cosmic Whale"]),
    ]
    var currentZone: fishZoneInfo? {
        zones.first { distanceTravelledKm >= $0.startKm && distanceTravelledKm < $0.endKm }
    }
    
    func randomFishForCurrentZone () -> String? {
        currentZone? .fish.randomElement()
    }
    
//    // MARK: - Equipment helpers
//    var hasShield: Bool       { equippedItems.contains { $0.type == .shield } }
//    var hasScarecrow: Bool    { equippedItems.contains { $0.type == .scarecrow } }
//    var hasPredatorBait: Bool { equippedItems.contains { $0.type == .predatorBait } }
    var hasSoulEater: Bool    { equippedItems.contains { $0.type == .soulEater } }
    var hasLuckyHat: Bool     { equippedItems.contains { $0.type == .luckyHat } }   // does nothing :)

    var hasGuardianAngel: Bool {
        equippedItems.contains { $0.type == .guardianAngel } && guardianAngelHitsRemaining > 0
    }
    
    init (ship : Ship, equippedItems : [Equipment], actualWeather: WeatherType) {
        self.selectedShip = ship
        self.equippedItems = equippedItems
        self.actualWeather = actualWeather
        self.currentHealth = Double(ship.maxDurability)
        
        let hasThrusters = equippedItems.contains(where: { $0.type == .rocketThrusters })
        self.currentSpeed = Double (ship.maxSpeed) * (hasThrusters ? 1.25 : 1.0)
        
        print("In Game Ship: \(self.selectedShip.name)")
        print("In Game Equipped items:")
        for item in self.equippedItems {
            print("  - \(item.name)")
        }
        print("In Game Actual Weather: \(self.actualWeather.displayName)")
        
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
    
    func pauseExpedition () {
        timer.pause()
        movementTimer?.invalidate()
        movementTimer = nil
        eventTimer?.invalidate()
        eventTimer = nil
    }
    
    func resumeExpedition () {
        guard !isExpeditionOver else { return }
        timer.resume()
        movementTimer = Timer.scheduledTimer(withTimeInterval: movementInterval, repeats: true) { [weak self] _ in self?.moveShip() }
        eventTimer = Timer.scheduledTimer(withTimeInterval: eventInterval, repeats: true) { [weak self] _ in self?.spawnEvent() }
    }
    
    func abortExpedition () {
        endExpedition(result: .safeReturn)
    }
    
    private func moveShip() {
        if isEngineFailing {
            currentSpeed = max(Double(selectedShip.minSpeed), currentSpeed - Double(selectedShip.maxSpeed) * 0.02)
        }
        
        let kmPerSecond = currentSpeed / GameTimerServices.realSecondPerGameHour
        distanceTravelledKm += kmPerSecond
        
        print("Ship moved \(kmPerSecond) km/h, travelled \(distanceTravelledKm) km")
        distanceTravelledKm = max(0, distanceTravelledKm + kmPerSecond)
        distanceTravelledKm += kmPerSecond
        
        print("Ship moved \(kmPerSecond) km/h, travelled \(distanceTravelledKm) km")
    }
    
    private func spawnEvent() {
        let roll = Double.random(in: 0...1)
        if roll < 0.7 {
            spawnfish()
        } else {
            triggerObstacle()
        }
    }
    
    private func spawnfish() {
        guard  let fishName = randomFishForCurrentZone() else { return }
        let iconName = fishIconName(for: fishName)
        gameScene?.spawnFishVisual(iconName: iconName, fishName: fishName)
    }
    private func fishIconName(for name: String) -> String {
        let mapping: [String: String] = [
            // Zone 1
            "Tuna":      "fish_blue",
            "Salmon":    "fish_red",
            "Sardine":   "fish_blue",
            "Mackerel":  "fish_red",
            "Anchovy":   "fish_blue",
            "Snapper":   "fish_red",
            // Zone 2
            "Clownfish": "fish_red",
            "Blue Tang": "fish_blue",
            "Pufferfish":"fish_red",
            "Grouper":   "fish_blue",
            "Mahi Mahi": "fish_red",
            "Barracuda": "fish_blue",
            // Zone 3
            "Anglerfish":"fish_red",
            "Coelacanth":"fish_blue",
            "Oarfish":   "fish_red",
            "Blobfish":  "fish_blue",
            "Lanternfish":"fish_red",
            "Goblin Shark":"fish_blue",
            // Zone 4
            "Golden Koi":"fish_red",
            "Megalodon": "fish_blue",
            "Leviathan": "fish_red",
            "Abyssal Ray":"fish_blue",
            "Ghost Fish":"fish_red",
            "Cosmic Whale":"fish_blue",
        ]
        return mapping[name] ?? "fish_blue"
    }
    
    func catchFish(_ fishName: String) {
        guard !isExpeditionOver else { return }
        catchLog.append(fishName)
 
        if hasSoulEater {
            let heal = Double(selectedShip.maxDurability) * 0.03
            currentHealth = min(Double(selectedShip.maxDurability), currentHealth + heal)
        }
        showEvent(" Caught \(fishName)!")
    }
    
    func triggerObstacle() {
        guard !isExpeditionOver else { return }
                
        // 80/20 Roll for Weather vs General Obstacle
        let isWeatherSpecific = Double.random(in: 0...1) <= 0.80
        var chosenObstacleType: ObstacleType
        
        if isWeatherSpecific {
            switch actualWeather {
            case .sunny: chosenObstacleType = .albatros
            case .rainy: chosenObstacleType = .lightning
            case .snowy: chosenObstacleType = .iceberg
            case .windy: chosenObstacleType = .tornado
            }
        } else {
            // General obstacle: 50% Predator, 50% Engine Failure
            chosenObstacleType = Bool.random() ? .predator : .shipFailure
        }
        
        // Let ObstacleController handle the effects
        ObstacleController.applyEffects(obstacleType: chosenObstacleType, to: self)
    }
    
//    func applyDamage(_ amount: Double) {
//        if hasGuardianAngel {
//            guardianAngelHitsRemaining -= 1
//            
//            if guardianAngelHitsRemaining == 0 {
//                showEvent("Guardian Angel destroyed!")
//            } else {
//                showEvent("Blocked! (\(guardianAngelHitsRemaining) left)")
//            }
//            return
//        }
//        
//        let finalDamage = amount * damageMultiplier
//        currentHealth = max(0, currentHealth - finalDamage)
//        if currentHealth <= 0 {
//            endExpedition(result: .shipDestroyed)
//        }
//    }
    
    func showEvent(_ message: String) {
        latestEventMessage = message
        showEventPopup = true
        // AutoHide popup 2 detik
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showEventPopup = false
        }
    }
    
    func endExpedition(result: ExpeditionResult) {
//        @Environment(AppStateManager.self) var appState

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
//        appState.resetForecast()
    }
    
    var healthPercentage: Double {
        guard selectedShip.maxDurability > 0 else { return 0 }
        return currentHealth / Double(selectedShip.maxDurability)
    }
}
