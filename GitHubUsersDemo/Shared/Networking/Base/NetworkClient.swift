//
//  NetworkClient.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

/// Implementation of NetworkDataProvider
class NetworkClient: NetworkDataProvider {
    func get(urlString: String, queryItems: [String : Any]) -> Single<Any?> {
        return request(.get, urlString: urlString, queries: queryItems)
    }
    
    func request(_ method: Alamofire.HTTPMethod, urlString: String, queries: [String: Any]? = nil, body: [String: Any]? = nil, headers: HTTPHeaders? = nil) -> Single<Any?> {
        guard let url = URL(string: urlString) else {
            return Single.error(NetworkError.badUrl)
        }
        return Single.create { single -> Disposable in
            let urlEncoding = GitHubRequestEncoding(queries: queries, body: body, headers: headers)
            let request = Alamofire.request(url, method: method, encoding: urlEncoding)
                .validate(statusCode: 200..<300)
                .responseData(completionHandler: { dataResponse in
                    if let error = dataResponse.error {
                        return single(.error(error))
                    } else {
                        return single(.success(dataResponse))
                    }
            })
            request.resume()
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
