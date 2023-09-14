//
//  ContentView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 07/09/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RestaurantItem.name, ascending: true)],
        animation: .default)
    private var restaurants: FetchedResults<RestaurantItem>
    @State private var isSearchBarVisible = false
    @State private var lastOffset: CGFloat = 0.0
    @State private var showingRestaurantPopup = false
    @State private var searchText = ""
    @State private var open = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Home")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color.black)
                }
                
                if restaurants.isEmpty {
                    Text("Clicca l'icona in basso per aggiungere il tuo ristorante preferito ed iniziare ad inserire i tuoi ordini! 🥢")
                        .foregroundColor(Color.black.opacity(0.5))
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding([.leading, .trailing], 20)
                } else {
                    SearchBar(text: $searchText)
                    ZStack {
                        if !filteredRestaurants.isEmpty {
                            List {
                                ForEach(filteredRestaurants, id: \.self) { restaurant in
                                    NavigationLink(destination: RestaurantDetailView(viewModel: RestaurantDetailViewModel(restaurant: restaurant))) {
                                        RestaurantRowView(restaurant: restaurant)
                                    }
                                }
                                .onDelete(perform: deleteRestaurant)
                            }
                            .background(Color.yellow)
                        } else if filteredRestaurants.isEmpty {
                            Text("Nessun ristorante trovato")
                                .foregroundColor(Color.black.opacity(0.5))
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding([.leading, .trailing], 20)
                        } else {
                            Color.yellow
                            
                        }
                    }
                }
                
                Button(action: {
                    withAnimation {
                        showingRestaurantPopup.toggle()
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.pink)
                        .mask(Circle())
                        .shadow(radius: 5)
                        .zIndex(10)
                }
                .fullScreenCover(isPresented: $showingRestaurantPopup) {
                    let restaurantModel = RestaurantModel()
                    RestaurantPopupView(model: restaurantModel, isPresented: $showingRestaurantPopup).environment(\.managedObjectContext, viewContext)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.yellow)
        }
    }
    
    private func deleteRestaurant(at offsets: IndexSet) {
        for offset in offsets {
            let restaurant = restaurants[offset]
            viewContext.delete(restaurant)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    private var filteredRestaurants: [RestaurantItem] {
        if searchText.isEmpty {
            return restaurants.map { $0 }
        } else {
            return restaurants.filter { restaurant in
                restaurant.name!.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func shouldShowSearchBarOnScroll(offset: CGFloat) -> Bool {
        let scrollThreshold: CGFloat = 20.0
        if offset > scrollThreshold {
            return true
        } else {
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        let contentView = ContentView().environment(\.managedObjectContext, context)
        return contentView
    }
}
