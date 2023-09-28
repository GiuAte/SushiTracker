//
//  CustomDrag.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 13/09/23.
//

import SwiftUI

struct CustomDraggableView<Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var dragOffset: CGSize
    @Binding var isDragging: Bool
    let content: Content
    
    init(dragOffset: Binding<CGSize>, isDragging: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._dragOffset = dragOffset
        self._isDragging = isDragging
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            if isDragging {
                Color("backgroundColor")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            dragOffset = .zero
                            isDragging = false
                        }
                    }
            }
            
            content
                .offset(x: dragOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let screenWidth = UIScreen.main.bounds.width
                            let gestureStartX = value.startLocation.x
                            
                            // Definisci una "zona attiva" a sinistra dello schermo
                            let activeZoneWidth = screenWidth / 4
                            
                            if gestureStartX < activeZoneWidth {
                                dragOffset = value.translation
                                isDragging = true
                            }
                        }
                        .onEnded { gesture in
                            if isDragging {
                                if gesture.translation.width > 100 {
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    withAnimation {
                                        dragOffset = .zero
                                        isDragging = false
                                    }
                                }
                            }
                        }
                )
        }
    }
}
