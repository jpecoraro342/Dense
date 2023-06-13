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
    
    private static let analyticsUrl : URL = URL(string: "https://analytics.joseph-pecoraro.com/events")!
    
    private static let analyticsHeaderFields : [String : String?] = [
        "CF-Access-Client-Id": Bundle.main.infoDictionary?["ANALYTICS_API_KEY"] as? String,
        "CF-Access-Client-Secret": Bundle.main.infoDictionary?["ANALYTICS_API_SECRET"] as? String
    ]
    
    private var analyticsEnabled : Bool = false
    
    private init() {}
    
    public func start() {
        analyticsEnabled = true

        let _ = BasicAnalytics.Analytics.shared.initialize(Configuration(
            url: Self.analyticsUrl,
            httpHeaderFields: Self.analyticsHeaderFields,
            uploadTimerSeconds: 40
        ))
    }
    
    public func logEvent(_ name: Event, location: String? = nil, extras: [String : String] = [:]) {
        if analyticsEnabled {
            BasicAnalytics.Analytics.shared.logEvent(BasicAnalytics.Event(
                eventName: "\(name)",
                eventLocation: location,
                extras: extras
            ))
        }
    }
    
    public func stop() {
        BasicAnalytics.Analytics.shared.stop()
        analyticsEnabled = false
    }
}

enum Event : String, CustomStringConvertible {
    // FileDataStore
    case errorReadingFromFile, errorWritingToFile
    
    // ResupplyView
    case addFoodTapped, scanBarcodeTapped, multiselectTapped, multiselectDismissTapped, resetButtonTapped, resetCancelTapped, resetConfirmTapped
    
    // Resupply Items
    case resupplyItemAdded, resupplyItemDeleted, quantityTapped, quantityUpdated
    
    // Barcodes
    case barcodeScanned, barcodeDataFetched, barcodeDataFetchFailed
    
    // Products
    case productSaved, productUpdated, canceledAddingProduct

    // Settings
    case settingsClicked
    
    // Multiselect
    case multiselectProductTapped
    
    // Day Summary
    case targetDaysTapped, targetDaysUpdated, caloriesPerDayTapped, caloriesPerDayUpdated
    
    var description: String {
        return self.rawValue
    }
}
