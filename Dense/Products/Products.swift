//
//  Products.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

struct Product {
    var code: String
    var productName: String
    /// Net Wt (g)
    var productQuantity: String? // TODO: Decode from number or string
    /// Serving Size (g)
    var servingQuantity: String?
    var imageIngredientsUrl: URL?
    var imageNutritionUrl: URL?
    var imageUrl: URL?
    var nutrientLevelsTags: [String]?
    var nutriments: Nutrients
    
    static func fields() -> [String] {
        return ["code",
                "product_name",
                "nutrient_levels_tags",
                "nutriments",
                "image_url",
                "image_nutrition_url",
                "image_ingredients_url",
                "serving_quantity",
                "product_quantity"]
    }
    
    static func fields() -> String {
        return fields().joined(separator: ",")
    }
}

extension Product : Codable {}

// View model initializers/updaters
extension Product {
    init(name: String, caloriesPerServing: String, numberOfServings: String, servingSizeG: String, netWtG: String) {
        self.code = UUID().uuidString
        self.productName = name
        self.servingQuantity = servingSizeG
        self.productQuantity = netWtG
        self.nutriments = Nutrients()
        
        if let calsPerServing = Double(caloriesPerServing) {
            self.nutriments.energyKcalServing = calsPerServing
        }
        
        guard let numberOfServings = Double(numberOfServings) else { return }
        
        if servingSizeG.isEmpty {
            // Fill serving size from net wt
            if let netWtG = Double(netWtG) {
                self.servingQuantity = String(netWtG/numberOfServings)
            }
        }
        
        if netWtG.isEmpty {
            // Fill net wt from serving size
            if let servingSizeG = Double(servingSizeG) {
                self.productQuantity = String(servingSizeG*numberOfServings)
            }
        }
    }
    
    mutating func updateWith(name: String, caloriesPerServing: String, numberOfServings: String, servingSizeG: String, netWtG: String) {
        if (!name.isEmpty) {
            self.productName = name
        }
        
        if let calsPerServing = Double(caloriesPerServing) {
            self.nutriments.energyKcalServing = calsPerServing
        }
        
        if (!servingSizeG.isEmpty) {
            self.servingQuantity = servingSizeG
        }
        
        if (!netWtG.isEmpty) {
            self.productQuantity = netWtG
        }
        
        guard let numberOfServings = Double(numberOfServings) else { return }
        
        if servingSizeG.isEmpty {
            // Fill serving size from net wt
            if let netWtG = Double(netWtG) {
                self.servingQuantity = String(netWtG/numberOfServings)
            }
        }
        
        if netWtG.isEmpty {
            // Fill net wt from serving size
            if let servingSizeG = Double(servingSizeG) {
                self.productQuantity = String(servingSizeG*numberOfServings)
            }
        }
    }
}

struct Nutrients {
    var carbohydratesServing: Double?
    var energyKcalServing: Double?
    var fatServing: Double?
    var fiberServing: Double?
    var proteinsServing: Double?
    var saltServing: Double?
    var sodiumServing: Double?
    var sugarsServing: Double?
}

extension Nutrients : Codable {
    private enum CodingKeys: String, CodingKey {
        case carbohydratesServing
        case energyKcalServing = "energy-kcalServing" // This key is used for decoding open food facts api
        case fatServing
        case fiberServing
        case proteinsServing
        case saltServing
        case sodiumServing
        case sugarsServing
    }
}
