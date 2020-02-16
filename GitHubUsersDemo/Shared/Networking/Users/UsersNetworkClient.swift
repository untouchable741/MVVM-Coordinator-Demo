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
    
    func fetchUsersInitialPage() -> Maybe<UsersListResponse> {
        return fetchUserPage(with: GitHubAPI.users.urlString)
    }
    
    func fetchNextUsersPage(from linkHeader: GitHubLinkHeader) -> Maybe<UsersListResponse> {
        return fetchUserPage(with: linkHeader.nextLink)
    }
}

fileprivate extension UsersNetworkClient {
    func fetchUserPage(with urlString: String?) -> Maybe<UsersListResponse> {
        guard let urlString = urlString else {
            return Maybe.error(NetworkError.badUrl)
        }
        
        return networkClient.get(urlString: urlString).map { dataResponse in
            guard let response = dataResponse as? DataResponse<Data>,
                let data = response.data else {
                    throw NetworkError.badUrl
            }
            let users = try JSONDecoder().decode([GitHubUser].self, from: data)
            let linkHeader = GitHubLinkParser.parseGitHubLinkHeader(response.response?.allHeaderFields["Link"] as? String)
            return (users, linkHeader)
        }
    }
}
