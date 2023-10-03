//
//  AddDrinkView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 18/09/23.
//

import SwiftUI

struct AddDrinksView: View {
    @Binding var isPresented: Bool
    @State private var drinkName = ""
    @State private var drinkPortions = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var value: CGFloat = 0
    @EnvironmentObject var keyboardHandling: KeyboardHandling
    
    
    var body: some View {
        ZStack {
            (Color("backgroundColor"))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Aggiungi bevande")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                HStack {
                    // MARK: PIETRO - Usa il CustomTextFieldModifier
                    CustomTextField(placeholder: "Nome", text: $drinkName, returnKeyType: .next, tag: 1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.horizontal, .bottom])
                        .keyboardType(.default)
                    
                    CustomTextField(placeholder: "Quantità", text: $drinkPortions, returnKeyType: .next, tag: 2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.horizontal, .bottom])
                        .keyboardType(.numberPad)
                }
                
                Button(action: {
                    // Azione da eseguire quando viene premuto il bottone
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
