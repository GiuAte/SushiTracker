//
//  AddDrinkView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 18/09/23.
//

import SwiftUI
import CoreData

struct AddDrinkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false
    @State private var drinkName = ""
    @State private var portionCount = ""
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var foodData: FoodData
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Aggiungi bevande")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("Green"))
                    .padding(.top, 20)
                
                HStack {
                    TextField("Nome", text: $drinkName)
                        .keyboardType(.default)
                        .padding([.horizontal, .bottom])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxHeight: 40)
                        .onSubmit {
                            navigateToNextTextField(tag: 1)
                        }
                    
                    TextField("Quantità", text: $portionCount)
                        .keyboardType(.numberPad)
                        .padding([.horizontal, .bottom])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxHeight: 40)
                        .onSubmit {
                            hideKeyboard()
                        }
                }
                
                Button(action: {
                    if let portionCount = Int(portionCount) {
                        let newFoodItem = MyFoodItem(context: managedObjectContext)
                        newFoodItem.name = drinkName
                        newFoodItem.portionCount = Int16(portionCount)
                        
                        foodData.addFoodItem(newFoodItem)
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Aggiungi")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color("Green"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    
                }
                .padding()
                
            }
        }
        
        .background(Color.accentColor)
        .ignoresSafeArea()
    }
    
    private func navigateToNextTextField(tag: Int) {
        if let nextField = UIApplication.shared.windows.first?.rootViewController?.view.viewWithTag(tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddFoodView()
}
