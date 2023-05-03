//
//  FileManager.swift
//  Dense
//
//  Created by Joseph Pecoraro on 5/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension FileManager {
    static func filePath(_ filePath: String) -> URL? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentsDirectory.appendingPathComponent(filePath)
        }
        
        return nil
    }
}
