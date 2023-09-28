//
//  ScannerView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 27/09/23.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    /// QR Code Scanner Proprietà
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    /// QR Scanner AV Output
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    /// Proprietà d'errore
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    /// QR Output Delegate
    @StateObject private var qrDelegate = QRScannerDelegate()
    /// Codice Scannerizzato
    @State private var scannedCode: String = ""
    /// Orientamento del Device
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(Color.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Posiziona il QR Code al centro")
                .font(.title3)
                .foregroundColor(.black.opacity(0.8))
                .padding(.top, 20)
            
            Text("La scansione inizierà automaticamente")
                .font(.callout)
                .foregroundColor(.gray)
            
            Spacer(minLength: 0)
            
            /// Scanner
            GeometryReader {
                let size = $0.size
                let sqareWidth = min(size.width, 300)
                
                ZStack {
                    CameraView(frameSize: CGSize(width: sqareWidth, height: sqareWidth), session: $session, orientation: $orientation)
                        .cornerRadius(4)
                        .scaleEffect(0.97)
                        .onRotate {
                            if session.isRunning {
                                orientation = $0
                            }
                        }
                    
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double(index) * 90
                        
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(Color("Pink"), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                }
                /// Quadrato
                .frame(width: sqareWidth, height: sqareWidth)
                /// Animazione Scanner
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(Color("Pink"))
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? sqareWidth : 0)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 15)
            
            Button {
                if !session.isRunning && cameraPermission == .approved {
                    reactivateCamera()
                    activateScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            Text("Tocca l'icona per eseguire una nuova scansione")
                .font(.callout)
                .foregroundColor(.gray)
            
            Spacer(minLength: 45)
        }
        .padding(15)
        /// Controllo dei permessi
        .onAppear(perform: checkCameraPermission)
        .onDisappear {
            session.stopRunning()
        }
        .alert(errorMessage, isPresented: $showError) {
            /// Impostazione bottone
            if cameraPermission == .denied {
                Button("Impostazioni") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingsString) {
                        openURL(settingsURL)
                    }
                }
                
                /// Bottone per cancellare
                Button("Annulla", role: .cancel) {
                }
            }
        }
        .onChange(of: qrDelegate.scannedCode) { newValue in
            if let code = newValue {
                scannedCode = code
                /// Ferma la camera dopo il codice
                session.stopRunning()
                /// Ferma l'animazione
                deActivateScannerAnimation()
                /// Pulisce i Dati del Delegate
                qrDelegate.scannedCode = nil
                /// Apri Safari con l'URL scannerizzato
                if let url = URL(string: scannedCode), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        .onChange(of: session.isRunning) { newValue in
            if newValue {
                orientation = UIDevice.current.orientation
            }
        }
    }
    
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    /// Attivazione dello Scanner Animation
    func activateScannerAnimation() {
        /// Aggiunzione delay
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    /// Disativazione animazione
    func deActivateScannerAnimation() {
        /// Aggiunzione dell'animazione
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    /// Controllo dei permessi della Fotocamera
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    /// New Setup
                    setupCamera()
                } else {
                    /// Esistente
                    reactivateCamera()
                }
            case .notDetermined:
                /// Richiesta Accesso
                if await AVCaptureDevice.requestAccess(for: .video) {
                    /// Permesso concesso
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    /// Permesso fallito
                    cameraPermission = .denied
                    /// Presentazione errore
                    presentError("Per favore, fornisci l'accesso alla Fotocamera")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Per favore, fornisci l'accesso alla Fotocamera per scansionare i QRCode")
            default: break
            }
        }
    }
    
    /// Setup Fotocamera
    func setupCamera() {
        do {
            /// Fotocamera posteriore
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN DEVICE ERROR")
                return
            }
            
            /// Camera Input
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN INPUT/OUTPUT ERROR")
                return
            }
            
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            qrOutput.metadataObjectTypes = [.qr]
            
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    /// Presentazione Errore
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
