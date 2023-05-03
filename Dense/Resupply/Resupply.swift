//
//  Resupply.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

struct Resupply {
    var date: Date
    var id: String
    var name: String
    var items: [ResupplyItem]
    var caloriesPerDay: Double = Self.defaultCaloriesPerDay
    var targetNumberOfDays: Double = Self.defaultNumberOfDays
    
    static let defaultCaloriesPerDay = 3500.0
    static let defaultNumberOfDays = 4.5
    
    mutating func put(item: ResupplyItem) {
        if let index = items.firstIndex(where: { $0.productId == item.productId }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }
    
    mutating func delete(item: ResupplyItem) {
        delete(itemId: item.productId)
    }
    
    mutating func delete(itemId: String) {
        if let index = items.firstIndex(where: { $0.productId == itemId }) {
            items.remove(at: index)
        }
    }
}

extension Resupply : Codable {
    enum CodingKeys: String, CodingKey {
        case date, id, name, items, caloriesPerDay, targetNumberOfDays
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.items = try container.decode([ResupplyItem].self, forKey: .items)
        self.caloriesPerDay = try container.decodeIfPresent(Double.self, forKey: .caloriesPerDay) ?? Self.defaultCaloriesPerDay
        self.targetNumberOfDays = try container.decodeIfPresent(Double.self, forKey: .targetNumberOfDays) ?? Self.defaultNumberOfDays
    }
}

struct ResupplyItem {
    var productId: String // Barcode for scanned products, UUID for manually added
    var quantity: Double
}

extension ResupplyItem : Codable {}
