//
//  ResupplySummaryView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplySummaryView: View {
    @Binding var resupply : ResupplyViewModel
    
    let formatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(UIColor.systemBackground)
//                .shadow(radius: 3)
            HStack() {
                VStack {
                    Text("Total Calories")
                    Text(formatter.string((FoodCalculator(foodList: resupply.foods).calories())) ?? "")
                }
                Spacer()
                VStack {
                    Text("Total Weight")
                    Text(weightLabel(FoodCalculator(foodList: resupply.foods).weight()))
                }
                Spacer()
                VStack {
                    Text("Calories/Oz")
                    Text(formatter.string((FoodCalculator(foodList: resupply.foods).calories()/FoodCalculator(foodList: resupply.foods).weight())) ?? "")
                }
            }
            .padding()
//            .overlay(Divider(), alignment: .top)
            .overlay(Divider(), alignment: .bottom)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func weightLabel(_ weight: Double) -> String {
        if weight < 16 {
            return "\(formatter.string(weight) ?? "0")oz"
        }
        
        let oz = weight.truncatingRemainder(dividingBy: 16)
        let lbs = (weight - oz)/16
        
        return "\(formatter.string(lbs) ?? "0")lbs \(formatter.string(oz) ?? "0")oz"
    }
}

struct ResupplySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ResupplySummaryView(
            resupply: .constant(ResupplyViewModel(
                resupply: DummyDataStore().resupplies.first!,
                products: DummyDataStore().products)))
    }
}
