//
//  FloatingButtonView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 14/09/23.
//

import Foundation
import SwiftUI

struct FloatingButtonView: View {
    @State private var open = false
    @State private var showAddFoodSheet = false // Variabile di stato per mostrare/nascondere il modulo
    
    var body: some View {
        HStack {
            ZStack {
                Button(action: { self.open.toggle() }) {
                    Image(systemName: "plus")
                        .rotationEffect(.degrees(open ? 45: 0))
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                        .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0))
                }
                .padding()
                .background(Color.pink)
                .mask(Circle())
                .shadow(color: Color.pink, radius: 10)
                .zIndex(10)
                
                // Usa SecondaryButton per il pulsante "fork.knife"
                SecondaryButton(open: $open, icon: "fork.knife", color: "Orange", offsetY: -90) {
                    // Quando il pulsante "fork.knife" viene premuto, mostra il modulo "Aggiungi cibo"
                    showAddFoodSheet = true
                }
                
                SecondaryButton(open: $open, icon: "wineglass", color: "Blue", offsetX: -60, offsetY: -60, delay: 0.2) {
                    // Quando il pulsante "fork.knife" viene premuto, mostra il modulo "Aggiungi cibo"
                    showAddFoodSheet = true
                }
                
                SecondaryButton(open: $open, icon: "pencil", color: "Green", offsetX: -90, delay: 0.4) {
                    // Quando il pulsante "fork.knife" viene premuto, mostra il modulo "Aggiungi cibo"
                    showAddFoodSheet = true
                }
                
            }
        }
        // Utilizza il modificatore .sheet per mostrare il modulo "Aggiungi cibo" quando showAddFoodSheet è true
        .sheet(isPresented: $showAddFoodSheet) {
            // Questo è il modulo "Aggiungi cibo"
            AddFoodView(isPresented: $showAddFoodSheet)
                .presentationDetents([.height(200)])
            
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

struct AddFoodView: View {
    @Binding var isPresented: Bool
    @State private var foodName = ""
    @State private var foodNumber = ""
    @State private var foodPortions = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var value: CGFloat = 0
    
    
    var body: some View {
        ZStack {
            ZStack {
                Color.yellow
                VStack {
                    Text("Aggiungi cibo")
                        .bold()
                        .font(.title)
                        .padding(.top, -80)
                }
                HStack {
                    TextField("Nome", text: $foodName)
                        .padding(.vertical, 8)
                        .padding(.leading, 10)
                        .background(Color(.white))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    TextField("Numero", text: $foodNumber)
                        .padding(.vertical, 8)
                        .padding(.leading, 10)
                        .background(Color(.white))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    TextField("Porzioni", text: $foodPortions)
                        .padding(.vertical, 8)
                        .padding(.leading, 10)
                        .background(Color(.white))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .ignoresSafeArea()
                .presentationDragIndicator(.visible)
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {
                    (noti) in
                    
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    
                    self.value = height
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    
                    self.value = 0
                }
            }
        }
    }
}






