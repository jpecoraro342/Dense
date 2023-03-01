//
//  NSNumberFormatter.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension NumberFormatter {
    func string(from: Double) -> String? {
        return self.string(from: NSNumber(value: from))
    }
}
