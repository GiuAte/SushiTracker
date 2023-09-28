//
//  QRCodeButton.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 28/09/23.
//

import SwiftUI
import AVFoundation

struct QRCodeButton: View {
    
    @State private var isScannerViewPresented = false
    @EnvironmentObject private var soundManager: SoundManager
    
    var body: some View {
        HStack {
            ZStack {
                Button(action: {
                    SoundManager.shared.playSound(named: "buttonpressed")
                    isScannerViewPresented.toggle()
                }){
                    Image(systemName: "qrcode.viewfinder")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                }
                .padding()
                .background(Color.pink)
                .mask(Circle())
                .shadow(color: Color.pink, radius: 10)
                .zIndex(10)
                .fullScreenCover(isPresented: $isScannerViewPresented) {
                    ScannerView()
                }
            }
        }
    }
}

#Preview {
    QRCodeButton()
}
