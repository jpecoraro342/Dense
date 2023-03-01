//
//  ResupplySummaryView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct ResupplySummaryView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Color(.white)
//                .shadow(radius: 3)
            HStack() {
                VStack {
                    Text("Total Calories")
                }
                Spacer()
                VStack {
                    Text("Total Weight")
                }
                Spacer()
                VStack {
                    Text("Calories/Oz")
                }
            }
            .padding()
//            .overlay(Divider(), alignment: .top)
            .overlay(Divider(), alignment: .bottom)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ResupplySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ResupplySummaryView()
    }
}
