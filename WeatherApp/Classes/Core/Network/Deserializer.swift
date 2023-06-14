//
//  Deserializer.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 13.06.2023.
//

import Foundation

enum DeserializerError: Error {
    case deserializationFailed
}

protocol Deserializer {
    associatedtype Response
    
    func deserialize(data: Data) throws -> Response
}

final class JSONDeserializer<ResponseType: Decodable>: Deserializer {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func deserialize(data: Data) throws -> ResponseType {
        return try decoder.decode(Response.self, from: data)
    }
}

struct StringDeserializer: Deserializer {
    private let encoding: String.Encoding
    
    init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }
    
    func deserialize(data: Data) throws -> String {
        guard let string = String(data: data, encoding: encoding) else {
            throw DeserializerError.deserializationFailed
        }
        
        return string
    }
}

struct EmptyDeserializer: Deserializer {
    func deserialize(data: Data) throws -> Void {
        return ()
    }
}
