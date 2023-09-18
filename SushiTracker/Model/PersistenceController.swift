//
//  PersistenceController.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    
    var preview: NSPersistentContainer {
        let container = NSPersistentContainer(name: "SushiDataModel")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Errore durante il caricamento del negozio persistente: \(error), \(error.userInfo)")
            }
        }
        return container
    }
    
    private init() {
        container = NSPersistentContainer(name: "SushiDataModel")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Errore durante il caricamento del negozio persistente: \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Errore durante il salvataggio del contesto: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
