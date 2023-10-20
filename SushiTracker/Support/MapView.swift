//
//  MapKit.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 10/09/23.
//

import SwiftUI
import MapKit
import CoreLocation

class MapRegionManager: ObservableObject {
    @Published var region: MKCoordinateRegion?
}

struct MapView: View {
    let address: String
    @ObservedObject var regionManager: MapRegionManager

    var body: some View {
        MapContainerView(address: address, regionManager: regionManager)
    }
}

struct MapContainerView: UIViewRepresentable {
    let address: String
    @ObservedObject var regionManager: MapRegionManager

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Errore nella geocodifica: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first, let location = placemark.location?.coordinate {
                print("Coordinate ottenute: \(location.latitude), \(location.longitude)")
                let newRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                mapView.setRegion(newRegion, animated: true)

                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                mapView.addAnnotation(annotation)
                
                // Aggiorna la regione con i nuovi valori
                regionManager.region = newRegion
            } else {
                print("Nessuna coordinata ottenuta dalla geocodifica.")
            }
        }

        return mapView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Puoi gestire eventuali aggiornamenti qui
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapContainerView

        init(_ parent: MapContainerView) {
            self.parent = parent
        }
    }
}
