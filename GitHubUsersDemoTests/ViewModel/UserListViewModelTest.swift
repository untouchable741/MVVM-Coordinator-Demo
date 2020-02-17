//
//  UserListViewModelTest.swift
//  GitHubUsersDemoTests
//
//  Created by TAI VUONG on 2/17/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import XCTest
@testable import GitHubUsersDemo
import RxSwift

class MockUserNetworkClient: UsersDataProvider {
    var fetchInitialDataCalled = false
    var fetchNextUserPageCalled = false
    var fetchAPIError: Error?
    
    func fetchUsersInitialPage() -> Maybe<UsersListResponse> {
        fetchInitialDataCalled = true
        if let error = fetchAPIError {
            return Maybe.error(error)
        }
        return Maybe.just(([GitHubUser(id: 100)], GitHubLinkHeader()))
    }
    
    func fetchNextUsersPage(from linkHeader: GitHubLinkHeader) -> Maybe<UsersListResponse> {
        fetchNextUserPageCalled = true
        return Maybe.just(([GitHubUser(id: 200), GitHubUser(id: 300)], GitHubLinkHeader()))
    }
}

class MockDataPersistor: DataPersistor {
    var favouriteUserIds: [Int] = []
    var addedFavoriteUserId: Int = -1
    var removedFavoriteUserId: Int = -1
    
    func addFavorite(userId: Int) {
        addedFavoriteUserId = userId
    }
    
    func removeFromFavorite(userId: Int) {
        removedFavoriteUserId = userId
    }
}

class UserListViewModelTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchInitialPageWasCalledAndReceiveCorrectData() {
        let mockUserNetworkClient = MockUserNetworkClient()
        let viewModel = UserListViewModel(usersNetworkClient: mockUserNetworkClient)
        viewModel.fetchInitialPage()
        let users = try! viewModel.$users.toBlocking(timeout: 1).first()
        XCTAssertEqual(users?.first?.id, 100)
        XCTAssertTrue(mockUserNetworkClient.fetchInitialDataCalled)
    }
    
    func test_fetchNextPageWillNotBeCalledWithoutValidLinkHeader() {
        let mockUserNetworkClient = MockUserNetworkClient()
        let viewModel = UserListViewModel(usersNetworkClient: mockUserNetworkClient)
        viewModel.lastLinkHeader = nil
        viewModel.handleLoadMore()
        XCTAssertFalse(mockUserNetworkClient.fetchNextUserPageCalled)
    }
    
    func test_fetchNextPageWasCalledAndReceiveCorrectData() {
        let mockUserNetworkClient = MockUserNetworkClient()
        let viewModel = UserListViewModel(usersNetworkClient: mockUserNetworkClient)
        viewModel.lastLinkHeader = GitHubLinkHeader()
        viewModel.handleLoadMore()
        let users = try! viewModel.$users.toBlocking(timeout: 1).first()
        XCTAssertEqual(users?.count, 2)
        XCTAssertEqual(users?.first?.id, 200)
        XCTAssertEqual(users?.last?.id, 300)
        XCTAssertTrue(mockUserNetworkClient.fetchNextUserPageCalled)
    }
    
    func test_toggleFavoritesForValidUser() {
        let mockPersistor = MockDataPersistor()
        let viewModel = UserListViewModel(dataPersistor: mockPersistor)
        var mockUser = GitHubUser(id: 100)
        viewModel.users = [mockUser]
        viewModel.toggleFavorite(on: mockUser)
        XCTAssertEqual(mockPersistor.addedFavoriteUserId, 100)
        XCTAssertEqual(viewModel.users.first?.isFavourited, true)
        
        mockUser.isFavourited = true
        viewModel.toggleFavorite(on: mockUser)
        XCTAssertEqual(mockPersistor.removedFavoriteUserId, 100)
        XCTAssertEqual(viewModel.users.first?.isFavourited, false)
    }
    
    func test_toggleFavoritesForNonExistedUser() {
        let mockPersistor = MockDataPersistor()
        let viewModel = UserListViewModel(dataPersistor: mockPersistor)
        let mockUser = GitHubUser(id: 100)
        viewModel.users = [mockUser]
        viewModel.toggleFavorite(on: GitHubUser(id: 200))
        XCTAssertEqual(mockPersistor.addedFavoriteUserId, -1)
        XCTAssertEqual(viewModel.users.first?.isFavourited, false)
        
        viewModel.toggleFavorite(on: GitHubUser(id: 200))
        XCTAssertEqual(mockPersistor.removedFavoriteUserId, -1)
        XCTAssertEqual(viewModel.users.first?.isFavourited, false)
    }
    
    func test_mappingFavoritesState() {
        let newUsers = [GitHubUser(id: 100), GitHubUser(id: 200)]
        let favoriteIds = [100, 200]
        let viewModel = UserListViewModel()
        viewModel.favouritesUserIds = favoriteIds
        newUsers.forEach { XCTAssertEqual($0.isFavourited, false) }
        let mappedUsers = viewModel.mappingFavouritesState(for: newUsers)
        mappedUsers.forEach { XCTAssertEqual($0.isFavourited, true) }
    }
    
    func test_handleExceedLimitError() {
        let mockExceedLimitError = NetworkError.serverResponse(code: 403, message: "Exceed limit error")
        let mockUserNetworkClient = MockUserNetworkClient()
        mockUserNetworkClient.fetchAPIError = mockExceedLimitError
        let viewModel = UserListViewModel(usersNetworkClient: mockUserNetworkClient)
        viewModel.fetchInitialPage()
        let state = try! viewModel.stateObservable.toBlocking().first()
        if case .completed(let action) = state {
            if case .exceedRateLimit = action {
                XCTAssertTrue(true)
            } else {
                XCTFail("Should receive exceeded limit error")
            }
        } else {
            XCTFail("Should receive exceeded limit error")
        }
    }
    
    func test_handleOtherError() {
        let mockError = NetworkError.serverResponse(code: 401, message: "Other errors")
        let mockUserNetworkClient = MockUserNetworkClient()
        mockUserNetworkClient.fetchAPIError = mockError
        let viewModel = UserListViewModel(usersNetworkClient: mockUserNetworkClient)
        viewModel.fetchInitialPage()
        let state = try! viewModel.stateObservable.toBlocking().first()
        if case .error(let error) = state {
            XCTAssertEqual(error.localizedDescription, mockError.localizedDescription)
        } else {
            XCTFail("Should receive error state")
        }
    }
}
