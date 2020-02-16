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

/// Conform RxViewModel with associated type
class UserListViewModel: RxViewModel {
    /// Each screen will define different Action which can be used for notifying various of custom state throught ViewModelState
    enum UserListAction {
        case sentLoadMoreRequest
        case exceedRateLimit
        case receiveEmptyData
        case reachedLastPage
    }
    
    /// RxViewModel state publisher
    typealias DataType = UserListAction
    var stateObservable =  BehaviorRelay<ViewModelState<UserListAction>>(value: .idle)
    
    /// Binding data with custom Relay propertyWrapper
    @Relay var users: [GitHubUser] = []
    let usersNetworkClient: UsersDataProvider
    let dataPersistor: DataPersistor
    var lastLinkHeader: GitHubLinkHeader?
    var disposeBag = DisposeBag()
    var isLoadingMore = false
    var favouritesUserIds: [Int] = []
    
    /// Dependencie Injection
    init(usersNetworkClient: UsersDataProvider = UsersNetworkClient(),
         dataPersistor: DataPersistor = DataManager.shared) {
        self.usersNetworkClient = usersNetworkClient
        self.dataPersistor = dataPersistor
        self.favouritesUserIds = dataPersistor.favouriteUserIds
    }
    
    func fetchInitialPage(isPullRefresh: Bool = false) {
        // Reset data if this is pull to refresh
        if isPullRefresh {
            resetData()
        }
        // Trigger UI update
        setState(.loading("Loading User List"))
        usersNetworkClient.fetchUsersInitialPage()
            .catchError({ [unowned self] in self.handleError($0)})
            .subscribe(onSuccess: { [weak self] result in
                guard let `self` = self else { return }
                // Handle empty data on initial request
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
        // Make sure we won't send duplicate load more request when there is already request being process
        // Also need to make sure load more request wont triggered on initial load (users.count > 0)
        guard isLoadingMore == false, users.count > 0 else { return }
        // No information of last link header, suppose reaching end of user list ?
        guard let linkHeader = lastLinkHeader else {
            return setState(.completed(.reachedLastPage))
        }
        isLoadingMore = true
        // Trigger UI update
        setState(.completed(.sentLoadMoreRequest))
        // Sending request
        usersNetworkClient.fetchNextUsersPage(from: linkHeader)
            .catchError({ [unowned self] in self.handleError($0)})
            .subscribe(onSuccess: { [weak self] result in
                guard let `self` = self else { return }
                if result.users.isEmpty {
                    self.setState(.completed(.reachedLastPage))
                } else {
                    let mappedUsers = self.mappingFavouritesState(for: result.users)
                    self.setState(.idle)
                    self.lastLinkHeader = result.linkHeader
                    self.isLoadingMore = false
                    self.users.append(contentsOf: mappedUsers)
                }
            }).disposed(by: disposeBag)
    }
    
    func handleError<E>(_ error: Error) -> PrimitiveSequence<MaybeTrait, E> {
        // This is for handling custom error mapping
        // For this demo we use it to map github API limit reach error to particular UI update
        // For other error, just forward it to RxViewModel state
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
        // Since we already drived error throught RxViewModel state, we can just completed this strait
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
        isLoadingMore = false
        // Reset favoriteIds to keep the fresh data synced up
        favouritesUserIds = dataPersistor.favouriteUserIds
    }
    
    func user(at index: Int) -> GitHubUser? {
        guard 0..<users.count ~= index else { return nil }
        return users[index]
    }
}
