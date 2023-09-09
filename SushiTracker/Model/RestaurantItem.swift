//
//  RestaurantItem.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import SwiftUI

import CoreData

class RestaurantModel: ObservableObject {
    @Published var restaurants: [RestaurantItem] = []
    
    func addRestaurant(name: String, address: String, rating: Int) {
        let newRestaurant = RestaurantItem(context: PersistenceController.shared.container.viewContext)
        newRestaurant.name = name
        newRestaurant.address = address
        newRestaurant.rating = Int16(rating)
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            restaurants.append(newRestaurant)
        } catch {
            
            print("Errore nel salvataggio: \(error.localizedDescription)")
        }
    }
    
    
    func loadRestaurants() {
        let request: NSFetchRequest<RestaurantItem> = RestaurantItem.fetchRequest()
        do {
            restaurants = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
        
            print("Errore nella ricezione dei dati: \(error.localizedDescription)")
        }
    }

    
    func deleteRestaurant(at indexSet: IndexSet) {
        for index in indexSet {
            let restaurant = restaurants[index]
            PersistenceController.shared.container.viewContext.delete(restaurant)
            restaurants.remove(at: index)
        }
        
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            
            print("Errore nel salvataggio del contesto: \(error.localizedDescription)")
        }
    }
}
