//
//  NSError.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/24/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

extension NSError {
    public convenience init(domain: String, code: NSInteger, localizedDescription: String) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
    public convenience init(localizedDescription: String) {
        self.init(domain: "com.dense.error", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
    public convenience init(error: Error) {
        self.init(domain: String(describing: error.self), code: 0, localizedDescription: error.localizedDescription)
    }
}
