//
//  NSNumberFormatter.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension NumberFormatter {
    func string(_ from: Double, default: String = "") -> String {
        return self.string(from: NSNumber(value: from)) ?? ""
    }
    
    func gramsToLbsOz(_ weight: Double) -> String {
        return lbsOz(weight * FoodCalculator.gramsToOunces)
    }
    
    func lbsOz(_ weight: Double) -> String {
        if weight < 16 {
            return "\(self.string(weight, default: "0"))oz"
        }
        
        let oz = weight.truncatingRemainder(dividingBy: 16)
        let lbs = (weight - oz)/16
        
        return "\(self.string(lbs, default: "0"))lbs \(self.string(oz, default: "0"))oz"
    }
}
