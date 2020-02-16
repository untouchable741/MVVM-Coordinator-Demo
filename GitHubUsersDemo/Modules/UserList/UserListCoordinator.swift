//
//  UserListCoordinator.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import UIKit

enum UserListFlow: CoordinatorFlow {
    case openUserRepo(GitHubUser)
}

class UserListCoordinator: TriggerableCoordinator<UserListFlow>, Coordinator {
    var coordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    
    func start(sceneType: SceneType) {
        self.launch(target: makeUserListViewController(), sceneType: sceneType)
    }
    
    override func triggerFlow(_ flow: UserListFlow) {
        switch flow {
        case .openUserRepo(let user):
            openUserRepoModule(of: user)
        }
    }
}

/// MARK - Navigations
extension UserListCoordinator {
    func openUserRepoModule(of user: GitHubUser) {
        let userRepoCoordinator = UserRepoCoordinator()
        add(userRepoCoordinator)
        userRepoCoordinator.start(sceneType: .push(navigationController!), payload: user)
        // When user repo list is removing from parent on navigation back button action
        // Do it this way we don't need to tweak into UINavigationViewControllerDelegate which limiting our app expandability
        // because 1 single navigation controller can be used to manipulate many view controllers across modules
        userRepoCoordinator.detachingHandler = { [weak self] sender in
            // Remove it from the parent coordinator
            self?.remove(sender)
        }
    }
}

// MARK -
extension UserListCoordinator {
    func makeUserListViewController() -> UINavigationController {
        let viewController = R.storyboard.userList.userListViewController()!
        viewController.coordinator = self
        let wrapperNavigationController = UINavigationController(rootViewController: viewController)
        navigationController = wrapperNavigationController
        return wrapperNavigationController
    }
}

