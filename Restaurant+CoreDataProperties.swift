//
//  Restaurant+CoreDataProperties.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var rating: Int64

}

extension Restaurant : Identifiable {

}
