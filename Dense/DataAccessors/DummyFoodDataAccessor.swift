//
//  DummyFoodDataAccessor.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

class DummyFoodDataAccessor {
    var food : [FoodItem] = [
        FoodItem(name: "Fritos", calories: 1400, oz: 10),
        FoodItem(name: "Peanut Butter", calories: 2000, oz: 16)
    ]
}

extension DummyFoodDataAccessor : FoodListDataAccessor {
    
    func food() async -> [FoodItem] {
        return food
    }
    
    func addFood(food: FoodItem) -> [FoodItem] {
        self.food.append(food)
        
        return self.food
    }
    
    func clearFood() -> [FoodItem] {
        self.food.removeAll()
        
        return self.food
    }
    
    func removeFood(index: Int) -> [FoodItem] {
        self.food.remove(at: index)
        
        return self.food
    }
}
