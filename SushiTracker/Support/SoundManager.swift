//
//  SoundManager.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 18/09/23.
//

import AVFoundation
import Foundation

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    @Published var audioPlayer: AVAudioPlayer?

    private init() {
    }

    func playSound(named name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Errore nella riproduzione del suono: \(error.localizedDescription)")
            }
        } else {
            print("File audio non trovato.")
        }
    }
}
