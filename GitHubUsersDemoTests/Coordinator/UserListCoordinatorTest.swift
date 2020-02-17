//
//  UserListCoordinatorTest.swift
//  GitHubUsersDemoTests
//
//  Created by TAI VUONG on 2/17/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import XCTest
@testable import GitHubUsersDemo
import RxSwift

class UserListCoordinatorTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_triggerFlow() {
        let userListCoordinator = UserListCoordinator()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        userListCoordinator.navigationController = navigationController
        userListCoordinator.triggerFlow(.openUserRepo(GitHubUser(id: 100)))
        // Delay because openUserRepoModule trigger an animated push
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(userListCoordinator.coordinators.count, 1)
            XCTAssertEqual(userListCoordinator.navigationController?.viewControllers.count, 2)
        }
    }
    
    func test_makeViewController() {
        let userListCoordinator = UserListCoordinator()
        let navigationController = userListCoordinator.makeUserListViewController()
        let userListViewController = navigationController.viewControllers.first as? UserListViewController
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertNotNil(userListViewController)
        XCTAssertNotNil(userListViewController?.coordinator)
        XCTAssertTrue(userListViewController?.coordinator === userListCoordinator)
    }
}
