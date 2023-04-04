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
//                .shadow(color: Color(
//                    light: Color(.sRGBLinear, white: 0, opacity: 0.25),
//                    dark: Color(.sRGBLinear, white: 0.3, opacity: 0.4)
//                ), radius: 2)
            HStack() {
                VStack {
                    Text("Total Calories")
                    Text(formatter.string(FoodCalculator(foodList: resupply.foods).calories()))
                }
                Spacer()
                VStack {
                    Text("Total Weight")
                    Text(formatter.lbsOz(FoodCalculator(foodList: resupply.foods).weight()))
                }
                Spacer()
                VStack {
                    Text("Calories/Oz")
                    Text(formatter.string(
                        FoodCalculator(foodList: resupply.foods).calories()/FoodCalculator(foodList: resupply.foods).weight()))
                }
            }
            .padding()
            .overlay(Divider(), alignment: .bottom)
        }
        .fixedSize(horizontal: false, vertical: true)
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
