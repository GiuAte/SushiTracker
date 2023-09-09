//
//  BubblesBackground.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 08/09/23.
//

import SwiftUI

struct BubblesBackground: View {
    @State private var bubbles: [Bubble] = []
    
    let bubbleCount = 3 // Numero di bolle
    let bubbleRadiusRange = CGFloat(500.0)...CGFloat(1000.0) // Intervallo di dimensioni delle bolle
    let animationDurationRange = 4.0...10.0 // Intervallo di durata dell'animazione
    
    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            
            ForEach(bubbles) { bubble in
                Circle()
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .blur(radius: 5)
                    .frame(width: bubble.radius, height: bubble.radius)
                    .offset(y: bubble.positionY)
                    .animation(
                        Animation.linear(duration: bubble.animationDuration)
                            .repeatForever(autoreverses: false)
                    )
            }
        }
        .onAppear {
            // Inizializza le bolle con posizioni e dimensioni casuali
            bubbles = (0..<bubbleCount).map { _ in
                Bubble(
                    radius: CGFloat.random(in: bubbleRadiusRange),
                    positionY: CGFloat.random(in: -100...UIScreen.main.bounds.height),
                    animationDuration: TimeInterval.random(in: animationDurationRange)
                )
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    let radius: CGFloat
    let positionY: CGFloat
    let animationDuration: TimeInterval
}

struct BubblesBackground_Previews: PreviewProvider {
    static var previews: some View {
        BubblesBackground()
    }
}

