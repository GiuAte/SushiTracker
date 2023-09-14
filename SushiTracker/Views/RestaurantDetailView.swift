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
    
    private var restaurantCoordinate: CLLocationCoordinate2D? {
        viewModel.restaurantCoordinate
    }
    
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
                    Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: [Annotation(coordinate: restaurantLocation, title: restaurantName)]) { annotation in
                        MapMarker(coordinate: annotation.coordinate, tint: .red)
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
