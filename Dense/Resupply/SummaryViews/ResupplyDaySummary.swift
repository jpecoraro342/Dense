//
//  ResupplyDaySummary.swift
//  Dense
//
//  Created by Joseph Pecoraro on 4/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplyDaySummary: View {
    private enum Field: Int, Hashable {
        case targetDays, caloriesPerDay
    }
    
    @Binding var resupply : ResupplyViewModel
    
    @State var isExpanded : Bool
    
    @State var caloriesPerDay : String
    @State var targetDays : String
    
    @FocusState private var focusedField : Field?
    
    var caloriesPerDayUpdated: (Double) -> Void
    var targetDaysUpdated: (Double) -> Void
    
    init(resupply: Binding<ResupplyViewModel>, isExpanded: Bool = false, caloriesPerDayUpdated: @escaping (Double) -> Void, targetDaysUpdated: @escaping (Double) -> Void) {
        _resupply = resupply
        _isExpanded = State(initialValue: isExpanded)
        _caloriesPerDay = State(initialValue: formatter.string(resupply.wrappedValue.caloriesPerDay))
        _targetDays = State(initialValue: formatter.string(resupply.wrappedValue.targetNumberOfDays))
        self.caloriesPerDayUpdated = caloriesPerDayUpdated
        self.targetDaysUpdated = targetDaysUpdated
    }
    
    let formatter = NumberFormatter.decimalFormatter()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(UIColor.systemBackground)
            DisclosureGroup(isExpanded: $isExpanded) {
                Divider()
                HStack {
                    Text("Target Days:")
                        .onTapGesture {
                            focusedField = .targetDays
                        }
                    TextField("", value: $resupply.targetNumberOfDays, formatter: formatter)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .targetDays)
                        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                        .multilineTextAlignment(.center)
                        .fixedSize()
                        .onChange(of: $resupply.wrappedValue.targetNumberOfDays) { targetDays in
                            self.targetDaysUpdated(targetDays)
                        }
                        .onTapGesture {/* capture tap to prevent keyboard dismiss */}
                    Spacer()
                    Text("Calories/Day:")
                        .onTapGesture {
                            focusedField = .caloriesPerDay
                        }
                    TextField("", value: $resupply.caloriesPerDay, formatter: formatter)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .caloriesPerDay)
                        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                        .multilineTextAlignment(.center)
                        .fixedSize()
                        .onChange(of: $resupply.wrappedValue.caloriesPerDay) { caloriesPerDay in
                            self.caloriesPerDayUpdated(caloriesPerDay)
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
