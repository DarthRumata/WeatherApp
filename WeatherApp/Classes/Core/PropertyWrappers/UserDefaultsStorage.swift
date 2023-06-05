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
/// @UserDefaultsStorage(defaultValue: 0, "myCounter")
/// var counter: Int
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
///   - defaultValue: The default value to use if no value is found in UserDefaults.
///   - key: The key to use for storing the value in UserDefaults.
@propertyWrapper
public struct UserDefaultsStorage<Value> where Value: Codable {
    struct Wrapper<Value>: Codable where Value: Codable {
        let wrapped: Value
    }

    let defaultValue: Value
    let key: String

    var currentValue: Value?

    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    public init(defaultValue value: Value, _ key: String) {
        assert(!key.isEmpty, "key should not be empty")
        self.defaultValue = value
        self.key = key
    }

    public var wrappedValue: Value {
        mutating get {
            if let currentValue = currentValue {
                return currentValue
            }

            if let rawData = UserDefaults.standard.object(forKey: key) as? Data {
                let wrappedValue = try? decoder.decode(Wrapper<Value>.self, from: rawData)
                self.currentValue = wrappedValue?.wrapped
                return currentValue ?? self.defaultValue
            }

            return self.defaultValue
        }
        set {
            if let rawData = try? encoder.encode(Wrapper(wrapped: newValue)) {
                let wrappedValue = try? decoder.decode(Wrapper<Value>.self, from: rawData)
                self.currentValue = wrappedValue?.wrapped
                UserDefaults.standard.set(rawData, forKey: key)
            } else {
                self.currentValue = wrappedValue
            }
        }
    }
}
