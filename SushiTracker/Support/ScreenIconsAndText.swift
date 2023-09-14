//
//  FloatingButton.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 14/09/23.
//

import SwiftUI
import FloatingButton

struct ScreenIconsAndText: View {
    
    @State var isOpen = false
    
    var body: some View {
        let mainButton1 = MainButton(imageName: "star.fill", colorHex: "f7b731", width: 60)
        //let mainButton2 = MainButton(imageName: "heart.fill", colorHex: "eb3b5a", width: 60)
        //let textButtons = MockData.iconAndTextTitles.enumerated().map { index, value in
        //IconAndTextButton(imageName: MockData.iconAndTextImageNames[index], buttonText: value)
            .onTapGesture { isOpen.toggle() }
        
        let menu1 = FloatingButton(mainButtonView: mainButton1, buttons: textButtons, isOpen: $isOpen)
            .straight()
            .direction(.top)
            .alignment(.left)
            .spacing(10)
            .initialOffset(x: -1000)
            .animation(.spring())
        
        let menu2 = FloatingButton(mainButtonView: mainButton2, buttons: textButtons)
            .straight()
            .direction(.top)
            .alignment(.right)
            .spacing(10)
            .initialOpacity(0)
        
        return NavigationView {
            VStack {
                HStack {
                    menu1
                    Spacer()
                    menu2
                }
            }
            .padding(20)
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: ScreenStraight()) {
                        Image(systemName: "arrow.right.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 10)
                    }
                    .isDetailLink(false)
            )
        }
    }
}
