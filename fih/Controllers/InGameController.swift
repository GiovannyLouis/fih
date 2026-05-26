//
//  PlayingController.swift
//  PilihKapal
//
//  Created by Satriya Handha Wibowo on 13/05/26.
//

import SwiftUI
import UIKit

struct FishZoneInfo{
    let name : String
    let startKm: Double
    let endKm: Double
    let fishes: [Fish]
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
    //var currentSpeed : Double
    var isEngineFailing: Bool = false
    var guardianAngelHitsRemaining: Int = 3
    
    var distanceTravelledKm : Double = 0
    var catchLog : [Fish] = []
    var isExpeditionOver : Bool = false
    var expeditionResults : ExpeditionResult = .inProgress
    
    var showCatchFishPopup: Bool = false
    var showObstaclePopup: Bool = false
    var latestFishMessage: String = ""
    var latestCatchedFishIcon: String? = nil
    var latestObstacleMessage: String = ""

    var onPlaySFX: ((String) -> Void)?
    var hapticStyle: ((UIImpactFeedbackGenerator.FeedbackStyle) -> Void)?
    
    private var movementTimer: Timer?
    private var eventTimer: Timer?
    private let movementInterval: TimeInterval = 1.0
    private let eventInterval: TimeInterval = 3.0
    
    let zones: [FishZoneInfo] = [
        FishZoneInfo(
            name: "Zone 1",
            startKm: 0,
            endKm: 30,
            // Menyaring allFish: "Ambil semua ikan yang properti zone-nya bernilai 1"
            fishes: Fish.allFish.filter { $0.zone == 1 }
        ),
        FishZoneInfo(
            name: "Zone 2",
            startKm: 30,
            endKm: 80,
            fishes: Fish.allFish.filter { $0.zone == 2 }
        ),
        FishZoneInfo(
            name: "Zone 3",
            startKm: 80,
            endKm: 150,
            fishes: Fish.allFish.filter { $0.zone == 3 }
        ),
        FishZoneInfo(
            name: "Zone 4",
            startKm: 150,
            endKm: 1000,
            fishes: Fish.allFish.filter { $0.zone == 4 }
        )
    ]

    var currentZone: FishZoneInfo? {
        zones.first { distanceTravelledKm >= $0.startKm && distanceTravelledKm < $0.endKm }
    }
    
    func randomFishForCurrentZone() -> Fish? {
        guard let fishesInZone = currentZone?.fishes, !fishesInZone.isEmpty else {
            return nil
        }
        return fishesInZone.randomElement()
    }
    
//    // MARK: - Equipment helpers
//    var hasShield: Bool       { equippedItems.contains { $0.type == .shield } }
//    var hasScarecrow: Bool    { equippedItems.contains { $0.type == .scarecrow } }
//    var hasPredatorBait: Bool { equippedItems.contains { $0.type == .predatorBait } }
    var hasThrusters: Bool    { equippedItems.contains { $0.type == .rocketThrusters } }
    var hasSoulEater: Bool    { equippedItems.contains { $0.type == .soulEater } }
    var hasLuckyHat: Bool     { equippedItems.contains { $0.type == .luckyHat } }   // does nothing :)

    var hasGuardianAngel: Bool {
        equippedItems.contains { $0.type == .guardianAngel } && guardianAngelHitsRemaining > 0
    }
    
    var currentSpeed : Double {
        didSet {
            let effectiveMaxSpeed = Double(selectedShip.maxSpeed) + (hasThrusters ? 20 : 0)
            // Whenever currentSpeed changes, update the scene's visual speed
            gameScene?.updateVisualSpeed(
                currentSpeed: currentSpeed,
                maxSpeed: effectiveMaxSpeed
            )
        }
    }
    
    init (ship : Ship, equippedItems : [Equipment], actualWeather: WeatherType) {
        self.selectedShip = ship
        self.equippedItems = equippedItems
        self.actualWeather = actualWeather
        self.currentHealth = Double(ship.maxDurability)
        
        let hasThrusters = equippedItems.contains(where: { $0.type == .rocketThrusters })
        self.currentSpeed = Double (ship.maxSpeed) + (hasThrusters ? 20 : 0)
        
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
        
        if hasLuckyHat {
            gameScene?.equipmentVisual(.luckyHat)
        }
        
        if hasThrusters {
            gameScene?.equipmentVisual(.rocketThrusters)
        }
        
        let kmPerSecond = currentSpeed / GameTimerServices.realSecondPerGameHour
        distanceTravelledKm += kmPerSecond

    }
    
    private func spawnEvent() {
        let roll = Double.random(in: 0...1)
        if roll < 0.1 {
            spawnfish()
        } else {
            triggerObstacle()
        }
    }
    
    private func spawnfish() {
        guard  let spawnedFish = randomFishForCurrentZone() else { return }
        gameScene?.spawnFishVisual(fish: spawnedFish)
    }
    
    func catchFish(_ catchedFish: Fish) {
        guard !isExpeditionOver else { return }
        catchLog.append(catchedFish)
 
        onPlaySFX?("get_fish")
        hapticStyle?(.medium)
        
        if hasSoulEater {
            let heal = 3.0
            currentHealth = min(Double(selectedShip.maxDurability), currentHealth + heal)
            gameScene?.equipmentVisual(.soulEater)
        }
        triggerFishPopUp(
            "+1 \(catchedFish.name)!",
            iconName: catchedFish.iconName
        )
    }
    
    func triggerObstacle() {
        guard !isExpeditionOver else { return }
                
        // 80/20 Roll for Weather vs General Obstacle
        let isWeatherSpecific = Double.random(in: 0...1) <= 0.10
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
        Task {
            await ObstacleController.applyEffects(obstacleType: chosenObstacleType, to: self)
        }
    }
    
    func triggerFishPopUp(_ message: String, iconName: String?) {
        self.latestFishMessage = message
        self.latestCatchedFishIcon = iconName
        
        // Nyalakan popup ikan
        withAnimation(.easeOut(duration: 0.3)) {
            self.showCatchFishPopup = true
        }
        
        // Auto-hide khusus untuk ikan (2 detik)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            withAnimation(.easeIn(duration: 0.5)) {
                self?.showCatchFishPopup = false
            }
        }
    }
        
    // MARK: - EVENT KHUSUS OBSTACLE
    func triggerObstaclePopUp(_ message: String) {
        self.latestObstacleMessage = message
        
        // Nyalakan popup obstacle
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            self.showObstaclePopup = true
        }
        
        // Auto-hide khusus untuk obstacle (2 detik)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            withAnimation(.easeIn(duration: 0.3)) {
                self?.showObstaclePopup = false
            }
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
        // SFX matching the expedition ending condition
        switch result {
        case .shipDestroyed:
            onPlaySFX?("ship_destroyed")
            hapticStyle?(.heavy)
        case .safeReturn:
            onPlaySFX?("safe_return")
            hapticStyle?(.heavy)
        case .timeUp:
            onPlaySFX?("safe_return")
            hapticStyle?(.heavy)
        case .inProgress:
            break
        }
    }
    
    var healthPercentage: Double {
        guard selectedShip.maxDurability > 0 else { return 0 }
        return currentHealth / Double(selectedShip.maxDurability)
    }
}
