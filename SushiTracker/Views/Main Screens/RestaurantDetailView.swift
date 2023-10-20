//
//  RestaurantDetailView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 07/09/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct RestaurantDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: RestaurantDetailViewModel
    @State private var region: MKCoordinateRegion?
    
    init(viewModel: RestaurantDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundColor(Color("Green"))
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.8)
                
                Text(viewModel.address)
                    .font(.body)
                    .fontWeight(.light)
                    .fontDesign(.rounded)
                    .foregroundColor(Color("WhiteOrBlack"))
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.8)
                
                HStack {
                    Text("\(viewModel.rating)/5")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color("WhiteOrBlack"))
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 15))
                }
                
                StaticMapView(address: viewModel.address)
                
                TestView()
                    .frame(width: 350, height: 400)
                
                HStack {
                    QRCodeButton()
                        .padding(.bottom, 45)
                    Spacer()
                    FloatingButtonView()
                        .padding(.bottom, 45)
                }
                .padding()
            }
            .padding(30)
            .background(Color.accentColor)
        }
        .toolbarRole(.automatic)
    }
}



struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.preview.viewContext
        let restaurant = RestaurantItem(context: context)
        restaurant.name = "Nome del Ristorante"
        restaurant.address = "Indirizzo del Ristorante"
        restaurant.rating = 4
        
        let viewModel = RestaurantDetailViewModel(restaurant: restaurant)
        let foodData = FoodData(managedObjectContext: PersistenceController.shared.container.viewContext)
        
        return NavigationView {
            RestaurantDetailView(viewModel: viewModel)
                .environmentObject(foodData)
        }
    }
}
