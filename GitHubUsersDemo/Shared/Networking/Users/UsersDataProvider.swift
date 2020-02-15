//
//  UsersDataProvider.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import RxSwift

protocol UsersDataProvider {
    func fetchUsersInitialPage() -> Single<[GitHubUser]>
}

