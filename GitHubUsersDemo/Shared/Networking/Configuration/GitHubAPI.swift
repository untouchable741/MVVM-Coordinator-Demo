//
//  GitHubAPI.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

/// All GitHub APIs
enum GitHubAPI {
    case users
    case userRepos(String)
    
    var apiPath: String {
        switch self {
        case .users:
            return "/users"
        case .userRepos(let userId):
            return #"/users/\#(userId)/repos"#
        }
    }
    
    var urlString: String {
        return APIEndpoint.fullUrlString(for: self)
    }
}

/// Endpoint construction
struct APIEndpoint {
    static let endpoint = "https://api.github.com"
    static let apiPath = ""
    /// GitHub Auth token to increase the API rate limit
    /// Will be used only if not empty
    static let token = ""
    
    static func fullUrlString(for api: GitHubAPI) -> String {
        return #"\#(endpoint)\#(api.apiPath)"#
    }
}
