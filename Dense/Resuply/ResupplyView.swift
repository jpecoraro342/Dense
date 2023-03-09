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
    
    let dataStore : ResupplyDataStore & ProductDataStore
    
    var body: some View {
        VStack {
            ResupplySummaryView(resupply: resupply)
            List {
                ForEach(resupply.foods, id: \.name) { food in
                    FoodRowView(food: food)
                }
                .onDelete { indexSet in Task { await delete(at:indexSet) } }
            }
            .listStyle(.plain)
            Button("Reset Resupply") {
                Task {
                    if let resupply = await dataStore.resetResupply(id: resupply.id) {
                        self.resupply = ResupplyViewModel(resupply: resupply, products: await dataStore.getProducts())
                    }
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Resupply")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Add Food") {
                showingAddFood = true
            }
            .sheet(isPresented: $showingAddFood) {
                AddFoodView(dataStore: dataStore) { product in
                    if let product = product {
                        let resupplyItem = ResupplyItem(productId: product.code, quantity: 1)
                        Task {
                            await dataStore.putItem(resupplyItem, toResupply: resupply.id)
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
