protocol ExpressibleByString {
    init(_ string: String)
}

extension String: ExpressibleByString {
    init(_ string: String) {
        self = string
    }
}

extension Optional: ExpressibleByString where Wrapped == String {
    init(_ string: String) {
        self = string
    }
}

@propertyWrapper
struct StringAdaptable<Value: ExpressibleByString & Codable>: Codable {
    var wrappedValue: Value
}

extension StringAdaptable {
    init(from decoder: Decoder) throws {
        let contaner = try decoder.singleValueContainer()
        
        do {
            let numValue = try contaner.decode(Double.self)
            self.wrappedValue = .init(numValue.description)
        } catch {
            let stringValue = try contaner.decode(String.self)
            self.wrappedValue = .init(stringValue)
        }
    }
}

extension StringAdaptable {
    func encode(to encoder: Encoder) throws {
        try self.wrappedValue.encode(to: encoder)
    }
}

extension KeyedDecodingContainer {
    func decode<T: ExpressibleByNilLiteral>(_ type: StringAdaptable<T>.Type, forKey key: K) throws -> StringAdaptable<T> {
        if let value = try self.decodeIfPresent(type, forKey: key) {
            return value
        }
        
        return StringAdaptable(wrappedValue: nil)
    }
}
