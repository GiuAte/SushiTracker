//
//  DrinkItemRow.swift
//  SushiMe
//
//  Created by Giulio Aterno on 19/10/23.
//

import Foundation
import SwiftUI

struct DrinkItemRow: View {
    var drinkItem: MyFoodItem

    var body: some View {
        HStack {
            Text(drinkItem.name!)
                .truncationMode(.tail)
                .minimumScaleFactor(0.3)
                .lineLimit(2)
            Spacer()
            Text("Porzioni:")
            Text("\(drinkItem.portionCount)")
        }
    }
}
