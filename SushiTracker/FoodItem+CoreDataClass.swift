//
//  FoodItem+CoreDataClass.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 18/09/23.
//
//

import Foundation
import CoreData

@objc(MyFoodItem)
class FoodItem: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var orderNumber: String?
    @NSManaged var portionCount: Int16
}

