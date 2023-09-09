//
//  ContentViewModel.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import SwiftUI
import CoreData

class ContentViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var showingRestaurantPopup = false
    
    private let managedObjectContext: NSManagedObjectContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RestaurantItem.name, ascending: true)],
        animation: .default)
    var restaurants: FetchedResults<RestaurantItem>
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func deleteRestaurant(at offsets: IndexSet) {
        for offset in offsets {
            let restaurant = restaurants[offset]
            managedObjectContext.delete(restaurant)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    func loadRestaurants() {
    
    }
}
