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
    
    mutating func put(item: ResupplyItem) {
        if let index = items.firstIndex(where: { $0.productId == item.productId }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }
    
    mutating func delete(item: ResupplyItem) {
        if let index = items.firstIndex(where: { $0.productId == item.productId }) {
            items.remove(at: index)
        }
    }
}

extension Resupply : Codable {}

struct ResupplyItem {
    var productId: String // Barcode for scanned products, UUID for manually added
    var quantity: Double
}

extension ResupplyItem : Codable {}
