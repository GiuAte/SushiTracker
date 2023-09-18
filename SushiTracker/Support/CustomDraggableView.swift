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
        content
            .offset(x: dragOffset.width)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > 0 {
                            dragOffset = value.translation
                            isDragging = true
                        }
                    }
                    .onEnded { gesture in
                        if isDragging {
                            if gesture.translation.width > 50 {
                                // Chiudi la vista
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
            .onTapGesture {
                if !isDragging {
                    withAnimation {
                        dragOffset = .zero
                    }
                }
            }
    }
}
