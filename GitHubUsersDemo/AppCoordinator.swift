//
//  AppCoordinator.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: NSObject, Coordinator {
    var coordinators: [Coordinator] = []
    var window: UIWindow!
    
    func start(sceneType: SceneType, payload: CoordinatorPayload? = nil) {
        if case .root(let window) = sceneType {
            self.window = window
            // Open splash screen so we will be able to prefetching some of user profile data, localization
            // or do a version update checking
            openSplashModule()
        } else {
            assertionFailure("AppCoordinator must be root type")
        }
    }
}

/// Child coordinator delegation
extension AppCoordinator: SplashCoordinatorDelegate {
    func splashCoordinatorDidFinishLoadData(_ sender: SplashScreenCoordinator) {
        remove(sender)
        openUserListModule()
    }
}

/// MARK - Navigations
extension AppCoordinator {
    func openSplashModule() {
        let splashScreenCoordinator = SplashScreenCoordinator()
        splashScreenCoordinator.delegate = self
        add(splashScreenCoordinator)
        splashScreenCoordinator.start(sceneType: .root(window))
    }
    
    func openUserListModule() {
        let userListCoordinator = UserListCoordinator()
        add(userListCoordinator)
        userListCoordinator.start(sceneType: .root(window))
    }
}
