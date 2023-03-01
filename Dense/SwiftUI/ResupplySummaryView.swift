//
//  ResupplySummaryView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplySummaryView: View {
    var food : [FoodItem]
    
    let formatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(.white)
//                .shadow(radius: 3)
            HStack() {
                VStack {
                    Text("Total Calories")
                    Text(formatter.string(from: (FoodCalculator(foodList: food).calories())) ?? "")
                }
                Spacer()
                VStack {
                    Text("Total Weight")
                    Text(weightLabel(FoodCalculator(foodList: food).weight()))
                }
                Spacer()
                VStack {
                    Text("Calories/Oz")
                    Text(formatter.string(from: (FoodCalculator(foodList: food).calories()/FoodCalculator(foodList: food).weight())) ?? "")
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
            return "\(formatter.string(from: weight) ?? "0")oz"
        }
        
        let oz = weight.truncatingRemainder(dividingBy: 16)
        let lbs = (weight - oz)/16
        
        return "\(formatter.string(from: lbs) ?? "0")lbs \(formatter.string(from: oz) ?? "0")oz"
    }
}

struct ResupplySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ResupplySummaryView(food: DummyFoodDataAccessor().food)
    }
}
