//
//  RequestEncoding.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import Alamofire

struct GitHubRequestEncoding: ParameterEncoding {
    private let queries: Parameters?
    private let body: Parameters?
    private let headers: HTTPHeaders?
    
    init(queries: Parameters? = nil, body: Parameters? = nil, headers: HTTPHeaders? = nil) {
        self.queries = queries
        self.body = body
        self.headers = headers
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        let originRequest = try urlRequest.asURLRequest()
        
        // Queries
        var request = try URLEncoding.init(destination: .queryString, arrayEncoding: .brackets, boolEncoding: .literal).encode(originRequest, with: queries)
        
        // Body
        request = try JSONEncoding().encode(request, with: body)
        
        // Headers
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        return request
    }
}
