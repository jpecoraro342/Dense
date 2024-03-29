//
//  MultiSelectFoodView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 5/1/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

// Should I update everytime something is selected, or only at the end?
// If at the end, I can add a completion block
struct MultiSelectFoodView: View {
    @Environment(\.dismiss) var dismiss
    
    let dataStore : ProductDataStore
    
    // TODO: Use a selected product view model
    @State var selectedProducts : [String:Bool]
    @State var products : [Product] = []
    
    var productUpdated: (String, Bool) -> Void
    
    // TODO: Add a done/cancel button
    // TODO: Debounce saving
    
    var body: some View {
        List {
            if (products.isEmpty) {
                Text("No foods to show. Get started by adding foods, then use multiselect to quickly make large changes.")
                    .listRowSeparator(.hidden)
            }
            ForEach(products.indices, id: \.self) { index in
                HStack {
                    // TODO: Make a version of grams to lbsoz that takes a string
                    Text("\(products[index].productName) - \(NumberFormatter.decimalFormatter().gramsToLbsOz(Double(products[index].productQuantity ?? "") ?? 0))")
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Spacer()
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.accentColor)
                        .opacity(selectedProducts[products[index].code, default: false] ? 1.0 : 0.0)
                }
                .frame(minHeight: 40.0)
                .contentShape(Rectangle())
                .onTapGesture {
                    let product = products[index];
                    let selected = !selectedProducts[products[index].code, default: false]
                    selectedProducts[product.code] = selected
                    productUpdated(product.code, selected)
                    
                    Analytics.shared.logEvent(.multiselectProductTapped, location: "multiselect", extras: ["id": product.code, "selected": "\(selected)"])
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Select Foods")
        .task {
            products = await dataStore.getProducts()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    Analytics.shared.logEvent(.multiselectDismissTapped)
                    dismiss()
                }
            }
        }
    }
}

struct MultiSelectFoodView_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectFoodView(
            dataStore: DummyDataStore(), selectedProducts: ["2" : true], productUpdated: {_,_  in })
        MultiSelectFoodView(
            dataStore: DummyDataStore(products: [], resupplies: []), selectedProducts: [:], productUpdated: {_,_  in })
    }
}
