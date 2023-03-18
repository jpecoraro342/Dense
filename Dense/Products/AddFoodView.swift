//
//  AddFoodView.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) var dismiss
    
    let dataStore : ProductDataStore
    
    @State var name = ""
    @State var caloriesPerServing = ""
    @State var numberOfServings = ""
    @State var servingSizeG = ""
    @State var netWtG = ""
    
    @State var product: Product?
    
    var action: (Product?) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                BarcodeButtonPrompt { barcode in
                    Task {
                        if let product = await dataStore.getProduct(barcode: barcode) {
                            self.product = product
                            updateStateWithProduct()
                        } else {
                            // TODO:
                            print("unable to retrieve food from barcode")
                        }
                    }
                }
                .padding(.top)
                
//                ProgressView()
//                    .padding(.bottom)
                
                inputFields
                
                Text("If barcode data is incomplete or incorrect, you can help update it for everyone at [Open Food Facts](https://world.openfoodfacts.org/help-complete-products) or by using the [Open Food Facts App](https://apps.apple.com/us/app/open-food-facts-product-scan/id588797948)")
            }
            .padding()
        }
        .ignoresSafeArea(edges: .bottom)
        .onTapGesture {
            dismissKeyboard()
        }
    }
    
    var inputFields: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .onTapGesture {/* capture tap to prevent keyboard dismiss */}
            TextField("Calories Per Serving", text: $caloriesPerServing)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .onTapGesture {/* capture tap to prevent keyboard dismiss */}
            TextField("Number of Servings", text: $numberOfServings)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .onTapGesture {/* capture tap to prevent keyboard dismiss */}
            HStack {
                TextField("Serving Size (g)", text: $servingSizeG)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .onTapGesture {/* capture tap to prevent keyboard dismiss */}
                Text("or")
                TextField("Net Wt (g)", text: $netWtG)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .onTapGesture {/* capture tap to prevent keyboard dismiss */}
            }
            
            HStack(alignment: .center, spacing: 20) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                Button("Add Food") {
                    Task {
                        await addFood()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
    
    func addFood() async {
        if var product = product {
            product.updateWith(name: name,
                               caloriesPerServing: caloriesPerServing,
                               numberOfServings: numberOfServings,
                               servingSizeG: servingSizeG,
                               netWtG: netWtG)
            await dataStore.putProduct(product)
            action(product)
        } else {
            let product = Product(name: name,
                                  caloriesPerServing: caloriesPerServing,
                                  numberOfServings: numberOfServings,
                                  servingSizeG: servingSizeG,
                                  netWtG: netWtG)
            await dataStore.putProduct(product)
            action(product)
        }
        
        dismiss()
    }
    
    func updateStateWithProduct() {
        name = product?.productName ?? name
        // TODO: Use a view model and format appropriately
        if let calories = product?.nutriments.energyKcalServing {
            caloriesPerServing = "\(calories)"
        }
        
        guard let netWtG = product?.productQuantity else { return }
        self.netWtG = netWtG
        
        guard let servingSizeG = product?.servingQuantity else { return }
        
        let numberOfServings = (Double(netWtG) ?? 0) / (Double(servingSizeG) ?? 0)
        if numberOfServings != 0 {
            self.numberOfServings = "\(numberOfServings)"
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView(dataStore: DummyDataStore()) { food in
        }
    }
}
