//
//  UserDefaults.swift
//  Dense
//
//  Created by Joseph Pecoraro on 6/13/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension UserDefaults {
    internal static let analyticsEnabledKey = "analyticsEnabled"
    
    internal func setDefaults() {
        UserDefaults.standard.register(
            defaults: [
                UserDefaults.analyticsEnabledKey : true
            ]
        )
    }
}
