//
//  AddFoodView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 18/09/23.
//

import Foundation
import SwiftUI
import CoreData


struct AddFoodView: View {
    @Binding var isPresented: Bool
    @State private var foodName = ""
    @State private var foodNumber = ""
    @State private var portionCount = ""
    @EnvironmentObject var keyboardHandling: KeyboardHandling
    @EnvironmentObject var foodData: FoodData
    
    var body: some View {
        ZStack {
            (Color("backgroundColor"))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Aggiungi cibo")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                HStack {
                    // MARK: PIETRO - Crea un modifier piuttosto che ripetere sempre. Magari gli passi anche un valore dinamico per la keyboardType -->
                    /*
                     struct CustomTextFieldModifier: ViewModifier {
                         func body(content: Content) -> some View {
                             content
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding([.horizontal, .bottom])
                         }
                     }
                    */
                    
                    CustomTextField(placeholder: "Nome", text: $foodName, returnKeyType: .next, tag: 1)
                        // MARK: PIETRO - usalo così .modifier(CustomTextFieldModifier())
                        // .textFieldStyle(RoundedBorderTextFieldStyle())
                        // .padding([.horizontal, .bottom])
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
                    // Aggiungi un nuovo FoodItem all'array tramite l'oggetto foodData
                    if let portionCount = Int(portionCount) {
                        let newFoodItem = MyFoodItem(context: foodData.managedObjectContext)
                        newFoodItem.name = foodName
                        newFoodItem.orderNumber = foodNumber
                        newFoodItem.portionCount = Int16(portionCount) // Gestione degli errori

                        // Aggiungi il nuovo oggetto a foodData
                        foodData.addFoodItem(newFoodItem)

                        // Chiudi la vista
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
        .presentationDragIndicator(.visible)
    }
}
