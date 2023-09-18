//
//  AddFoodView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 18/09/23.
//

import Foundation
import SwiftUI

struct AddFoodView: View {
    @Binding var isPresented: Bool
    @State private var foodName = ""
    @State private var foodNumber = ""
    @State private var foodPortions = ""
    @EnvironmentObject var keyboardHandling: KeyboardHandling

    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Aggiungi cibo")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                HStack {
                    CustomTextField(placeholder: "Nome", text: $foodName, returnKeyType: .next, tag: 1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .bottom])
                    .keyboardType(.default)

                    CustomTextField(placeholder: "Numero", text: $foodNumber, returnKeyType: .next, tag: 2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .bottom])
                    .keyboardType(.numberPad)

                    CustomTextField(placeholder: "Porzioni", text: $foodPortions, returnKeyType: .done, tag: 3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .bottom])
                    .keyboardType(.decimalPad)
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
