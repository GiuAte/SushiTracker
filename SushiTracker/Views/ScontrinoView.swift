//
//  ScontrinoView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 13/09/23.
//

import SwiftUI

struct ScontrinoView: View {
    var body: some View {
        VStack {
            ZStack {
                ListInsideScontrino()
                    .padding()
                    .shadow(radius: 5)
                    .mask(
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            
                            for i in 0..<Int(UIScreen.main.bounds.height / 20) {
                                let x = CGFloat(i) * 20
                                path.addLine(to: CGPoint(x: x + 10, y: 30))
                                path.addLine(to: CGPoint(x: x + 20, y: 20))
                            }
                            
                            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
                            path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
                        }
                            .scaleEffect(CGSize(width: 1.0, height: -1.0))
                    )
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea()
        
    }
    
    struct ScontrinoView_Preview: PreviewProvider {
        static var previews: some View {
            ScontrinoView()
        }
    }
}
