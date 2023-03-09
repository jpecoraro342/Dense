//
//  FoodCalculator.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

class FoodCalculator : NSObject {
    let food : [FoodViewModel]
    
    static let gramsToOunces = 0.035274
    
    init(foodList: [FoodViewModel]) {
        self.food = foodList
    }
    
    func weight() -> Double {
        return food.reduce(0, { $0 + $1.netWeightG}) * Self.gramsToOunces
    }
    
    func calories() -> Double {
        return food.reduce(0, { $0 + $1.totalCalories })
    }
}
