//
//  FoodList.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplyView: View {
    @State var resupplyId : String?
    @State var resupply : ResupplyViewModel
    
    @State var productCount : Int = 0
    
    @State private var showingAddFood = false
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
            ToolbarItem(placement: .primaryAction) {
                SheetButton("Add Food", action: {
                    Analytics.shared.logEvent(.addFoodTapped, location: "header")
                }) {
                    addFoodView
                }
            }
            ToolbarItem(placement: .secondaryAction) {
                resetButton
            }
            ToolbarItem(placement: .secondaryAction) {
                NavigationLink("Settings") {
                    SettingsView(dataStore: dataStore)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    Analytics.shared.logEvent(.settingsClicked)
                })
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
            .onDelete(perform: delete(at:))
            if (resupply.foods.isEmpty) {
                Text("Get started by adding new foods, or selecting from previously added foods.")
            }
            addButtonsFooter
            // TODO: If resupply is empty, and products list is not empty, show "quick add" button here
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
    }
    
    var addButtonsFooter: some View {
        HStack {
            multiAddButton
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.vertical], 10.0)
                .buttonStyle(.borderless)
            Divider()
            SheetButton("Add Food", action: {
                Analytics.shared.logEvent(.addFoodTapped, location: "footer")
            }) {
                addFoodView
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding([.vertical], 10.0)
            .buttonStyle(.borderless)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    
    var addFoodView: some View {
        AddFoodView(dataStore: dataStore) { product in
            if let product = product {
                let resupplyItem = ResupplyItem(productId: product.code, quantity: 1)
                Task {
                    await dataStore.putItem(resupplyItem, toResupply: resupply.id)
                    await updateResupplyViewModel()
                }
                
                Analytics.shared.logEvent(.resupplyItemAdded, extras: ["id": product.code])
            }
        }
    }
    
    var resetButton: some View {
        Button("Clear Resupply") {
            showingResetConfirmation = true
            Analytics.shared.logEvent(.resetButtonTapped)
        }
        .alert("Are you sure you want to clear all foods from the resupply?", isPresented: $showingResetConfirmation) {
            Button("Clear", role: .destructive) {
                Analytics.shared.logEvent(.resetConfirmTapped)
                Task {
                    if let resupply = await dataStore.resetResupply(id: resupply.id) {
                        self.resupply = ResupplyViewModel(resupply: resupply, products: await dataStore.getProducts())
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                Analytics.shared.logEvent(.resetCancelTapped)
            }
        } message: {
            Text("This will clear all foods added to this resupply")
        }
    }
    
    var multiAddButton: some View {
        SheetButton("Select Foods", action: { Analytics.shared.logEvent(.multiselectTapped, location: "footer") }) {
            multiSelectFoodView
        }
    }
    
    var multiSelectFoodView: some View {
        NavigationView {
            MultiSelectFoodView(
                dataStore: dataStore,
                // TODO: Do this mapping in a view model, or in the multiselect food view
                selectedProducts: $resupply.foods.reduce(into: [String: Bool]()) {
                    $0[$1.productId.wrappedValue] = true
                }) { productId, isSelected in
                    // TODO: put this logic somewhere else
                    // TODO: This feels very not thread safe
                    Task {
                        if (!isSelected) {
                            await dataStore.removeItem(productId, fromResupply: resupply.id)
                            await updateResupplyViewModel()
                        } else if let _ = resupply.foods.firstIndex(where: { $0.productId == productId }) {
                            // Don't bother adding the product if it's already there
                            return
                        } else {
                            await dataStore.putItem(ResupplyItem(productId: productId, quantity: 1), toResupply: resupply.id)
                            await updateResupplyViewModel()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
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
    
    func delete(at offsets: IndexSet) {
        guard let id = resupplyId else { return }
        
        Task {
            for index in offsets {
                // TODO: Can this throw an error?
                let item = resupply.foods[index]
                await dataStore.removeItem(item.resupplyItem(), fromResupply: id)
                await updateResupplyViewModel()
                
                Analytics.shared.logEvent(.resupplyItemDeleted, extras: ["id": item.productId])
            }
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView(
            initialView: ResupplyView(
                resupply: ResupplyViewModel(),
                dataStore: DummyDataStore()))
        CoordinatorView(
            initialView: ResupplyView(
                resupply: ResupplyViewModel(),
                dataStore: DummyDataStore(products: [], resupplies: [])))
    }
}
