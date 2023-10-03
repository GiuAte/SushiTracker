//
//  FoodData.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 18/09/23.
//

import CoreData

class FoodData: ObservableObject {
    @Published var foodItems: [MyFoodItem] = []
    
    var managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func addFoodItem(_ foodItem: MyFoodItem) {
        foodItems.append(foodItem)
    }
}
