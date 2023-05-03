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
    
    public static let productsFilePath = "products.json"
    public static let resuppliesFilePath = "resupplies.json"
    
    func initializeDataStore() async {
        async let _ = await getProducts()
        async let _ = await getResupplies()
    }
}

extension FileDataStore {
    private func saveProducts() async {
        let clock = ContinuousClock()

        let result = clock.measure() {
            encoder.writeToFile(object: products, filePath: Self.productsFilePath)
        }
        
        print("saved products in " + result.milliseconds() + "ms")
    }
    
    private func saveResupplies() async {
        let clock = ContinuousClock()

        let result = clock.measure() {
            encoder.writeToFile(object: resupplies, filePath: Self.resuppliesFilePath)
        }
        
        print("saved resupplies in " + result.milliseconds() + "ms")
    }
}

extension FileDataStore : ProductDataStore {
    func getProducts() async -> [Product] {
        if (productsInitialized) {
            return products
        }
                
        if let products : [Product] = decoder.readFromFile(filePath: Self.productsFilePath) {
            self.products = products
        }
        
        productsInitialized = true
        return products
    }
    
    func getProduct(barcode: String) async -> (Product?, NSError?) {
        if let product = await getProducts().first(where: { $0.code == barcode }) {
            return (product, nil)
        }
        
        var (product, error) = await OpenFoodFactsAPI.shared.getProduct(fromBarcode: barcode)
        
        if let product = product {
            await putProduct(product)
            return (product, nil)
        } else {
            error = error ?? NSError(localizedDescription: "An unknown error occurred while trying to retrieve the food from the barcode.")
        }
        
        return (nil, error)
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
        
        if let resupplies : [Resupply] = decoder.readFromFile(filePath: Self.resuppliesFilePath) {
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
    
    func putCaloriesPerDay(_ caloriesPerDay: Double, forResupply resupplyId: String) async {
        if let index = await getResupplies().firstIndex(where: { $0.id == resupplyId }) {
            var resupply = resupplies[index]
            resupply.caloriesPerDay = caloriesPerDay
            resupplies[index] = resupply
        } else {
            let resupply = Resupply(date: Date(), id: resupplyId, name: "", items: [], caloriesPerDay: caloriesPerDay)
            resupplies.append(resupply)
        }
        
        await saveResupplies()
    }
    
    func putTargetNumberOfDays(_ targetDays: Double, forResupply resupplyId: String) async {
        if let index = await getResupplies().firstIndex(where: { $0.id == resupplyId }) {
            var resupply = resupplies[index]
            resupply.targetNumberOfDays = targetDays
            resupplies[index] = resupply
        } else {
            let resupply = Resupply(date: Date(), id: resupplyId, name: "", items: [], targetNumberOfDays: targetDays)
            resupplies.append(resupply)
        }
        
        await saveResupplies()
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
        await removeItem(item.productId, fromResupply: resupplyId)
    }
    
    func removeItem(_ itemId: String, fromResupply resupplyId: String) async {
        if let index = await getResupplies().firstIndex(where: { $0.id == resupplyId }) {
            var resupply = resupplies[index]
            resupply.delete(itemId: itemId)
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
