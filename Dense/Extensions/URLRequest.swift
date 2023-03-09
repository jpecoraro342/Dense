//
//  URLRequest.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

enum HTTPHeader : String {
    case userAgent = "User-Agent"
}

extension URLRequest {
    mutating func setValue(_ value: String?, forHTTPHeader header: HTTPHeader) {
        self.setValue(value, forHTTPHeaderField: header.rawValue)
    }
}
