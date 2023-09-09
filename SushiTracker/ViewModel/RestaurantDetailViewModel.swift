//
//  RestaurantDetailViewModel.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import Foundation

class RestaurantDetailViewModel: ObservableObject {
    @Published var name: String
    @Published var address: String

    init(restaurant: RestaurantItem) {
        self.name = restaurant.name ?? ""
        self.address = restaurant.address ?? ""
    }
}
