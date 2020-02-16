//
//  UserNetworkClientTest.swift
//  GitHubUsersDemoTests
//
//  Created by TAI VUONG on 2/17/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import XCTest
import Mockingjay
@testable import GitHubUsersDemo
import RxSwift

class UserNetworkClientTest: XCTestCase {
    
    var disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_receiveCorrectNumberOfUsersOnInitialPage() {
        let expectation = XCTestExpectation(description: "Should be able to parse and retrieve correct number of users")
        StubManager.stub(path: "/users", file: "users")
        let client = NetworkClient()
        let userNetworkClient = UsersNetworkClient(networkClient: client)
        userNetworkClient.fetchUsersInitialPage().subscribe(onSuccess: { result in
            XCTAssertEqual(30, result.users.count)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_receivedCorrectFirstUserDataOnInitialPage() {
        let expectation = XCTestExpectation(description: "Should be able to parse and retrieve correct first user data")
        StubManager.stub(path: "/users", file: "users")
        let client = NetworkClient()
        let userNetworkClient = UsersNetworkClient(networkClient: client)
        userNetworkClient.fetchUsersInitialPage().subscribe(onSuccess: { result in
            let firstUser = result.users.first
            XCTAssertEqual(firstUser?.id, 1)
            XCTAssertEqual(firstUser?.login, "mojombo")
            XCTAssertEqual(firstUser?.url, "https://github.com/mojombo")
            XCTAssertEqual(firstUser?.siteAdmin, false)
            XCTAssertEqual(firstUser?.accountType, "User")
            XCTAssertEqual(firstUser?.avatar, "https://avatars0.githubusercontent.com/u/1?v=4")
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_receiveCorrectNumberOfUsersOnSecondPage() {
        let expectation = XCTestExpectation(description: "Should be able to parse and retrieve correct number of users for second page")
        StubManager.stub(path: "/users?since=46", file: "next_page_users")
        let client = NetworkClient()
        let userNetworkClient = UsersNetworkClient(networkClient: client)
        var mockLinkHeader = GitHubLinkHeader()
        mockLinkHeader.updateLink("/users?since=46", of: .next)
        userNetworkClient.fetchNextUsersPage(from: mockLinkHeader).subscribe(onSuccess: { result in
            XCTAssertEqual(1, result.users.count)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_receivedCorrectFirstUserDataOnSecondPage() {
        let expectation = XCTestExpectation(description: "Should be able to parse and retrieve correct users data for second page")
        StubManager.stub(path: "/users?since=46", file: "next_page_users")
        let client = NetworkClient()
        let userNetworkClient = UsersNetworkClient(networkClient: client)
        var mockLinkHeader = GitHubLinkHeader()
        mockLinkHeader.updateLink("/users?since=46", of: .next)
        userNetworkClient.fetchNextUsersPage(from: mockLinkHeader).subscribe(onSuccess: { result in
            let firstUser = result.users.first
            XCTAssertEqual(firstUser?.id, 47)
            XCTAssertEqual(firstUser?.login, "jnewland")
            XCTAssertEqual(firstUser?.url, "https://github.com/jnewland")
            XCTAssertEqual(firstUser?.siteAdmin, false)
            XCTAssertEqual(firstUser?.accountType, "User")
            XCTAssertEqual(firstUser?.avatar, "https://avatars2.githubusercontent.com/u/47?v=4")
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)
    }
}
