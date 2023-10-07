//
//  AddFoodView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 18/09/23.
//

import SwiftUI
import CoreData

struct AddFoodView: View {
    
    @Binding var isPresented: Bool
    @State private var foodName = ""
    @State private var foodNumber = ""
    @State private var portionCount = ""
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var foodData: FoodData

    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Aggiungi cibo")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                HStack {
                    CustomTextField(placeholder: "Nome", text: $foodName, returnKeyType: .next, tag: 1)
                        .keyboardType(.default)

                    CustomTextField(placeholder: "Numero", text: $foodNumber, returnKeyType: .next, tag: 2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.horizontal, .bottom])
                        .keyboardType(.numberPad)

                    CustomTextField(placeholder: "Porzioni", text: $portionCount, returnKeyType: .done, tag: 3)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.horizontal, .bottom])
                        .keyboardType(.decimalPad)
                }

                Button(action: {
                    if let portionCount = Int(portionCount) {
                        let newFoodItem = MyFoodItem(context: managedObjectContext)
                        newFoodItem.name = foodName
                        newFoodItem.orderNumber = foodNumber
                        newFoodItem.portionCount = Int16(portionCount)

                        foodData.addFoodItem(newFoodItem)

                        isPresented = false
                    }
                }) {
                    Text("Aggiungi")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
    }
}
