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
        if foodItems.isEmpty {
            VStack {
                Text("Il riepilogo del tuo ordine apparirà qui una volta aggiunte le varie pietanze.")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                Button(action: {
                    isAddFoodViewPresented.toggle()
                }) {
                    Text("Clicca il bottone in basso a destra ed inizia ad aggiungere il cibo!")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        } else {
            List {
                ForEach(foodData.foodItems) { foodItem in
                    FoodItemRow(foodItem: foodItem)
                        .listRowSeparator(.hidden)
                }
                .onDelete(perform: deleteFoodItem)
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
        }
        Color.gray.opacity(0.050)
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

#Preview {
    ListInsideScontrino()
}
