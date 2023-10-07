//
//  OnBoardingScreen.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 06/10/23.
//

import SwiftUI
import Lottie

struct OnBoardingScreen: View {
    // MARK: OnBoarding Slides Model Data
    @State private var showContentView = false
    @Binding var isOnboardingCompleted: Bool
    @State var onboardingItems: [OnboardingItem] = [
        .init(title: "Vai al ristorante",
              subTitle: "Vai nel tuo ristorante preferito, scansiona il codice QR del menù ed inizia a salvare i tuoi piatti preferiti!",
              lottieView: .init(name: "VaiAlRistorante",bundle: .main)),
        .init(title: "Rivedi l'ordine",
              subTitle: "Clicca sul ristorante in cui ti trovi per vedere il i tuoi cibi preferiti: così sarà più facile e veloce ordinare",
              lottieView: .init(name: "Rivedi",bundle: .main)),
        .init(title: "Goditi il tuo sushi",
              subTitle: "Quando avrai visto il tuo ordine e confermato al cameriere, goditi il tuo pasto!",
              lottieView: .init(name: "Enjoy",bundle: .main))
    ]
    // MARK: Current Slide Index
    @State var currentIndex: Int = 0
    var body: some View {
        GeometryReader{
            let size = $0.size
            HStack(spacing: 0){
                ForEach($onboardingItems) { $item in
                    let isLastSlide = (currentIndex == onboardingItems.count - 1)
                    VStack{
                        // MARK: Top Nav Bar
                        HStack{
                            Button("Indietro"){
                                if currentIndex > 0{
                                    currentIndex -= 1
                                    playAnimation()
                                }
                            }
                            .opacity(currentIndex > 0 ? 1 : 0)
                            
                            Spacer(minLength: 0)
                            
                            Button("Salta"){
                                currentIndex = onboardingItems.count - 1
                                playAnimation()
                            }
                            .opacity(isLastSlide ? 0 : 1)
                        }
                        .animation(.easeInOut, value: currentIndex)
                        .tint(Color("Green"))
                        .fontWeight(.bold)
                        
                        // MARK: Movable Slides
                        VStack(spacing: 15){
                            let offset = -CGFloat(currentIndex) * size.width
                            // MARK: Resizable Lottie View
                            ResizableLottieView(onboardingItem: $item)
                                .frame(height: size.width)
                                .onAppear {
                                    // MARK: Intially Playing First Slide Animation
                                    if currentIndex == indexOf(item){
                                        item.lottieView.play(toProgress: 0.7)
                                    }
                                }
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5), value: currentIndex)
                            
                            Text(item.title)
                                .font(.title.bold())
                                .frame(maxWidth: .infinity, alignment: .center)
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5).delay(0.1), value: currentIndex)
                            
                            Text(item.subTitle)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal,15)
                                .foregroundColor(.gray)
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5).delay(0.2), value: currentIndex)
                        }
                        
                        Spacer(minLength: 0)
                        
                        // MARK: Next / Login Button
                        VStack(spacing: 15){
                            Text(isLastSlide ? "Inizia" : "Avanti")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical,isLastSlide ? 13 : 12)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Capsule()
                                        .fill(Color("Green"))
                                }
                                .padding(.horizontal,isLastSlide ? 30 : 100)
                                .onTapGesture {
                                    // MARK: Updating to Next Index
                                    if currentIndex < onboardingItems.count - 1 {
                                        // MARK: Pausing Previous Animation
                                        let currentProgress = onboardingItems[currentIndex].lottieView.currentProgress
                                        onboardingItems[currentIndex].lottieView.currentProgress = (currentProgress == 0 ? 0.7 : currentProgress)
                                        currentIndex += 1
                                        // MARK: Playing Next Animation from Start
                                        playAnimation()
                                    } else {
                                        showContentView = true
                                        isOnboardingCompleted = true
                                    }
                                }
                            
                            HStack{
                                Text("Copyright (c) 2023 Giulio Aterno")
                            }
                            .font(.caption2)
                            .underline(true, color: .primary)
                            .offset(y: 5)
                        }
                        .fullScreenCover(isPresented: $showContentView) {
                                    ContentView()
                                .ignoresSafeArea()
                                }
                    }
                    .animation(.easeInOut, value: isLastSlide)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
                }
            }
            .frame(width: size.width * CGFloat(onboardingItems.count),alignment: .leading)
        }
    }
    
    func playAnimation(){
        onboardingItems[currentIndex].lottieView.currentProgress = 0
        onboardingItems[currentIndex].lottieView.play(toProgress: 1.0)
    }
    
    // MARK: Retreving Index of the Item in the Array
    func indexOf(_ item: OnboardingItem)->Int{
        if let index = onboardingItems.firstIndex(of: item){
            return index
        }
        return 0
    }
}

struct OnBoardingScreen_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
