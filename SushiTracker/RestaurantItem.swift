//
//  RestaurantItem.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import SwiftUI

import CoreData

class RestaurantModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    
    // Metodo per aggiungere un nuovo ristorante
    func addRestaurant(name: String, address: String, rating: Int) {
        let newRestaurant = Restaurant(context: PersistenceController.shared.container.viewContext)
        newRestaurant.name = name
        newRestaurant.address = address
        newRestaurant.rating = Int16(rating)
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            restaurants.append(newRestaurant)
        } catch {
            // Gestisci l'errore di salvataggio di Core Data
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    // Metodo per caricare i ristoranti da Core Data
    func loadRestaurants() {
        let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        do {
            restaurants = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            // Gestisci l'errore di caricamento da Core Data
            print("Error fetching restaurants: \(error.localizedDescription)")
        }
    }
    
    // Metodo per eliminare un ristorante
    func deleteRestaurant(at indexSet: IndexSet) {
        for index in indexSet {
            let restaurant = restaurants[index]
            PersistenceController.shared.container.viewContext.delete(restaurant)
            restaurants.remove(at: index)
        }
        
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            // Gestisci l'errore di eliminazione di Core Data
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
