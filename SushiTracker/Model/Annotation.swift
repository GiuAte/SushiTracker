//
//  Annotation.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 03/10/23.
//

import Foundation
import MapKit

struct Annotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}
