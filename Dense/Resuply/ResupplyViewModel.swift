//
//  ResupplyViewModel.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/8/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Combine

struct ResupplyViewModel {
    var date: Date
    var id: String
    var name: String
    var foods: [FoodViewModel]
    var caloriesPerDay: Double = Resupply.defaultCaloriesPerDay
    var targetNumberOfDays: Double = Resupply.defaultNumberOfDays
}

extension ResupplyViewModel {
    init() {
        date = Date()
        id = UUID().uuidString
        name = ""
        foods = []
    }
    
    init(resupply: Resupply, products: [Product]) {
        date = resupply.date
        id = resupply.id
        name = resupply.name

        foods = []

        for item in resupply.items {
            if let product = products.first(where: { $0.code == item.productId }) {
                foods.append(FoodViewModel(resupplyItem: item, product: product))
            }
        }
        
        caloriesPerDay = resupply.caloriesPerDay
        targetNumberOfDays = resupply.targetNumberOfDays
    }
}
