//
//  AddFoodView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var name = ""
    @State var caloriesPerServing = ""
    @State var numberOfServings = ""
    @State var servingSizeG = ""
    @State var netWtOz = ""
    
    var action: (FoodItem?) -> Void
    
    var body: some View {
        ScrollView {
            Text("Add Food")
                .fontWeight(.semibold)
                .padding()
            
            BarcodeButtonPrompt { barcode in
                print(barcode)
            }

            
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
            
            HStack(alignment: .center, spacing: 20) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                Button("Add Food") {
                    let totalCalories = (Double(caloriesPerServing) ?? 0) * (Double(numberOfServings) ?? 1)
                    let newFood = FoodItem(
                        name: name,
                        calories: totalCalories,
                        oz: Double(netWtOz) ?? 0)
                    
                    action(newFood)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Text("Note: Must include either net wt (oz), or serving size (g) to calculate calories/oz")
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView() { food in
        }
    }
}
