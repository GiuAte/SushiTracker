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
    
    @EnvironmentObject var keyboardHandling: KeyboardHandling
    @Environment(\.colorScheme) var colorScheme
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
    @FocusState private var isFocus: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Dati del ristorante")
                        .font(.largeTitle)
                        .bold()
                        .fontDesign(.serif)
                        .foregroundStyle(Color("Green"))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Nome")
                        .font(.headline)
                        .foregroundStyle(Color("Green"))
                    
                    TextField("Nome del ristorante", text: $restaurantName)
                        .customStyle()
                        .focused($isFocus)
                        .onTapGesture {
                            isFocus = true
                        }
                    
                    Text("Indirizzo")
                        .font(.headline)
                        .foregroundStyle(Color("Green"))
                    
                    TextField("Indirizzo del ristorante", text: $restaurantAddress)
                        .customStyle()
                        .keyboardType(.default)
                        .onSubmit {
                            hideKeyboard()
                        }
                        .onChange(of: restaurantAddress) { newValue in
                            mapUpdateTimer?.invalidate()
                            mapUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                geocodeAddress()
                            }
                        }
                    
                    Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: [Annotation(coordinate: restaurantLocation, title: restaurantName)]) { annotation in
                        MapMarker(coordinate: annotation.coordinate, tint: .red)
                    }
                    .frame(height: 150)
                    .cornerRadius(10)
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
                    
                    Spacer()
                    
                    Button(action: {
                        saveRestaurant()
                    }) {
                        Text("Salva")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .fill(Color("Green"))
                            }
                    }
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Annulla")
                            .font(.headline)
                            .foregroundColor(Color("WhiteOrBlack"))
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Errore"), message: Text("Inserisci entrambi i campi, quindi riprova"), dismissButton: .default(Text("OK")))
                }
                .onDisappear {
                    resetFields()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.accentColor)
    }
    
    private func saveRestaurant() {
        guard !restaurantName.isEmpty, !restaurantAddress.isEmpty else {
            showAlert = true
            return
        }
        
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
    
    private func resetFields() {
        restaurantName = ""
        restaurantAddress = ""
        selectedRating = 0
    }
    
    private func hideKeyboard() {
        keyboardHandling.dismissKeyboard()
    }
}

struct RestaurantPopupView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantPopupView(model: RestaurantModel(), isPresented: .constant(true))
    }
}

extension TextField {
    func customStyle() -> some View {
        self
            .padding()
            .background(Color("SearchBar"))
            .disableAutocorrection(true)
            .textInputAutocapitalization(.words)
            .submitLabel(.next)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
    }
}
