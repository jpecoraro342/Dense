//
//  OpenFoodFactsApi.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

class OpenFoodFactsAPI : NSObject {
    public static let shared = OpenFoodFactsAPI()
    
    private static let baseUrl = "https://world.openfoodfacts.org/api/v2/search"
    
    private let userAgentHeader = {
        return "\(Bundle.main.appName) - iOS - Version \(Bundle.main.appVersionLong).\(Bundle.main.appBuild) - https://github.com/jpecoraro342/Dense"
    }
    
    private override init() { }

    private func urlForBarcode(barcode: String) -> URL? {
        var urlBuilder = URLComponents(string: Self.baseUrl)
        
        urlBuilder?.queryItems = [
            URLQueryItem(name: "code", value: barcode),
            URLQueryItem(name: "fields", value: Product.fields())
        ]
        
        return urlBuilder?.url
    }

    func getProduct(fromBarcode barcode: String) async -> Product? {
        guard let url = urlForBarcode(barcode: barcode) else {
            print("error building url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(userAgentHeader(), forHTTPHeader: .userAgent)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let paginatedProducts = try decoder.decode(PaginatedProducts.self, from: data)
            return paginatedProducts.products.first
        }
        catch {
            print("error: \(error)")
        }
        
        return nil
    }
}
