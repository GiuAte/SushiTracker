//
//  FoodItem.swift
//  SushiMe
//
//  Created by Giulio Aterno on 19/10/23.
//

import Foundation
import SwiftUI

struct FoodItemRow: View {
    var foodItem: MyFoodItem

    var body: some View {
        HStack {
            Text(foodItem.name!)
                .truncationMode(.tail)
                .minimumScaleFactor(0.3)
                .lineLimit(2)
            Spacer()
            Text(foodItem.orderNumber!)
                .bold()
            Spacer()
            Text("Porzioni:")
            Text("\(foodItem.portionCount)")
        }
    }
}
