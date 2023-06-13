//
//  JSONDecoder.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func readFromFile<T: Decodable>(filePath: String) -> T? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let url = documentsDirectory.appendingPathComponent(filePath)
                let data = try Data(contentsOf: url)
                let jsonData = try self.decode(T.self, from: data)
                return jsonData
            } catch {
                Analytics.shared.logEvent(.errorReadingFromFile, extras: ["error" : error.localizedDescription])
            }
        }
        
        return nil
    }
}
