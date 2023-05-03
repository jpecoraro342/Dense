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
    
    @State var isLoadingBarcode = false
    @State var error : String? = nil
    
    var action: (Product?) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                BarcodeButtonPrompt { barcode in
                    Task {
                        isLoadingBarcode = true
                        let (product, error) = await dataStore.getProduct(barcode: barcode)
                        
                        if let product = product {
                            self.product = product
                            updateStateWithProduct()
                        } else {
                            print("unable to retrieve food from barcode")
                        }
                        
                        self.error = error?.localizedDescription
                        isLoadingBarcode = false
                    }
                }
                .padding(.top)
                
                if let error = error {
                    Text(error)
                }
                
                if (isLoadingBarcode) {
                    ProgressView()
                        .padding(.bottom)
                }

                
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
            FloatingTextField("Name", text: $name)
                .autocorrectionDisabled()
            FloatingTextField("Calories Per Serving", text: $caloriesPerServing)
                .keyboardType(.decimalPad)
            FloatingTextField("Number of Servings", text: $numberOfServings)
                .keyboardType(.decimalPad)
            HStack {
                FloatingTextField("Serving Size (g)", text: $servingSizeG)
                    .keyboardType(.decimalPad)
                Text("or")
                FloatingTextField("Net Wt (g)", text: $netWtG)
                    .keyboardType(.decimalPad)
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
        
        
        if let netWtG = product?.productQuantity {
            self.netWtG = netWtG
        }
        
        if let servingSizeG = product?.servingQuantity {
            self.servingSizeG = servingSizeG
        }
        
        guard let netWtG = product?.productQuantity, let servingSizeG = product?.servingQuantity else { return }
        
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
