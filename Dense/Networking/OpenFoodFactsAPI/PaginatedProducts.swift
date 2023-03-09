//
//  Food.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/2/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

struct PaginatedProducts {
    var count: Int
    var page: Int
    var pageCount: Int
    var pageSize: Int
    var products: [Product]
}

extension PaginatedProducts : Codable {}
