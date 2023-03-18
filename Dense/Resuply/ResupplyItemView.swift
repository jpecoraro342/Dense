//
//  FoodRowView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplyItemView: View {
    @State var food: FoodViewModel
    @State var quantity: String
    
    var quantityUpdated: (Double) -> Void
    
    init(food: FoodViewModel, quantityUpdated: @escaping (Double) -> Void) {
        self.food = food
        self.quantity = "\(food.quantity)"
        self.quantityUpdated = quantityUpdated
    }
    
    let formatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(light: Color(UIColor.tertiarySystemBackground),
                  dark: Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                VStack(alignment: .leading) {
                    HStack {
                        Text(food.name)
                            .lineLimit(2)
                        Spacer()
                        Text("Quantity:")
                        TextField("0", text: $quantity)
                            .keyboardType(.decimalPad)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .onTapGesture {/* capture tap to prevent keyboard dismiss */}
                            .fixedSize()
                            .onChange(of: quantity) {
                                if let quantity = Double($0) {
                                    food.quantity = quantity
                                    self.quantityUpdated(quantity)
                                }
                            }
                    }
                    Divider()
                    HStack {
                        // TODO: Use the calculator for these
                        Text("\(formatter.string(food.totalCalories*food.quantity) ?? "") Cal")
                        Spacer()
                        Text(formatter.gramsToLbsOz(food.netWeightG*food.quantity))
                        Spacer()
                        Text("\(formatter.string(food.totalCalories/(food.netWeightG*FoodCalculator.gramsToOunces)) ?? "") Cal/Oz")
                    }
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
            ResupplyItemView(food: FoodViewModel(
                productId: UUID().uuidString,
                name: "Fritos",
                netWeightG: 250,
                servingSizeG: 25,
                caloriesPerServing: 140,
                quantity: 1,
                missingInfo: false), quantityUpdated: { print($0) })
        }
    }
}
