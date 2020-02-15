//
//  UsersNetworkClient.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class UsersNetworkClient: UsersDataProvider {
    let networkClient: NetworkDataProvider
    
    init(networkClient: NetworkDataProvider = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchUsersInitialPage() -> Single<[GitHubUser]> {
        let usersAPIString = GitHubAPI.users.urlString
        return networkClient.get(urlString: usersAPIString).map { dataResponse in
            guard let response = dataResponse as? DataResponse<Data>,
                let data = response.data else {
                    throw NetworkError.badUrl
            }
            return try JSONDecoder().decode([GitHubUser].self, from: data)
        }
    }
}
