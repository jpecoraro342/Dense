//
//  FoodRowView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct FoodRowView: View {
    var food: FoodViewModel
    
    let formatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(UIColor.systemBackground)
                .cornerRadius(10)
                .shadow(radius: 3)
            VStack(alignment: .leading) {
                Text(food.name)
                Text("\(formatter.string(food.totalCalories) ?? "") Calories")
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        }
        .listRowSeparator(.hidden)
        .listRowBackground(
            Color(.clear))
    }
}

struct FoodRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FoodRowView(food: FoodViewModel(
                productId: UUID().uuidString,
                name: "Fritos",
                netWeightG: 250,
                servingSizeG: 25,
                caloriesPerServing: 140,
                quantity: 1,
                missingInfo: false))
        }
    }
}
