//
//  File.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 13/09/23.
//

import SwiftUI

struct DynamicWidthButtonView: View {
    @State private var buttonText = "Pulsante Corto"

    var body: some View {
        VStack {
            GeometryReader { geometry in
                Button(action: {
                    // Azione da eseguire quando il pulsante viene premuto
                }) {
                    Text(buttonText)
                        .padding()
                        .frame(width: geometry.size.width - 20, height: 50) // Imposta un'area di contenuto fissa con margine
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(25)
                }
            }
            .frame(height: 530) // Imposta l'altezza massima del pulsante

            Button(action: {
                // Azione per modificare il testo del pulsante
                buttonText = "Questo è un pulsante più lungo"
            }) {
                Text("Cambia Testo")
            }
        }
        .padding()
    }
}

struct DynamicWidthButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicWidthButtonView()
    }
}
