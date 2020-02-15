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
    case openUserRepo
}

class UserListCoordinator: TriggerableCoordinator<UserListFlow>, Coordinator {
    var coordinators: [Coordinator] = []
    
    func start(sceneType: SceneType) {
        self.launch(target: makeUserListViewController(), sceneType: sceneType)
    }
    
    override func triggerFlow(_ flow: UserListFlow) {
        switch flow {
        case .openUserRepo:
            print("Open user repo")
        }
    }
}

// MARK -
extension UserListCoordinator {
    func makeUserListViewController() -> UIViewController {
        var viewController = UIViewController()
        return viewController
    }
}

