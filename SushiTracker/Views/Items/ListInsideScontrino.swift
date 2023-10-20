//
//  ListInsideScontrino.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 13/09/23.
//

import SwiftUI

struct ListInsideScontrino: View {
    
    @State private var isAddFoodViewPresented = false
    @State private var isEditing = false
    
    @EnvironmentObject var foodData: FoodData
    
    var foodItems: [MyFoodItem] {
        foodData.foodItems
    }
    
    var body: some View {
        if foodItems.isEmpty {
            VStack {
                Text("Il riepilogo del tuo ordine apparirà qui una volta aggiunte le varie pietanze.")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Clicca il bottone in basso a destra ed inizia ad aggiungere il cibo!")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .padding()
            
        } else {
            List {
                ForEach(foodData.foodItems, id: \.id) { foodItem in
                    FoodItemRow(foodItem: foodItem)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = foodData.foodItems.firstIndex(of: foodItem) {
                                    deleteFoodItem(at: IndexSet([index]))
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)

        }
    }
        
        func deleteFoodItem(at offsets: IndexSet) {
            foodData.foodItems.remove(atOffsets: offsets)
        }
    }
    
    struct TestView: View {
        var body: some View {
            ZStack {
                // first the scontrino
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
                .fill(Color.gray.opacity(0.2))
                .scaleEffect(CGSize(width: 1.0, height: -1.0))
                .shadow(radius: 5)
                .cornerRadius(15)
                .ignoresSafeArea()
                
                // then the list
                ListInsideScontrino()
            }
            .padding()
        }
    }
    
    #Preview {
        ListInsideScontrino()
    }

