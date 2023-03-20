//
//  DoubleAdaptable.swift
//  Dense
//
//  Created by Joseph Pecoraro on 3/20/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import Foundation

protocol ExpressibleByDouble {
    init(_ double: Double)
}

extension Double: ExpressibleByDouble {
    init(_ double: Double) {
        self = double
    }
}

extension Optional: ExpressibleByDouble where Wrapped == Double {
    init(_ double: Double) {
        self = double
    }
}

@propertyWrapper
struct DoubleAdaptable<Value: ExpressibleByDouble & Codable>: Codable {
    var wrappedValue: Value
}

extension DoubleAdaptable {
    init(from decoder: Decoder) throws {
        let contaner = try decoder.singleValueContainer()
        
        do {
            let numValue = try contaner.decode(Double.self)
            self.wrappedValue = .init(numValue)
        } catch {
            if let doubleValue = try Double(contaner.decode(String.self)) {
                self.wrappedValue = .init(doubleValue)
            } else {
                throw DecodingError.typeMismatch(Value.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "expected a number or a string that can be converted to a number"))
            }
        }
    }
}

extension DoubleAdaptable {
    func encode(to encoder: Encoder) throws {
        try self.wrappedValue.encode(to: encoder)
    }
}

extension KeyedDecodingContainer {
    func decode<T: ExpressibleByNilLiteral>(_ type: DoubleAdaptable<T>.Type, forKey key: K) throws -> DoubleAdaptable<T> {
        if let value = try self.decodeIfPresent(type, forKey: key) {
            return value
        }
        
        return DoubleAdaptable(wrappedValue: nil)
    }
}
