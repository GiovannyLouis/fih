//
//  GameTimer.swift
//  fih
//
//  Created by Muhammad Dzakki Abdullah on 13/05/26.
//

import Foundation

@Observable
class GameTimerServices {
    static let realSecondPerGameHour: Double = 10.0
    static let gameDurationHours: Double = 8.0
    static let totalRealSecond: Double = realSecondPerGameHour * gameDurationHours
    
    private(set) var gameHoursElapsed: Double = 0
    private(set) var isRunning: Bool = false
    
    private var timer: Timer?
    private let tickInterval : TimeInterval = 1
    
    
    var onTick: ((Double) -> Void)?
    var onTimeup: (() -> Void)?
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(
                   withTimeInterval: tickInterval,
                   repeats: true
               ) { [weak self] _ in
                   self?.tick()
               }
    }
    
    func pause () {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func resume () {
        guard !isRunning else { return }
        start()
    }
    
    func stop () {
        pause()
        gameHoursElapsed = 0
    }
    
    private func tick() {
        let hoursPerTick = tickInterval / GameTimerServices.realSecondPerGameHour
        gameHoursElapsed += hoursPerTick
        
        onTick?(gameHoursElapsed)
        
        if gameHoursElapsed >= GameTimerServices.gameDurationHours {
            pause()
            onTimeup?()
        }
        
    }
    
    var currentTimeDisplay: String {
        let totalMinutes = Int(gameHoursElapsed * 60)
        let hour = 9 + totalMinutes / 60
        let minute = totalMinutes % 60
        let ampm = hour < 12 ? "AM" : "PM"
        let display      = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
        return String(format: "%d:%02d %@", display, minute, ampm)
    }
    
    var progress: Double {
        min(gameHoursElapsed / GameTimerServices.gameDurationHours, 1.0)
    }
}
