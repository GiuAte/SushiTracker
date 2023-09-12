//
//  MapKit.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 10/09/23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion?
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        
        if let coordinate = coordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            if let region = region {
                uiView.setRegion(region, animated: true)
            } else {
                let defaultRegion = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
                uiView.setRegion(defaultRegion, animated: true)
            }
            
            uiView.addAnnotation(annotation)
            uiView.setCenter(coordinate, animated: true)
        }
    }
}
