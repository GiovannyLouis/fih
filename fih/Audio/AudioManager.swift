//
//  AudioManager.swift
//  fih
//
//  Created by Jose Putra Perdana Taneo on 21/05/26.
//

import Foundation
import AVFoundation
import Observation

@Observable
class AudioManager {
    private var bgmPlayerMenu: AVAudioPlayer?
    private var bgmPlayerWave: AVAudioPlayer?
    private var bgmPlayerGame: AVAudioPlayer?
    
    private var sfxPlayers: [AVAudioPlayer] = []
    
    // MARK: Background Music
    func playBGM_Menu(volume: Float = 0.2) {
        if let player = bgmPlayerMenu, player.isPlaying {
                    print("BGM is already playing. Ignoring request.")
                    return
                }
        
        guard let url = Bundle.main.url(forResource: "bg_music", withExtension: "mp3") else {
            print("Could not find BGM Menu sound")
            return
        }
        
        do {
            bgmPlayerMenu = try AVAudioPlayer(contentsOf: url)
            bgmPlayerMenu?.numberOfLoops = -1
            bgmPlayerMenu?.volume = volume
            bgmPlayerMenu?.play()
            print("Playing BGM Menu sound")
        } catch {
            print("Audio error, could not play BGM Menu sound")
        }
    }
    
    func stopBGM_Menu() {
        bgmPlayerMenu?.setVolume(0, fadeDuration: 2.0)
        bgmPlayerMenu?.stop()
    }
    
    func playBGM_Wave(volume: Float = 0.2) {
        guard let url = Bundle.main.url(forResource: "wave", withExtension: "mp3") else {
            print("Could not find BGM Menu sound")
            return
        }
        
        do {
            bgmPlayerWave = try AVAudioPlayer(contentsOf: url)
            bgmPlayerWave?.numberOfLoops = -1
            bgmPlayerWave?.volume = volume
            bgmPlayerWave?.play()
            print("Playing BGM Wave sound")
        } catch {
            print("Audio error, could not play BGM Menu sound")
        }
    }
    
    func stopBGM_Wave() {
        bgmPlayerWave?.setVolume(0, fadeDuration: 2.0)
        bgmPlayerWave?.stop()
    }
    
    func playBGM_Game(filename: String, type: String = "mp3", volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: type) else {
            print("Could not find \(filename).\(type) sound")
            return
        }
        
        do {
            bgmPlayerGame = try AVAudioPlayer(contentsOf: url)
            bgmPlayerGame?.numberOfLoops = -1
            bgmPlayerGame?.volume = volume
            bgmPlayerGame?.play()
            print("Playing \(filename).\(type) sound")
        } catch {
            print("Audio error, could not play \(filename).\(type) sound")
        }
    }
    
    func stopBGM_Game() {
        bgmPlayerGame?.setVolume(0, fadeDuration: 2.0)
        bgmPlayerGame?.stop()
    }
    
    // MARK: Sound Effects
    func playSFX(filename: String, type: String = "mp3", volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: type) else {
            print("Could not find \(filename).\(type) sound")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.play()
            print("Playing \(filename).\(type) sound")
            
            sfxPlayers.append(player)
            
            sfxPlayers.removeAll { $0.isPlaying == false }
        } catch {
            print("Audio error, could not play \(filename).\(type) sound")
        }
    }
}
