//
//  CoordinatorView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct CoordinatorView: View {
    @State var initialView = ResupplyView(resupply: ResupplyViewModel(), dataStore: FileDataStore())
    
    var body: some View {
        NavigationView {
            initialView
        }
    }
}
