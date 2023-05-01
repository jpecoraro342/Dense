//
//  FoodList.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplyView: View {
    @State private var showingAddFood = false
    @State private var showingAddMultiple = false
    @State var resupplyId : String?
    @State var resupply : ResupplyViewModel
    
    @State private var showingResetConfirmation = false
    
    let dataStore : ResupplyDataStore & ProductDataStore
    
    var body: some View {
        VStack {
            ResupplySummaryView(resupply: $resupply)
            resupplyItemViewList
            ResupplyDaySummary(
                resupply: $resupply,
                isExpanded: false,
                caloriesPerDayUpdated: { caloriesPerDay in
                    Task {
                        await dataStore.putCaloriesPerDay(caloriesPerDay, forResupply: resupply.id)
                        await updateResupplyViewModel()
                    }
                },
                targetDaysUpdated: { targetDays in
                    Task {
                        await dataStore.putTargetNumberOfDays(targetDays, forResupply: resupply.id)
                        await updateResupplyViewModel()
                    }
                })
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Resupply")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                addFoodButton
                multiAddButton
                resetButton
            }
            ToolbarItem(placement: .primaryAction) {
                addFoodButton
            }
        }
        .toolbarBackground(
            Color(UIColor.systemBackground),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            await initResupply()
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
    
    var resupplyItemViewList: some View {
        List {
            ForEach(resupply.foods, id: \.productId) { food in
                ResupplyItemView(food: food, quantityUpdated: { quantity in
                    Task {
                        var updatedFood = food
                        updatedFood.quantity = quantity
                        await dataStore.putItem(updatedFood.resupplyItem(), toResupply: resupply.id)
                        await updateResupplyViewModel()
                    }
                })
            }
            .onDelete { indexSet in Task { await delete(at:indexSet) } }
            if (resupply.foods.count == 0) {
                Text("").listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
    }
    
    var addFoodButton: some View {
        Button("Add Food") {
            showingAddFood = true
        }
        .sheet(isPresented: $showingAddFood) {
            AddFoodView(dataStore: dataStore) { product in
                if let product = product {
                    let resupplyItem = ResupplyItem(productId: product.code, quantity: 1)
                    Task {
                        await dataStore.putItem(resupplyItem, toResupply: resupply.id)
                        await updateResupplyViewModel()
                    }
                }
            }
        }
    }
    
    var resetButton: some View {
        Button("Reset") {
            showingResetConfirmation = true
        }
        .alert("Are you sure you want to reset?", isPresented: $showingResetConfirmation) {
            Button("Reset", role: .destructive) {
                Task {
                    if let resupply = await dataStore.resetResupply(id: resupply.id) {
                        self.resupply = ResupplyViewModel(resupply: resupply, products: await dataStore.getProducts())
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will clear all foods added to this resupply")
        }
    }
    
    var multiAddButton: some View {
        Button("Add Previously Used Foods") {
            showingAddMultiple = true
        }
        .sheet(isPresented: $showingAddMultiple) {
//            AddMultipleView(dataStore: dataStore) { products in
//                for product in products {
//                    let resupplyItem = ResupplyItem(productId: product.code, quantity: 1)
//                    Task {
//                        await dataStore.putItem(resupplyItem, toResupply: resupply.id)
//                        await updateResupplyViewModel()
//                    }
//                }
//            }
        }
    }
    
    func initResupply() async {
        if let _ = resupplyId {
            await updateResupplyViewModel()
        } else if let resupply = await dataStore.getResupplies().first {
            resupplyId = resupply.id
            await updateResupplyViewModel()
        } else {
            let id = UUID().uuidString
            self.resupplyId = id
            let resupply = Resupply(date: Date(), id: id, name: "", items: [])
            await dataStore.putResupply(resupply)
            await updateResupplyViewModel()
        }
    }
    
    func updateResupplyViewModel() async {
        guard let id = resupplyId else { return }
        
        guard let resupply = await dataStore.getResupply(id: id) else { return }
        
        self.resupply = ResupplyViewModel(resupply: resupply, products: await dataStore.getProducts())
    }
    
    func delete(at offsets: IndexSet) async {
        guard let id = resupplyId else { return }
        
        for index in offsets {
            // TODO: Can this throw an error?
            let item = resupply.foods[index]
            await dataStore.removeItem(item.resupplyItem(), fromResupply: id)
            await updateResupplyViewModel()
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView(initialView: ResupplyView(resupply: ResupplyViewModel(),
                                                 dataStore: DummyDataStore()))
        CoordinatorView(initialView: ResupplyView(resupply: ResupplyViewModel(),
                                                 dataStore: DummyDataStore(products: [], resupplies: [])))
    }
}
