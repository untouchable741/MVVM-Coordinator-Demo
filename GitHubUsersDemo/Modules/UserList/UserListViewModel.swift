//
//  UserListViewModel.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import RxSwift

class UserListViewModel {
    @Relay var users: [GitHubUser] = []
    let usersNetworkClient: UsersDataProvider
    var lastLinkHeader: GitHubLinkHeader?
    var disposeBag = DisposeBag()
    var isLoadingMore = false
    
    init(usersNetworkClient: UsersDataProvider = UsersNetworkClient()) {
        self.usersNetworkClient = usersNetworkClient
    }
    
    func fetchInitialPage() {
        usersNetworkClient.fetchUsersInitialPage()
            .subscribe(onSuccess: { [weak self] (result) in
                self?.users = result.users
                self?.lastLinkHeader = result.linkHeader
            }).disposed(by: disposeBag)
    }
    
    func loadMore() {
        guard isLoadingMore == false else { return }
        guard let linkHeader = lastLinkHeader else { return }
        isLoadingMore = true
        usersNetworkClient.fetchNextUsersPage(from: linkHeader).subscribe(onSuccess: { [weak self] result in
            self?.lastLinkHeader = result.linkHeader
            self?.isLoadingMore = false
            self?.users.append(contentsOf: result.users)
        }).disposed(by: disposeBag)
    }
    
    func toggleFavorite(on user: GitHubUser?) {
        guard let user = user else { return }
        let userIndex = users.firstIndex(where: { $0.id == user.id })
        if let index = userIndex {
            var updatedUser = user
            updatedUser.isFavourited.toggle()
            users[index] = updatedUser
        }
    }
    
    func user(at index: Int) -> GitHubUser? {
        guard 0..<users.count ~= index else { return nil }
        return users[index]
    }
}
