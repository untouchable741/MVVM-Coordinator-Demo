//
//  UserRepoCoordinator.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import UIKit

extension GitHubUser: CoordinatorPayload { }

enum UserRepoFlow: CoordinatorFlow {
    case dismissed
}

class UserRepoCoordinator: TriggerableCoordinator<UserRepoFlow>, Coordinator, DetachableCoordinator {
    var detachingHandler: ((Coordinator) -> Void)?
    var coordinators: [Coordinator] = []
    
    deinit {
        print("Deinit \(type(of: self))")
    }
    
    func start(sceneType: SceneType, payload: CoordinatorPayload? = nil) {
        guard let user = payload as? GitHubUser else { return }
        launch(target: makeRepoViewController(for: user), sceneType: sceneType)
    }
    
    override func triggerFlow(_ flow: UserRepoFlow) {
        switch flow {
        case .dismissed:
            notifyCoordinatorDetachment()
        }
    }
}

// MARK -
extension UserRepoCoordinator {
    func makeRepoViewController(for user: GitHubUser) -> UserRepoViewController {
        let viewController = R.storyboard.userRepo.userRepoViewController()!
        let viewModel = UserRepoViewModel(user: user)
        viewController.viewModel = viewModel
        viewController.coordinator = self
        return viewController
    }
}
