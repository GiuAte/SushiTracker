//
//  SplashScreen.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 06/10/23.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Text("SushiMe!")
                    .font(.title)
                    .foregroundStyle(.bar)
                    .bold()
                    .padding()
            }
        }
    }
}
#Preview {
    SplashScreenView()
}
