//
//  FoodCalculator.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

class FoodCalculator : NSObject {
    let food : [FoodItem]
    
    init(foodList: [FoodItem]) {
        self.food = foodList
    }
    
    func weight() -> Double {
        return food.reduce(0, { $0 + $1.oz})
    }
    
    func calories() -> Double {
        return food.reduce(0, { $0 + $1.calories })
    }
}
