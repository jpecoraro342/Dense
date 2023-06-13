//
//  JSONEncoder.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension JSONEncoder {
    func writeToFile(object: Encodable, filePath: String) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let url = documentsDirectory.appendingPathComponent(filePath)
                let data = try self.encode(object)
                try data.write(to: url)
            } catch {
                Analytics.shared.logEvent(.errorWritingToFile, extras: ["error" : error.localizedDescription])
            }
        }
    }
}
