//
//  CoordinatorViewController.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

protocol CoordinatorFlow { }

protocol CoordinatableController where Flow: CoordinatorFlow {
    associatedtype Flow
    var coordinator: TriggerableCoordinator<Flow>? { get set }
}

class TriggerableCoordinator<Flow: CoordinatorFlow> {
    func triggerFlow(_ flow: Flow) {
        print("Should be implemented by subsclass")
    }
}
