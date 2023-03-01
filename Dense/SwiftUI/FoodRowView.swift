//
//  FoodRowView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct FoodRowView: View {
    var food: FoodItem
    
    let formatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
            VStack(alignment: .leading) {
                Text(food.name)
                Text("\(formatter.string(from: food.calories) ?? "") Calories")
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
            FoodRowView(food: FoodItem(name: "Fritos", calories: 1000, oz: 10))
        }
    }
}
