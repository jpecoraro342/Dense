//
//  FoodPListAccessor.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

class UserDefaultsFoodDataAccessor {
    var initialized = false
    var food : [FoodItem] = []
    
    func saveChanges() {
        let clock = ContinuousClock()

        var result = clock.measure() {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.food), forKey: "foodList")
        }
        
        print(result.formatted(.units(allowed: [.milliseconds], width: .wide)))
    }
}

extension UserDefaultsFoodDataAccessor : FoodListDataAccessor {
    
    func food() async -> [FoodItem] {
        if initialized {
            return food
        }
        
        let clock = ContinuousClock()

        var result = clock.measure() {
            if let data = UserDefaults.standard.value(forKey:"foodList") as? Data {
                food = (try? PropertyListDecoder().decode(Array<FoodItem>.self, from: data)) ?? []
            } else {
                food = []
            }
        }
        
        print(result.formatted(.units(allowed: [.milliseconds], width: .wide)))
        
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
