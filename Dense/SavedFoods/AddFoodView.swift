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
        GeometryReader { geometry in
            ScrollView {
                BarcodeButtonPrompt { barcode in
                    print(barcode)
                }
                .padding(.top)
                
//                ProgressView()
//                    .padding(.bottom)
                
                inputFields
                
                Text("If barcode data is incomplete or incorrect, you can help update it for everyone at [Open Food Facts](https://world.openfoodfacts.org/help-complete-products) or by using the [Open Food Facts App](https://apps.apple.com/us/app/open-food-facts-product-scan/id588797948)")
            }
            .padding()
        }
        .ignoresSafeArea(edges: .bottom)
        .onTapGesture {
            dismissKeyboard()
        }
    }
    
    var inputFields: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("Calories Per Serving", text: $caloriesPerServing)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            TextField("Number of Servings", text: $numberOfServings)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            HStack {
                TextField("Serving Size (g)", text: $servingSizeG)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                Text("or")
                TextField("Net Wt (g)", text: $netWtOz)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            }
            
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
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView() { food in
        }
    }
}

