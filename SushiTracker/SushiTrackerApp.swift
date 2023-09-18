//
//  SushiTrackerApp.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 07/09/23.
//

import SwiftUI
import CoreData
import AVFoundation
import Foundation

@main
struct SushiTrackerApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var keyboardHandling = KeyboardHandling()
    @StateObject var soundManager = SoundManager.shared // Utilizzo dell'istanza condivisa

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(keyboardHandling)
                .environmentObject(soundManager)
        }
    }
}
