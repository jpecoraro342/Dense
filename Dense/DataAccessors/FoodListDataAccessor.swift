//
//  FoodListDataAccessor.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

protocol FoodListDataAccessor {
    func food() async -> [FoodItem]
    func addFood(food: FoodItem) -> [FoodItem]
    func removeFood(index: Int) -> [FoodItem]
    func clearFood() -> [FoodItem]
}
