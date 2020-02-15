//
//  SplashScreenCoordinator.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

protocol SplashCoordinatorDelegate: class {
    func splashCoordinatorDidFinishLoadData(_ sender: SplashScreenCoordinator )
}

enum SplashScreenFlow: CoordinatorFlow {
    case finishedLoadData
}

class SplashScreenCoordinator: TriggerableCoordinator<SplashScreenFlow>, Coordinator {
    weak var delegate: SplashCoordinatorDelegate?
    var coordinators: [Coordinator] = []
    
    deinit {
        print("Deinit \(type(of: self))")
    }
    
    func start(sceneType: SceneType, payload: CoordinatorPayload? = nil) {
        let viewController = makeSplashScreenViewController()
        launch(target: viewController, sceneType: sceneType)
    }
    
    override func triggerFlow(_ flow: SplashScreenFlow) {
        delegate?.splashCoordinatorDidFinishLoadData(self)
    }
}

/// Create ViewController
extension SplashScreenCoordinator {
    func makeSplashScreenViewController() -> SplashScreenViewController {
        let splashScreenViewController = R.storyboard.splashScreen().instantiateInitialViewController() as! SplashScreenViewController
        splashScreenViewController.coordinator = self
        return splashScreenViewController
    }
}
