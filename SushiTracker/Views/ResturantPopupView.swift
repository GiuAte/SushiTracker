//
//  ResturantPopupView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 07/09/23.
//

import SwiftUI
import CoreData
import MapKit

struct RestaurantPopupView: View {
    
    enum Field {
        case name, address, none
    }
    
    @EnvironmentObject var keyboardHandling: KeyboardHandling
    @ObservedObject var model: RestaurantModel
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedRating = 0
    @State private var showAlert = false
    @State private var restaurantName = ""
    @State private var restaurantAddress = ""
    @State private var restaurantLocation = CLLocationCoordinate2D()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var mapUpdateTimer: Timer?
    @FocusState private var focusField: Field?
    @FocusState private var isFocus: Bool
    
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
        VStack {
            VStack(alignment: .leading) {
                Text("Nome")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .bold()
                
                TextField("Nome del ristorante", text: $restaurantName)
                    .padding()
                    .background(Color(("DarkGray")))
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.next)
                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .focused($isFocus)
                    .shadow(radius: 10)
            }
            .padding()
            VStack(alignment: .leading) {
                Text("Indirizzo")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                
                TextField("Indirizzo del ristorante", text: $restaurantAddress)
                    .padding()
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .background(Color(.systemGray6))
                    .focused($focusField, equals: .address)
                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .submitLabel(.done)
                    .onChange(of: restaurantAddress) { newValue in
                        mapUpdateTimer?.invalidate()
                        mapUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            geocodeAddress()
                        }
                    }
                    .shadow(radius: 10)
            }
            .padding()
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: [Annotation(coordinate: restaurantLocation, title: restaurantName)]) { annotation in
                MapMarker(coordinate: annotation.coordinate, tint: .red)
                
            }
            .frame(height: 150)
            .cornerRadius(10)
            .padding(20)
            .background(Color.clear)
            .shadow(radius: 5)
            
            
            Picker("Valutazione", selection: $selectedRating) {
                ForEach(1..<6, id: \.self) { rating in
                    if selectedRating >= rating {
                        Image("star_filled")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    } else {
                        Image("star_empty")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button(action: {
                if restaurantName.isEmpty || restaurantAddress.isEmpty {
                    showAlert = true
                } else {
                    let rating = selectedRating
                    let newRestaurant = RestaurantItem(context: viewContext)
                    newRestaurant.name = restaurantName
                    newRestaurant.address = restaurantAddress
                    newRestaurant.rating = Int16(rating)
                    
                    do {
                        try viewContext.save()
                        isPresented = false
                    } catch {
                        print("Errore durante il salvataggio: \(error)")
                    }
                }
            }) {
                Text("Salva")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Blue"))
                    )
                
            }
            .padding()
            
            Button(action: {
                isPresented = false
            }) {
                Text("Annulla")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Pink"))
                    )
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Errore"), message: Text("Inserisci entrambi i campi, quindi riprova"), dismissButton: .default(Text("OK")))
        }
        .onDisappear {
            restaurantName = ""
            restaurantAddress = ""
            selectedRating = 0
        }
    }
    }
    
    private func geocodeAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurantAddress) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location?.coordinate else {
                print("Errore durante la geocodifica: \(error?.localizedDescription ?? "Errore sconosciuto")")
                return
            }
            restaurantLocation = location
            region.center = location
            DispatchQueue.main.async {
                self.viewContext.refreshAllObjects()
            }
        }
    }
}

struct RestaurantPopupView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantPopupView(model: RestaurantModel(), isPresented: .constant(true))
    }
}

struct Annotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}
