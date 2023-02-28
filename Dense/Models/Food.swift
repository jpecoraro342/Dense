//
//  Food.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

struct FoodItem {
    let id : String? = nil
    let barcode: String? = nil
    let name : String
    let netWtOz : Double? = nil
    let caloriesPerServing : Double? = nil
    let servingsPerContainer : Double? = nil
    let servingSizeG : Double? = nil
    
    // OLD
    // Need *either* total calories and net wt oz, or servingSize and servings per container
    let calories : Double
    let oz : Double
}

extension FoodItem : Codable {}
