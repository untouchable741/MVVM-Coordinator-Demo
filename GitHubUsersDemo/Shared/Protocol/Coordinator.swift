//
//  Coordinator.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorPayload { }

enum SceneType {
    case root(UIWindow)
    case push(UINavigationController)
    case present(UIViewController)
    case detail(UISplitViewController)
}

protocol Coordinator: class {
    var coordinators: [Coordinator] { get set }
    var rootViewController: UIViewController? { get }
    
    func start(sceneType: SceneType, payload: CoordinatorPayload?)
    func add(_ coordinator: Coordinator)
    func remove(_ coordinator: Coordinator?)
    func removeAllCoordinators()
    func removeCoordinators<T: Coordinator>(type: T.Type)
    func firstChild<T: Coordinator>(of type: T.Type) -> T?
}

extension Coordinator {
    
    //Needed for TabBar type coordinator
    var rootViewController: UIViewController? {
        return nil
    }
    
    func add(_ coordinator: Coordinator) {
        coordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else { return }
        coordinators = coordinators.filter { $0 !== coordinator }
    }
    
    func removeAllCoordinators() {
        coordinators.removeAll()
    }
    
    func removeCoordinators<T: Coordinator>(type: T.Type) {
        coordinators = coordinators.filter { !($0.self is T)}
    }
    
    func start(sceneType: SceneType, payload: CoordinatorPayload? = nil) {
        start(sceneType: sceneType, payload: payload)
    }
    
    func firstChild<T: Coordinator>(of type: T.Type) -> T? {
        return coordinators.first(where: { $0 is T }) as? T
    }
    
    func launch(target: UIViewController, sceneType: SceneType) {
        switch sceneType {
        case .present(let viewController):
            viewController.present(target, animated: true, completion: nil)
        case .push(let navigationController):
            navigationController.pushViewController(target, animated: true)
        case .root(let window):
            window.rootViewController = target
        case .detail(let splitViewController):
            splitViewController.showDetailViewController(target, sender: nil)
        }
    }
}

protocol DetachableCoordinator: Coordinator {
    typealias Handler = ((Coordinator) -> Void)
    
    var detachingHandler: Handler? { get set }
    func notifyCoordinatorDetachment()
}

extension DetachableCoordinator where Self: Coordinator {
    func notifyCoordinatorDetachment() {
        detachingHandler?(self)
    }
}
