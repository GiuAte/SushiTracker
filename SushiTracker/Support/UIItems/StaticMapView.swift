//
//  StaticMapView.swift
//  SushiMe
//
//  Created by Giulio Aterno on 20/10/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct StaticMapView: View {
    let address: String
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var placemark: MKPlacemark?
    @State private var restaurantLocation = CLLocationCoordinate2D()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var restaurantName = ""
    @State private var restaurantAddress = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var annotations: [MKPointAnnotation] = []

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [Annotation(coordinate: restaurantLocation, title: restaurantName)]) { annotation in
            MapMarker(coordinate: annotation.coordinate, tint: .red)
        }
        .onTapGesture {
            openMapsAppWithDestination()
        }
        .onAppear {
            geocodeAddress()
        }
        .overlay(
            GeometryReader { geometry in
                Path { path in
                    if let userLocation = coordinate {
                        let userPoint = MKMapPoint(userLocation)
                        let placemarkPoint = MKMapPoint(restaurantLocation)
                        let startPoint = CGPoint(x: userPoint.x, y: userPoint.y)
                        let endPoint = CGPoint(x: placemarkPoint.x, y: placemarkPoint.y)

                        path.move(to: startPoint)
                        path.addLine(to: endPoint)
                    }
                }
                .stroke(Color.blue, lineWidth: 2.0)
            }
        )
        .frame(width: 330, height: 150)
        .cornerRadius(10)
        .padding(20)
        .background(Color.clear)
        .shadow(radius: 5)
        .onTapGesture {
            // Add custom tap gesture behavior here
        }
    }
    
    private func openMapsAppWithDestination() {
          let coordinates = "\(restaurantLocation.latitude),\(restaurantLocation.longitude)"
          let address = restaurantAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""

          if let url = URL(string: "http://maps.apple.com/?daddr=\(address)&saddr=\(coordinates)") {
              if UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
              } else {
                  // Gestisci il caso in cui l'app di Mappe non è disponibile
                  print("L'app di Mappe non è disponibile.")
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
