//
//  FoodPListAccessor.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

class PListFoodDataAccessor {
    var initialized = false
    var food : [FoodItem] = []
    
    func saveChanges() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.food), forKey: "foodList")
    }
}

extension PListFoodDataAccessor : FoodListDataAccessor {
    
    func food() async -> [FoodItem] {
        if initialized {
            return food
        }
        
        if let data = UserDefaults.standard.value(forKey:"foodList") as? Data {
            food = (try? PropertyListDecoder().decode(Array<FoodItem>.self, from: data)) ?? []
        } else {
            food = []
        }
        
        return food
    }
    
    func addFood(food: FoodItem) -> [FoodItem] {
        self.food.append(food)
        saveChanges()
        
        return self.food
    }
    
    func clearFood() -> [FoodItem] {
        self.food.removeAll()
        saveChanges()
        
        return self.food
    }
    
    func removeFood(index: Int) -> [FoodItem] {
        self.food.remove(at: index)
        saveChanges()
        
        return self.food
    }
}
