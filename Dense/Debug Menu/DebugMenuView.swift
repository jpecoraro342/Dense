//
//  DebugMenuView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 5/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct DebugMenuView: View {
    @State var dataStore : ResupplyDataStore & ProductDataStore
    
    var body: some View {
        List {
            exportDataButton
        }
    }
    
    var exportDataButton: some View {
        ShareLink(items: FileDataStore.debugData()) {
            Label("Export Data", systemImage: "square.and.arrow.up").frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct DebugMenuView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuView(dataStore: DummyDataStore())
    }
}
