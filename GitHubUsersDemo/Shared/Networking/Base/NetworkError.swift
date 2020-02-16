//
//  NetworkError.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

/// Network Errors
enum NetworkError: Error, LocalizedError {
    case badUrl
    case invalidResponse
    case serverResponse(code: Int?, message: String?)
    
    var errorDescription: String? {
        switch self {
        case .badUrl:
            return "Invalid request URL"
        case .invalidResponse:
            return "Invalid response"
        case .serverResponse(let code, let message):
            return "\(message) (\(code))"
        }
    }
}
