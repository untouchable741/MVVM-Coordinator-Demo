//
//  UserListViewModel.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class UserListViewModel: RxViewModel {
    enum UserListAction {
        case sentLoadMoreRequest
        case exceedRateLimit
        case receiveEmptyData
    }
    
    /// RxViewModel state publisher
    typealias DataType = UserListAction
    var stateObservable =  BehaviorRelay<ViewModelState<UserListAction>>(value: .idle)
    
    /// Binding data
    @Relay var users: [GitHubUser] = []
    let usersNetworkClient: UsersDataProvider
    var lastLinkHeader: GitHubLinkHeader?
    var disposeBag = DisposeBag()
    var isLoadingMore = false
    
    init(usersNetworkClient: UsersDataProvider = UsersNetworkClient()) {
        self.usersNetworkClient = usersNetworkClient
    }
    
    func fetchInitialPage(isPullRefresh: Bool = false) {
        if isPullRefresh {
            resetData()
        }
        setState(.loading("Loading User List"))
        usersNetworkClient.fetchUsersInitialPage()
            .catchError({ [unowned self] in self.handleError($0)})
            .subscribe(onSuccess: { [weak self] result in
                if result.users.count > 0 {
                    self?.setState(.idle)
                    self?.users = result.users
                    self?.lastLinkHeader = result.linkHeader
                } else {
                    self?.setState(.completed(.receiveEmptyData))
                }
            }).disposed(by: disposeBag)
    }
    
    func loadMore() {
        guard isLoadingMore == false, users.count > 0 else { return }
        guard let linkHeader = lastLinkHeader else { return }
        isLoadingMore = true
        setState(.completed(.sentLoadMoreRequest))
        usersNetworkClient.fetchNextUsersPage(from: linkHeader)
            .catchError({ [unowned self] in self.handleError($0)})
            .subscribe(onSuccess: { [weak self] result in
                self?.setState(.idle)
                self?.lastLinkHeader = result.linkHeader
                self?.isLoadingMore = false
                self?.users.append(contentsOf: result.users)
            }).disposed(by: disposeBag)
    }
    
    func handleError<E>(_ error: Error) -> PrimitiveSequence<MaybeTrait, E> {
        switch error {
        case NetworkError.serverResponse(let code, _):
            if code == 403 {
                setState(.completed(.exceedRateLimit))
            } else {
                setState(.error(error))
            }
        default:
            setState(.error(error))
        }
        return Maybe.empty()
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
    
    func resetData() {
        users = []
        setState(.idle)
    }
    
    func user(at index: Int) -> GitHubUser? {
        guard 0..<users.count ~= index else { return nil }
        return users[index]
    }
}
