//
//  ResupplyDaySummary.swift
//  Dense
//
//  Created by Joseph Pecoraro on 4/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplyDaySummary: View {
    @Binding var resupply : ResupplyViewModel
    
    @State var isExpanded = false
    
    @State var caloriesPerDay = ""
    @State var targetDays = ""
    
    let formatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(UIColor.systemBackground)
            VStack(spacing: 5) {
                VStack(spacing: 5) {
                    HStack {
                        Text("Days of Food: ")
                        Text(formatter.string(FoodCalculator(foodList: resupply.foods).daysOfFood(caloriesPerDay: Double(caloriesPerDay) ?? 3500.0)))
                        Spacer()
                        Text(isExpanded ? "\(Image(systemName: "chevron.up"))" : "\(Image(systemName: "chevron.down"))")
                            .padding(.trailing, 10)
                            .foregroundColor(Color(.placeholderText))
                            .fontWeight(.bold)
                    }
                    HStack(alignment: .center) {
                        Text("Calories Needed: ")
                        Text(formatter.string(FoodCalculator(foodList: resupply.foods).caloriesNeeded(caloriesPerDay: Double(caloriesPerDay) ?? 3500.0, numberOfDays: Double(targetDays) ?? 4.5)))
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
                .onTapGesture {
                    isExpanded.toggle()
                }
                if isExpanded {
                    Divider()
                    HStack {
                        Text("Target Days:")
                        TextField("4.5", text: $targetDays)
                            .keyboardType(.decimalPad)
                            .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                            .multilineTextAlignment(.center)
                            .fixedSize()
                            .onChange(of: targetDays) { targetDays in
                                // TODO: Save to NSUserDefaults
                            }
                            .onTapGesture {/* capture tap to prevent keyboard dismiss */}
                        Spacer()
                        Text("Calories/Day:")
                        TextField("3500.0", text: $caloriesPerDay)
                            .keyboardType(.decimalPad)
                            .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                            .multilineTextAlignment(.center)
                            .fixedSize()
                            .onChange(of: caloriesPerDay) { caloriesPerDay in
                                // TODO: Save to NSUserDefaults
                            }
                            .onTapGesture {/* capture tap to prevent keyboard dismiss */}
                    }
                }
                // TODO: Handle cals/day change
            }
            .padding()
            .overlay(Divider(), alignment: .top)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ResupplyDaySummary_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ResupplyDaySummary(
                resupply: .constant(ResupplyViewModel(
                    resupply: DummyDataStore().resupplies.first!,
                    products: DummyDataStore().products)),
            isExpanded: true)
            ResupplyDaySummary(
                resupply: .constant(ResupplyViewModel(
                    resupply: DummyDataStore().resupplies.first!,
                    products: DummyDataStore().products)),
            isExpanded: false)
        }
    }
}
