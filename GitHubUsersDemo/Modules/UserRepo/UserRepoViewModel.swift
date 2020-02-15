//
//  UserRepoViewModel.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

class UserRepoViewModel {
    @Relay var userRepoUrl: URL?
    @Relay var username: String?
    
    let user: GitHubUser

    init(user: GitHubUser) {
        self.user = user
        bind()
    }
    
    deinit {
        print("Deinit \(type(of: self))")
    }

    func bind() {
        guard let urlString = user.url else { return }
        userRepoUrl = URL(string: urlString)
        username = user.login
    }
}
