//
//  CoordinatorView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct CoordinatorView: View {
    @State var initialView = ResupplyView(dataAccessor: PListFoodDataAccessor())
    
    var body: some View {
        NavigationView {
            initialView
        }
    }
}
