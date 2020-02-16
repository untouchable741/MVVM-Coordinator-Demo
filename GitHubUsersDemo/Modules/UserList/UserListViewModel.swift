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
    let dataPersistor: DataPersistor
    var lastLinkHeader: GitHubLinkHeader?
    var disposeBag = DisposeBag()
    var isLoadingMore = false
    var favouritesUserIds: [Int] = []
    
    init(usersNetworkClient: UsersDataProvider = UsersNetworkClient(),
         dataPersistor: DataPersistor = DataManager.shared) {
        self.usersNetworkClient = usersNetworkClient
        self.dataPersistor = dataPersistor
        self.favouritesUserIds = dataPersistor.favouriteUserIds
    }
    
    func fetchInitialPage(isPullRefresh: Bool = false) {
        if isPullRefresh {
            resetData()
        }
        setState(.loading("Loading User List"))
        usersNetworkClient.fetchUsersInitialPage()
            .catchError({ [unowned self] in self.handleError($0)})
            .subscribe(onSuccess: { [weak self] result in
                guard let `self` = self else { return }
                if result.users.count > 0 {
                    let mappedUsers = self.mappingFavouritesState(for: result.users)
                    self.setState(.idle)
                    self.users = mappedUsers
                    self.lastLinkHeader = result.linkHeader
                } else {
                    self.setState(.completed(.receiveEmptyData))
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
                guard let `self` = self else { return }
                let mappedUsers = self.mappingFavouritesState(for: result.users)
                self.setState(.idle)
                self.lastLinkHeader = result.linkHeader
                self.isLoadingMore = false
                self.users.append(contentsOf: mappedUsers)
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
            // The favourites list wont be updated anywhere else outside of the app
            // So just keep it update in the persistor is good enough
            if updatedUser.isFavourited {
                dataPersistor.addFavorite(userId: updatedUser.id)
            } else {
                dataPersistor.removeFromFavorite(userId: updatedUser.id)
            }
        }
    }

}

/// MARK - Utilities
extension UserListViewModel {
    func mappingFavouritesState(for users: [GitHubUser]) -> [GitHubUser] {
        var mappedUsers = users
        for (index, user) in users.enumerated() {
            // Break the loop when Ids array become empty to avoid redundant check
            if favouritesUserIds.isEmpty { break }
            // Check if favouriteIds contains current userId
            if favouritesUserIds.contains(user.id) {
                // Remove users from ids array after updating favourite status to save the cost for next contains check
                favouritesUserIds.removeAll(where: { $0 == user.id })
                // Update the change
                mappedUsers[index].update(isFavorite: true)
            }
        }
        return mappedUsers
    }
    
    func resetData() {
        // Reset all data to initial state
        users = []
        setState(.idle)
        favouritesUserIds = dataPersistor.favouriteUserIds
    }
    
    func user(at index: Int) -> GitHubUser? {
        guard 0..<users.count ~= index else { return nil }
        return users[index]
    }
}
