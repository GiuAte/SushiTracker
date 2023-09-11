//
//  MapKit.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 10/09/23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @Binding var coordinate: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = coordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(annotation)
            uiView.setCenter(coordinate, animated: true)
        }
    }
}
