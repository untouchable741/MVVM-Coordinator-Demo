//
//  UsersDataProvider.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import RxSwift

typealias UsersListResponse = (users: [GitHubUser], linkHeader: GitHubLinkHeader)

protocol UsersDataProvider {
    func fetchUsersInitialPage() -> Maybe<UsersListResponse>
    func fetchNextUsersPage(from linkHeader: GitHubLinkHeader) -> Maybe<UsersListResponse>
}

