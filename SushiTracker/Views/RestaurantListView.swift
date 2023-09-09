//
//  RestaurantListView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 08/09/23.
//


import SwiftUI

struct RestaurantListView: View {
    @ObservedObject private var viewModel: RestaurantListViewModel
    
    init(viewModel: RestaurantListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.filteredRestaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(viewModel: RestaurantDetailViewModel(restaurant: restaurant))) {
                        RestaurantRowView(restaurant: restaurant)
                    }
                }
                .onDelete(perform: viewModel.deleteRestaurant)
                .padding(.bottom, 5)
            }
        }
        .onAppear {
            viewModel.loadRestaurants()
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RestaurantListViewModel()
        return RestaurantListView(viewModel: viewModel)
    }
}
