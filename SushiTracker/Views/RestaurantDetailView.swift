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
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var restaurantName = ""
    @State private var restaurantAddress = ""
    @State private var restaurantLocation = CLLocationCoordinate2D()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    init(viewModel: RestaurantDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack {
            Spacer(minLength: 30)
            CustomDraggableView(dragOffset: $dragOffset, isDragging: $isDragging) {
                VStack {
                    
                    Text(viewModel.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .minimumScaleFactor(0.8)
                    
                    Text(viewModel.address)
                        .font(.body)
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity)
                        .minimumScaleFactor(0.8)
                    
                    HStack {
                        Text("\(viewModel.rating)/5")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.black)
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                    }
                }
                VStack {
                    Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: [Annotation(coordinate: viewModel.restaurantCoordinate ?? CLLocationCoordinate2D(), title: viewModel.name)]) { annotation in
                        MapMarker(coordinate: annotation.coordinate, tint: .red)
                    
                    }
                    .onAppear {
                        geocodeAddress()
                    }
                    .onTapGesture {
                        openMapsApp(coordinate: viewModel.restaurantCoordinate ?? CLLocationCoordinate2D(), name: viewModel.name)
                    }
                    .frame(width: 330,height: 150)
                    .padding(20)
                    .background(Color.clear)
                    .shadow(radius: 5)
                    
                    ScontrinoView()
                        .frame(width: 350, height: 400)
                }
                HStack {
                    Spacer()
                    FloatingButtonView()
                }
                .padding()
            }
        }
        .background(Color.yellow)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.width > 0 {
                        dragOffset = value.translation
                        isDragging = true
                    }
                }
                .onEnded { gesture in
                    if isDragging {
                        if gesture.translation.width > 100 {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            withAnimation {
                                dragOffset = .zero
                                isDragging = false
                            }
                        }
                    }
                }
        )
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
                // Aggiorna la regione della mappa con le nuove coordinate
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
        
        return NavigationView {
            RestaurantDetailView(viewModel: viewModel)
        }
    }
}
