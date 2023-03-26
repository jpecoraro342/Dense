//
//  BarcodeButtonPrompt.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/1/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI
import AVKit

struct BarcodeButtonPrompt: View {
    @State private var showingBarcodeScanner = false
    @State var cameraAuthStatus  = AVCaptureDevice.authorizationStatus(for: .video)
    var barcodeScanned: (String) -> Void
    
    var body: some View {
        // TODO: Show different view if denied camera permissions, or unavailable
        VStack {
            Button() {
                Task {
                    await showBarcodeScanner()
                }
            } label: {
                Text("Scan Barcode")
                    .frame(minWidth: 100, minHeight: 100)
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
            .disabled(cameraAuthStatus == .restricted || cameraAuthStatus == .denied)
            .sheet(isPresented: $showingBarcodeScanner) {
                BarcodeScannerView() { barcode in
                    if let barcode = barcode {
                        barcodeScanned(barcode)
                    } else {
                        // TODO: Handle failure
                    }
                }
            }
            
            if (cameraAuthStatus == .restricted || cameraAuthStatus == .denied) {
                Text("Please allow camera access in order to access the barcode scanner")
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    func showBarcodeScanner() async {
        switch cameraAuthStatus
        {
        case .authorized:
            showingBarcodeScanner = true
        case .restricted, .denied: break
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted
            {
                cameraAuthStatus = .authorized
                showingBarcodeScanner = true
            }
            else
            {
                cameraAuthStatus = .denied
            }
        default : break
        }
    }
}

struct BarcodeButtonPrompt_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BarcodeButtonPrompt(cameraAuthStatus: .authorized) { barcode in
                print(barcode)
            }
            BarcodeButtonPrompt(cameraAuthStatus: .notDetermined) { barcode in
                print(barcode)
            }
            BarcodeButtonPrompt(cameraAuthStatus: .denied) { barcode in
                print(barcode)
            }
        }
    }
}
