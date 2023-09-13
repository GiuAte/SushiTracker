//
//  RestaurantDetailViewModel.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import Foundation
import MapKit
import CoreLocation


class RestaurantDetailViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var rating: String = ""
    @Published var restaurantCoordinate: CLLocationCoordinate2D?
    
    func geocodeAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let location = placemarks?.first?.location?.coordinate {
                self?.restaurantCoordinate = location
            }
        }
    }
    
    init(restaurant: RestaurantItem) {
        self.name = restaurant.name ?? ""
        self.address = restaurant.address ?? ""
        self.rating = String(restaurant.rating) 
    }
    
}
