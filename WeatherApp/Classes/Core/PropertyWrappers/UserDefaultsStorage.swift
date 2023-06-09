//
//  UserDefaultsStorage.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import Foundation

/// A property wrapper that provides convenient storage and retrieval of a value in UserDefaults.
///
/// Use the `UserDefaultsStorage` property wrapper to store a value in UserDefaults and automatically handle encoding and decoding of the value.
///
/// Example usage:
/// ```
/// @UserDefaultsStorage("myCounter")
/// var counter: Int = 0
///
/// func incrementCounter() {
///     counter += 1
/// }
/// ```
///
/// The above example will store the value of `counter` in UserDefaults with the provided key "myCounter". If no value is found in UserDefaults, the default value of 0 will be used.
///
/// - Note: The value type must conform to `Codable`.
///
/// - Parameters:
///   - key: The key to use for storing the value in UserDefaults.
@propertyWrapper
public struct UserDefaultsStorage<Value> where Value: Codable {
    struct Box<Value>: Codable where Value: Codable {
        let value: Value
    }

    private let defaultValue: Value
    private let key: String
    private let defaults: UserDefaults

    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    public init(wrappedValue: Value, _ key: String, defaults: UserDefaults = .standard) {
        assert(!key.isEmpty, "key should not be empty")
        self.defaultValue = wrappedValue
        self.key = key
        self.defaults = defaults
    }

    public var wrappedValue: Value {
        mutating get {
            if let rawData = defaults.object(forKey: key) as? Data {
                let box = try? decoder.decode(Box<Value>.self, from: rawData)
                return box?.value ?? defaultValue
            }

            return defaultValue
        }
        set {
            if let rawData = try? encoder.encode(Box(value: newValue)) {
                defaults.set(rawData, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
