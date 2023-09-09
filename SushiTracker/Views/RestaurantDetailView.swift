//
//  RestaurantDetailView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 07/09/23.
//

import SwiftUI

struct RestaurantDetailView: View {
    @ObservedObject var viewModel: RestaurantDetailViewModel
    
    init(viewModel: RestaurantDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(viewModel.address)
                    .font(.body)
                    .fontWeight(.light)
                
                Spacer()
            }
            .background(Color.yellow)
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.preview.viewContext
        let restaurant = RestaurantItem(context: context)
        restaurant.name = "Nome del Ristorante"
        restaurant.address = "Indirizzo del Ristorante"
        restaurant.rating = 10
        
        let viewModel = RestaurantDetailViewModel(restaurant: restaurant)
        
        return RestaurantDetailView(viewModel: viewModel)
    }
}
