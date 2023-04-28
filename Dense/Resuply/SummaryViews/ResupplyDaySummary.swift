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
    
    @State var isExpanded : Bool
    
    @State var caloriesPerDay : String
    @State var targetDays : String
    
    var caloriesPerDayUpdated: (Double) -> Void
    var targetDaysUpdated: (Double) -> Void
    
    init(resupply: Binding<ResupplyViewModel>, isExpanded: Bool = false, caloriesPerDayUpdated: @escaping (Double) -> Void, targetDaysUpdated: @escaping (Double) -> Void) {
        _resupply = resupply
        _isExpanded = State(initialValue: isExpanded)
        _caloriesPerDay = State(initialValue: formatter.string(resupply.wrappedValue.caloriesPerDay))
        _targetDays = State(initialValue: formatter.string(resupply.wrappedValue.targetNumberOfDays))
        self.caloriesPerDayUpdated = caloriesPerDayUpdated
        self.targetDaysUpdated = targetDaysUpdated
        print(self.isExpanded)
        print(self.caloriesPerDay)
        print(self.targetDays)
    }
    
    let formatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(UIColor.systemBackground)
            DisclosureGroup(isExpanded: $isExpanded) {
                Divider()
                HStack {
                    Text("Target Days:")
                    TextField("", text: $targetDays)
                        .keyboardType(.decimalPad)
                        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                        .multilineTextAlignment(.center)
                        .fixedSize()
                        .onChange(of: targetDays) { targetDays in
                            if let targetDays = Double(targetDays) {
                                self.targetDaysUpdated(targetDays)
                            }
                        }
                        .onAppear {
                            self.targetDays = self.targetDays
                        }
                        .onTapGesture {/* capture tap to prevent keyboard dismiss */}
                    Spacer()
                    Text("Calories/Day:")
                    TextField("", text: $caloriesPerDay)
                        .keyboardType(.decimalPad)
                        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                        .multilineTextAlignment(.center)
                        .fixedSize()
                        .onChange(of: caloriesPerDay) { caloriesPerDay in
                            if let caloriesPerDay = Double(caloriesPerDay) {
                                self.caloriesPerDayUpdated(caloriesPerDay)
                            }
                        }
                        .onAppear {
                            self.caloriesPerDay = self.caloriesPerDay
                        }
                        .onTapGesture {/* capture tap to prevent keyboard dismiss */}
                }
            } label: {
                VStack(spacing: 5) {
                    HStack {
                        Text("Days of Food: ")
                        Text(formatter.string(FoodCalculator(foodList: resupply.foods).daysOfFood(caloriesPerDay: resupply.caloriesPerDay)))
                        Spacer()
                    }
                    HStack(alignment: .center) {
                        Text("Calories Needed: ")
                        Text(formatter.string(FoodCalculator(foodList: resupply.foods).caloriesNeeded(caloriesPerDay: resupply.caloriesPerDay, numberOfDays: resupply.targetNumberOfDays)))
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
                .tint(Color(.label))
            }
            .tint(Color(.placeholderText))
            .padding()
            .overlay(Divider(), alignment: .top)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ResupplyDaySummary_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ResupplyDaySummary(resupply: .constant(ResupplyViewModel(
                resupply: DummyDataStore().resupplies.first!,
                products: DummyDataStore().products)),
                               isExpanded: true,
                               caloriesPerDayUpdated: { print($0) },
                               targetDaysUpdated: { print($0) })
            ResupplyDaySummary(resupply: .constant(ResupplyViewModel(
                resupply: DummyDataStore().resupplies.first!,
                products: DummyDataStore().products)),
                               isExpanded: false,
                               caloriesPerDayUpdated: { print($0) },
                               targetDaysUpdated: { print($0) })
        }
    }
}
