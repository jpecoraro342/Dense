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
    @State var resupplyId : String?
    @State var resupply : ResupplyViewModel
    
    @State private var showingResetConfirmation = false
    
    let dataStore : ResupplyDataStore & ProductDataStore
    
    var body: some View {
        VStack {
            ResupplySummaryView(resupply: $resupply)
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
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.immediately)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Resupply")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
            ToolbarItem(placement: .primaryAction) {
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
    }
}
