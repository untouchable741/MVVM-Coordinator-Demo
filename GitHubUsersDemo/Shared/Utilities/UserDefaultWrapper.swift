//
//  UserDefaultWrapper.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/16/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value: Codable> {
    var key: String
    var defaultValue: Value
    var userDefaults: UserDefaults
    
    public init(key: String, defaultValue: Value, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    public var wrappedValue: Value {
        get {
            guard let data = userDefaults.data(forKey: key) else { return defaultValue }
            do {
                return try JSONDecoder().decode(Value.self, from: data)
            } catch {
                return defaultValue
            }
        }

        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                userDefaults.set(data, forKey: key)
            } catch {
                print("Cannot set \(newValue) into UserDefault")
            }
        }
    }
}
