//
//  RoundedRectangleButton.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 28/09/23.
//

import SwiftUI

struct RoundedRectangleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("test")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(("Pink")))
                )
        }
    }
}

struct RoundedRectangleButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangleButton() {
        
        }
    }
}

