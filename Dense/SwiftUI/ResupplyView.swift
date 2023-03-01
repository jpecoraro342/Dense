//
//  FoodList.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplyView: View {
    @State var food : [FoodItem] = []
    
    var body: some View {
        VStack {
            ResupplySummaryView()
            List(food, id: \.name) { food in
                FoodRowView(food: food)
            }
            .task {
                self.food = await dataAccessor.food()
            }
            .navigationTitle("Foods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        self.food = dataAccessor.clearFood()
                    }
                }
                ToolbarItem {
                    Button("Add Food") {
                        // TODO: Add Food
                    }
                }
            }
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView(initialView: ResupplyView())
    }
}
