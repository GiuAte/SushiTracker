//
//  GradiendBackgroundView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 28/09/23.
//

import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        Color(hex: 0x1f2123)
            .ignoresSafeArea()
    }
}

extension Color {
    init(hex: UInt32) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0x00ff00) >> 8) / 255.0
        let blue = Double(hex & 0x0000ff) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
    
    struct GradientBackgroundView_Previews: PreviewProvider {
        static var previews: some View {
            GradientBackgroundView()
        }
    }

