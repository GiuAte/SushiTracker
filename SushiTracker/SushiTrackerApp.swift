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
    @StateObject var soundManager = SoundManager.shared
    
    // Crea un'istanza di FoodData con il contesto di Core Data
    let foodData = FoodData(managedObjectContext: PersistenceController.shared.container.viewContext)

    var body: some Scene {
        WindowGroup {
            // MARK: PIETRO - Includi la NavigationView qui. Così non devi poi riportarla ovunque
            NavigationStack {
                ContentView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(keyboardHandling)
            .environmentObject(soundManager)
            .environmentObject(foodData)
        }
    }
}
