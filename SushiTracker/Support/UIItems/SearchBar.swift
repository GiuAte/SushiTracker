//
//  SearchBar.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 08/09/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                TextField("Cerca un ristorante", text: $text)
                    .padding(.vertical, 8)
                    .padding(.leading, 50)
                    .background(Color(.white))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 30)
           
                Button(action: {
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.leading, 350)
                }
            }
        }
    }
}
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
