//
//  UserRepoViewController.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RxSwift

class UserRepoViewController: UIViewController, CoordinatableController {
    typealias Flow = UserRepoFlow
    
    var coordinator: TriggerableCoordinator<UserRepoFlow>?
    var viewModel: UserRepoViewModel!
    var disposeBag = DisposeBag()
    
    deinit {
        print("Deinit \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            coordinator?.triggerFlow(.dismissed)
        }
    }
    
    func bindViewModel() {
        disposeBag.insert([
            viewModel.$userRepoUrl
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] url in
                self?.webview.load(URLRequest(url: url))
            }),
            viewModel.$username.subscribe(onNext: { [weak self] username in
                self?.title = username
            })
        ])
    }
    
    @IBOutlet weak var webview: WKWebView!
}
