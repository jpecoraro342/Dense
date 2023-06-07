//
//  Analytics.swift
//  Dense
//
//  Created by Joseph Pecoraro on 6/7/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation
import BasicAnalytics

class Analytics {
    public static let shared = Analytics()
    
    private init() {}
    
    public func initialize() {
        let _ = BasicAnalytics.Analytics.shared.initialize(Configuration(
            url: URL(string: "https://analytics.joseph-pecoraro.com/events")!,
            uploadTimerSeconds: 40
        ))
    }
    
    public func logEvent(_ name: Event, location: String? = nil, extras: [String : String] = [:]) {
        BasicAnalytics.Analytics.shared.logEvent(BasicAnalytics.Event(
            eventName: "\(name)",
            eventLocation: location,
            extras: extras
        ))
    }
}

enum Event : String, CustomStringConvertible {
    // FileDataStore
    case resuppliesInitialized, productsInitialized
    
    // ResupplyView
    case addFoodTapped, scanBarcodeTapped, multiselectTapped, resetButtonTapped, resetCancelTapped, resetConfirmTapped
    
    // Resupply Items
    case resupplyItemAdded, resupplyItemDeleted, quantityTapped, quantityUpdated
    
    // Barcodes
    case barcodeScanned, barcodeDataFetched, barcodeDataFetchFailed
    
    // Products
    case productSaved, productUpdated, canceledAddingProduct

    // Debug Menu
    case debugMenuClicked
    
    // Multiselect
    case multiselectProductTapped
    
    // Day Summary
    case targetDaysTapped, targetDaysUpdated, caloriesPerDayTapped, caloriesPerDayUpdated
    
    var description: String {
        return self.rawValue
    }
}
