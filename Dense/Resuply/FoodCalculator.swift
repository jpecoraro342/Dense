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
        return food.reduce(0, { $0 + ($1.netWeightG * $1.quantity) }) * Self.gramsToOunces
    }
    
    func calories() -> Double {
        return food.reduce(0, { $0 + ($1.totalCalories * $1.quantity) })
    }
    
    func daysOfFood(caloriesPerDay : Double) -> Double {
        return calories()/caloriesPerDay
    }
    
    func caloriesNeeded(caloriesPerDay : Double, numberOfDays: Double) -> Double {
        return (caloriesPerDay * numberOfDays) - calories()
    }
}
