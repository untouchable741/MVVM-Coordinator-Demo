//
//  RelayWrapper.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import RxRelay

@propertyWrapper
struct Relay<Value> {
    var relay: BehaviorRelay<Value>
    
    init(wrappedValue: Value) {
        relay = BehaviorRelay<Value>(value: wrappedValue)
    }
    
    var wrappedValue: Value {
        get {
            return relay.value
        }
        
        set {
            relay.accept(newValue)
        }
    }
    
    var projectedValue: BehaviorRelay<Value> {
        return relay
    }
}

