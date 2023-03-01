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
    @State var food : [FoodItem] = []
    
    let dataAccessor : FoodListDataAccessor
    
    var body: some View {
        VStack {
            ResupplySummaryView(food: food)
            List {
                ForEach(food, id: \.name) { food in
                    FoodRowView(food: food)
                }
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            Button("Reset Resupply") {
                self.food = dataAccessor.clearFood()
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
                AddFoodView() { food in
                    if let food = food {
                        self.food = dataAccessor.addFood(food: food)
                    }
                }
            }
        }
        .toolbarBackground(
            Color(UIColor.systemBackground),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            self.food = await dataAccessor.food()
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            self.food = dataAccessor.removeFood(index: index)
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView(initialView: ResupplyView(dataAccessor: DummyFoodDataAccessor()))
    }
}
