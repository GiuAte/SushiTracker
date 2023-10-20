//
//  FloatingButtonView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 14/09/23.
//

import Foundation
import SwiftUI
import AVFoundation

struct FloatingButtonView: View {
    @State private var open = false
    @State private var showAddFoodSheet = false
    @State private var showAddDrinksSheet = false
    
    @EnvironmentObject private var soundManager: SoundManager
    
    var body: some View {
        HStack {
            ZStack {
                Button(action: { self.open.toggle()
                    SoundManager.shared.playSound(named: "buttonpressed")
                }) {
                    Image(systemName: "plus")
                        .rotationEffect(.degrees(open ? 45: 0))
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                        .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0))
                }
                .padding()
                .background(Color("Green"))
                .mask(Circle())
                .shadow(color: Color.pink, radius: 10)
                .zIndex(10)
                
                SecondaryButton(open: $open, icon: "fork.knife", color: "Orange", offsetY: -90) {
                    showAddFoodSheet = true
                    
                }
                .sheet(isPresented: $showAddFoodSheet) {
                    AddFoodView()
                        .presentationDetents([.height(200)])
                }
                
                SecondaryButton(open: $open, icon: "wineglass", color: "Blue", offsetX: -80, offsetY: -30, delay: 0.2) {
                    showAddDrinksSheet = true
                }
                .sheet(isPresented: $showAddDrinksSheet) {
                    AddDrinkView()
                        .presentationDetents([.height(200)])
                        
                }
            }
        }
    }
}

struct FloatingButtonView_Preview: PreviewProvider {
    static var previews: some View {
        FloatingButtonView()
    }
}

struct SecondaryButton: View {
    @Binding var open: Bool
    var icon = "pencil"
    var color = "Blue"
    var offsetX = 0
    var offsetY = 0
    var delay = 0.0
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
        }
        .padding()
        .background(Color(color))
        .mask(Circle())
        .offset(x: open ? CGFloat(offsetX) : 0, y: open ? CGFloat(offsetY) : 0)
        .scaleEffect(open ? 1: 0)
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(Double(delay)))
    }
}






