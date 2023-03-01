//
//  AddFoodView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct AddFoodView: View {
    @State var name = ""
    @State var caloriesPerServing = ""
    @State var numberOfServings = ""
    @State var servingSizeG = ""
    @State var netWtOz = ""
    
    var body: some View {
        VStack {
            Text("Add Food")
            
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("Calories Per Serving", text: $caloriesPerServing)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            TextField("Number of Servings", text: $numberOfServings)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            TextField("Serving Size (g)", text: $servingSizeG)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            TextField("Net Wt (oz)", text: $netWtOz)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            
            Text("Must include either net wt (oz), or serving size (g)")
        }
        .padding(40)
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
