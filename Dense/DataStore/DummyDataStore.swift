//
//  DummyDataStore.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/7/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

class DummyDataStore {
    var products = [
        Product(code: "1", productName: "Peanut Butter", productQuantity: "737", servingQuantity: "32", nutriments: Nutrients(energyKcalServing: 190)),
        Product(code: "2", productName: "Fritos", productQuantity: "400", servingQuantity: "10", nutriments: Nutrients(energyKcalServing: 140))
    ]
    
    var resupplies = [
        Resupply(date: Date(), id: "1", name: "", items: [ResupplyItem(productId: "1", quantity: 1)])
    ]
}

extension DummyDataStore : ProductDataStore {
    func getProducts() async -> [Product] {
        return products
    }
    
    func getProduct(barcode: String) async -> (Product?, NSError?) {
        if let product = await getProducts().first(where: { $0.code == barcode }) {
            return (product, nil)
        }
        
        return (nil, NSError(localizedDescription: "no products found"))
    }
    
    func putProduct(_ product: Product) async {
        if let index = await getProducts().firstIndex(where: { $0.code == product.code }) {
            products[index] = product
        } else {
            products.append(product)
        }
    }
}

extension DummyDataStore : ResupplyDataStore {
    func getResupplies() async -> [Resupply] {
        return resupplies
    }
    
    func getResupply(id: String) async -> Resupply? {
        return await getResupplies().first(where: { $0.id == id })
    }
    
    func putResupply(_ resupply: Resupply) async {
        if let index = await getResupplies().firstIndex(where: { $0.id == resupply.id }) {
            resupplies[index] = resupply
        } else {
            resupplies.append(resupply)
        }
    }
    
    func resetResupply(id: String) async -> Resupply? {
        if var resupply = await getResupply(id: id) {
            resupply.items = []
            return resupply
        }
        
        return nil
    }
    
    func putItem(_ item: ResupplyItem, toResupply: String) async {
        if var resupply = await getResupply(id: toResupply) {
            resupply.put(item: item)
        } else {
            let resupply = Resupply(date: Date(), id: toResupply, name: "", items: [item])
            resupplies.append(resupply)
        }
    }
    
    func removeItem(_ item: ResupplyItem, fromResupply: String) async {
        if var resupply = await getResupply(id: fromResupply) {
            resupply.delete(item: item)
        }
    }
}
