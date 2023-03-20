//
//  FileDataStore.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

class FileDataStore : NSObject {
    private var productsInitialized = false
    private var products : [Product] = [] // products.json
    
    private var resuppliesInitialized = false
    private var resupplies : [Resupply] = [] // resupplies.json, can migrate to something better later
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let productsFilePath = "products.json"
    private let resuppliesFilePath = "resupplies.json"
    
    func initializeDataStore() async {
        async let _ = await getProducts()
        async let _ = await getResupplies()
    }
}

extension FileDataStore {
    private func saveProducts() async {
        let clock = ContinuousClock()

        let result = clock.measure() {
            encoder.writeToFile(object: products, filePath: productsFilePath)
        }
        
        print("saved products in " + result.milliseconds() + "ms")
    }
    
    private func saveResupplies() async {
        let clock = ContinuousClock()

        let result = clock.measure() {
            encoder.writeToFile(object: resupplies, filePath: resuppliesFilePath)
        }
        
        print("saved resupplies in " + result.milliseconds() + "ms")
    }
}

extension FileDataStore : ProductDataStore {
    func getProducts() async -> [Product] {
        if (productsInitialized) {
            return products
        }
                
        if let products : [Product] = decoder.readFromFile(filePath: productsFilePath) {
            self.products = products
        }
        
        productsInitialized = true
        return products
    }
    
    func getProduct(barcode: String) async -> Product? {
        if let product = await getProducts().first(where: { $0.code == barcode }) {
            return product
        }
        else if let product = await OpenFoodFactsAPI.shared.getProduct(fromBarcode: barcode) {
            await putProduct(product)
            return product
        }
        
        return nil
    }
    
    func putProduct(_ product: Product) async {
        if let index = await getProducts().firstIndex(where: { $0.code == product.code }) {
            products[index] = product
        } else {
            products.append(product)
        }
        
        await saveProducts()
    }
}

extension FileDataStore : ResupplyDataStore {
    func getResupplies() async -> [Resupply] {
        if (resuppliesInitialized) {
            return resupplies
        }
        
        if let resupplies : [Resupply] = decoder.readFromFile(filePath: resuppliesFilePath) {
            self.resupplies = resupplies
        }
        
        resuppliesInitialized = true
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
        
        await saveResupplies()
    }
    
    func resetResupply(id: String) async -> Resupply? {
        if let index = await getResupplies().firstIndex(where: { $0.id == id }) {
            var resupply = resupplies[index]
            resupply.items = []
            resupplies[index] = resupply
            await saveResupplies()
            return resupply
        }
        
        return nil
    }
    
    func putItem(_ item: ResupplyItem, toResupply resupplyId: String) async {
        if let index = await getResupplies().firstIndex(where: { $0.id == resupplyId }) {
            var resupply = resupplies[index]
            resupply.put(item: item)
            resupplies[index] = resupply
        } else {
            let resupply = Resupply(date: Date(), id: resupplyId, name: "", items: [item])
            resupplies.append(resupply)
        }
        
        await saveResupplies()
    }
    
    func removeItem(_ item: ResupplyItem, fromResupply resupplyId: String) async {
        if let index = await getResupplies().firstIndex(where: { $0.id == resupplyId }) {
            var resupply = resupplies[index]
            resupply.delete(item: item)
            resupplies[index] = resupply
        }
        
        await saveResupplies()
    }
}

extension FileDataStore {
    override var description : String {
        return ("Resupplies:\n\(resupplies)\nProducts:\n\(products)")
    }
}
