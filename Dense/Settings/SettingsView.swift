//
//  SettingsView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 5/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State var dataStore : ResupplyDataStore & ProductDataStore
    @AppStorage("analyticsEnabled") var analyticsEnabled : Bool = true
    
    var body: some View {
        List {
            Section("Settings") {
                analyticsToggle
            }
            
            Section("Debug Information") {
                exportDataButton
            }
        }
    }
    
    var analyticsToggle: some View {
        VStack {
            Toggle("Enable Usage Analytics", isOn: $analyticsEnabled)
                .onChange(of: analyticsEnabled) { analyticsEnabled in
                    if analyticsEnabled {
                        Analytics.shared.start()
                    } else {
                        Analytics.shared.stop()
                    }
                }
            Text("Dense only collects basic usage data to help improve the app, and will never share your data with third parties. See our privacy policy for more info")
                .multilineTextAlignment(.leading)
                .font(Font.footnote)
        }
    }
    
    var exportDataButton: some View {
        ShareLink(items: FileDataStore.debugData()) {
            Label("Export Data", systemImage: "square.and.arrow.up").frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dataStore: DummyDataStore())
    }
}
