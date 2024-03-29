//
//  DataStore.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

protocol ProductDataStore {
    func getProducts() async -> [Product]
    func getProduct(barcode: String) async -> (Product?, NSError?)
    func putProduct(_ product: Product) async
}

protocol ResupplyDataStore {
    func getResupplies() async -> [Resupply]
    func getResupply(id: String) async -> Resupply?
    func putResupply(_ resupply: Resupply) async
    func resetResupply(id: String) async -> Resupply?
    func putCaloriesPerDay(_ caloriesPerDay: Double, forResupply id: String) async
    func putTargetNumberOfDays(_ targetDays: Double, forResupply id: String) async
    func putItem(_ item: ResupplyItem, toResupply: String) async
    func removeItem(_ item: ResupplyItem, fromResupply: String) async
    func removeItem(_ itemId: String, fromResupply resupplyId: String) async
}
