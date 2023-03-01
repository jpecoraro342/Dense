//
//  BarcodeScanner.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/1/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI
import VisionKit

struct BarcodeScannerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    var scannedBarcode: (String?) -> Void
    
    func makeUIViewController(context: Context) -> DataScannerViewController
    {
        let vc = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    func makeCoordinator() -> BarcodeScannerCoordinator
    {
        return BarcodeScannerCoordinator(
            addedItems: { recognizedItems in
                switch(recognizedItems.first) {
                    case .barcode(let barcode):
                        scannedBarcode(barcode.payloadStringValue)
                    default: break
                }
                
                dismiss()
            },
            becameUnavailable: {
                // TODO: tell the user scanning failed
                // TODO: Cancel scanning, and dismiss
                dismiss()
            })
    }
    
    class BarcodeScannerCoordinator : NSObject, DataScannerViewControllerDelegate {
        let addedItems: ([RecognizedItem]) -> Void
        let becameUnavailable: () -> Void
        
        init(addedItems: @escaping ([RecognizedItem]) -> Void, becameUnavailable: @escaping () -> Void) {
            self.addedItems = addedItems
            self.becameUnavailable = becameUnavailable
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            self.addedItems(addedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            self.becameUnavailable()
        }
    }
}

struct BarcodeScanner_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView() { scannedBarcodes in
            print(scannedBarcodes)
        }
    }
}
