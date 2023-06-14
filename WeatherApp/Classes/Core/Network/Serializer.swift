//
//  Serializer.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 14.06.2023.
//

import Foundation

protocol Serializer {
    associatedtype Payload
    
    func serialize(payload: Payload) throws -> Data
}

enum SerializerError: Error {
    case serializationFailed
}

final class JSONSerializer<PayloadType: Encodable>: Serializer {
    private lazy var encoder = JSONEncoder()
    
    func serialize(payload: PayloadType) throws -> Data {
        return try encoder.encode(payload)
    }
}

struct StringSerializer: Serializer {
    private let encoding: String.Encoding
    
    init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }
    
    func serialize(payload: String) throws -> Data {
        guard let data = payload.data(using: encoding) else {
            throw SerializerError.serializationFailed
        }
        
        return data
    }
}

struct EmptySerializer: Serializer {
    func serialize(payload: Void) throws -> Data {
        return Data.empty
    }
}
