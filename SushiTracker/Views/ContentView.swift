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
    @EnvironmentObject var keyboardHandling: KeyboardHandling
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RestaurantItem.name, ascending: true)],
        animation: .default)
    private var restaurants: FetchedResults<RestaurantItem>
    @State private var showingRestaurantPopup = false
    @State private var searchText = ""
    @State private var open = false
    @State private var isOnboardingCompleted = false
    
    init() {
        if let greenColor = UIColor(named: "Green"),
        let searchBar = UIColor(named: "SearchBar"){
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: greenColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Annulla"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = searchBar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
        }
    }
    
    var body: some View {
        NavigationStack {
            if !isOnboardingCompleted {
                    OnBoardingScreen(isOnboardingCompleted: $isOnboardingCompleted)
                }  else {
                VStack {
                    if restaurants.isEmpty {
                        Text("Clicca l'icona in basso per aggiungere il tuo ristorante preferito ed iniziare ad inserire i tuoi ordini! 🥢")
                            .foregroundColor(Color("Green"))
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding([.leading, .trailing], 20)
                    } else {
                        // MARK: PIETRO - Usa .searchable(text: $searchText)
                        // SearchBar(text: $searchText)
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
                            } else if filteredRestaurants.isEmpty {
                                Text("Nessun ristorante trovato")
                                    .foregroundColor(Color.black.opacity(0.5))
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding([.leading, .trailing], 20)
                            }
                        }
                    }
                    
                    Button(action: {
                        withAnimation {
                            showingRestaurantPopup.toggle()
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Green"))
                            .mask(Circle())
                            .shadow(radius: 5)
                            .zIndex(10)
                    }
                    .fullScreenCover(isPresented: $showingRestaurantPopup) {
                        let restaurantModel = RestaurantModel()
                        RestaurantPopupView(model: restaurantModel, isPresented: $showingRestaurantPopup).environment(\.managedObjectContext, viewContext)
                    }
                }
                .scrollIndicators(.visible)
                .scrollContentBackground(.hidden)
                .navigationTitle("I Tuoi Ristoranti")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchText, prompt: "Cerca")
                .background(Color.accentColor)
            }
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
