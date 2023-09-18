//
//  ListInsideScontrino.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 13/09/23.
//

import SwiftUI

struct ListInsideScontrino: View {
    
    @State private var isAddFoodViewPresented = false
    @StateObject private var keyboardHandling = KeyboardHandling()
    @EnvironmentObject var foodData: FoodData
    
    var foodItems: [MyFoodItem] {
        foodData.foodItems
    }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(foodData.foodItems) { foodItem in
                    FoodItemRow(foodItem: foodItem)
                        .listRowSeparator(.hidden)
                }
                .onDelete(perform: deleteFoodItem)
            }
            .listStyle(PlainListStyle()) // Rimuovi lo stile predefinito
            .background(Color.clear)
        }
    }
    
    private func deleteFoodItem(at offsets: IndexSet) {
        foodData.foodItems.remove(atOffsets: offsets)
    }
    
}
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

struct ListInsideScontrino_Previews: PreviewProvider {
    static var previews: some View {
        ListInsideScontrino()
    }
}
