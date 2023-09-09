//
//  RestaurantListViewModel.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import Foundation
import CoreData

class RestaurantListViewModel: ObservableObject {
    @Published var filteredRestaurants: [RestaurantItem] = []
    private var model = RestaurantModel()
    
    init() {
        loadRestaurants()
    }
    
    func loadRestaurants() {
        filteredRestaurants = model.restaurants
    }
    
    func deleteRestaurant(at offsets: IndexSet) {
        model.deleteRestaurant(at: offsets)
        loadRestaurants()
    }
}


