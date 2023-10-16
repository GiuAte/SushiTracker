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
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
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
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.8)
                
                HStack {
                    Text("\(viewModel.rating)/5")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.black)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 15))
                }
                
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: [Annotation(coordinate: viewModel.restaurantCoordinate ?? CLLocationCoordinate2D(), title: viewModel.name)]) { annotation in
                    MapMarker(coordinate: annotation.coordinate, tint: .red)
                }
                .onAppear {
                    geocodeAddress()
                }
                .onTapGesture {
                    openMapsApp(coordinate: viewModel.restaurantCoordinate ?? CLLocationCoordinate2D(), name: viewModel.name)
                }
                .cornerRadius(10)
                .frame(width: 330, height: 150)
                .padding(20)
                .background(Color.clear)
                .shadow(radius: 5)
                
                ScontrinoView()
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
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbarRole(.automatic)
    }
    
    private func geocodeAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(viewModel.address) { placemarks, error in
            if let error = error {
                print("Errore nella geocodifica: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location?.coordinate {
                print("Coordinate ottenute: \(location.latitude), \(location.longitude)")
                region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            } else {
                print("Nessuna coordinata ottenuta dalla geocodifica.")
            }
        }
    }
    
    private func openMapsApp(coordinate: CLLocationCoordinate2D, name: String) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = name
        if let appleMapsURL = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") {
            if UIApplication.shared.canOpenURL(appleMapsURL) {
                UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
                return
            }
        }
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
