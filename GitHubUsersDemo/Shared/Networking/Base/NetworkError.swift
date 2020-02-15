//
//  NetworkError.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

/// Network Errors
enum NetworkError: Error {
    case badUrl
    case invalidResponse
}
