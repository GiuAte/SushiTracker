//
//  RestaurantItemViewModel.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import Foundation
import CoreData

struct RestaurantItemViewModel: Identifiable {
    let id: NSManagedObjectID
    let name: String
    let description: String // Aggiungi altre proprietà del ristorante se necessario
    
    init(restaurantItem: RestaurantItem) {
        self.id = restaurantItem.objectID
        self.name = restaurantItem.name ?? ""
        self.description = restaurantItem.description ?? ""
        // Includi altre proprietà del ristorante se necessario
    }
}
