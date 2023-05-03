//
//  Food.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Combine

struct FoodViewModel {
    var productId : String // Barcode for scanned products, UUID for manually added
    var name : String
    var netWeightG : Double
    var servingSizeG : Double
    
    var caloriesPerServing : Double
    
    var totalCalories : Double {
        return caloriesPerServing * (netWeightG/servingSizeG)
    }
    
    var quantity : Double
    
    var missingInfo : Bool
    
    func resupplyItem() -> ResupplyItem {
        return ResupplyItem(productId: productId, quantity: quantity)
    }
}

extension FoodViewModel {
    init(resupplyItem: ResupplyItem, product: Product) {
        self.productId = resupplyItem.productId
        self.name = product.productName
        self.caloriesPerServing = product.nutriments.energyKcalServing ?? 0
        self.netWeightG = Double(product.productQuantity ?? "") ?? 0
        self.servingSizeG = Double(product.servingQuantity ?? "") ?? 0
        self.quantity = resupplyItem.quantity
        
        missingInfo = product.nutriments.energyKcalServing == nil
            || Double(product.productQuantity ?? "") == nil
            || Double(product.servingQuantity ?? "") == nil
    }
}
