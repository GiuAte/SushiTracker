//
//  ListInsideScontrino.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 13/09/23.
//

import SwiftUI

struct ListInsideScontrino: View {
    var body: some View {
        VStack {
                    Divider() // Linea divisoria

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Sashimi")
                            Spacer()
                            Text("Porzioni:")
                            Text("7")
                        }
                        HStack {
                            Text("Hosomaki Tonno")
                            Spacer()
                            Text("Porzioni:")
                            Text("3")
                        }
                    }
                    .padding(.horizontal)
                    Spacer() // Spazio vuoto alla fine
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
}


struct ListInsideScontrino_Previews: PreviewProvider {
    static var previews: some View {
        ListInsideScontrino()
    }
}
