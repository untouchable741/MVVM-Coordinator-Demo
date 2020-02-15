//
//  NetworkDataProvider.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import RxSwift

/// Protocol defined standard RESTful request interface (GET - POST - PUT - DELETE)
protocol NetworkDataProvider {
    func get(urlString: String, queryItems: [String: Any]) -> Single<Any?>
}

/// Extends to provide default parameters as protocol does not support default params
extension NetworkDataProvider {
    func get(urlString: String, queryItems: [String: Any] = [:]) -> Single<Any?> {
        return get(urlString: urlString, queryItems: [:])
    }
}
