//
//  SplashScreenViewController.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SplashScreenViewController: UIViewController, CoordinatableController {
    typealias Flow = SplashScreenFlow
    var coordinator: TriggerableCoordinator<SplashScreenFlow>?
    var viewModel = SplashScreenViewModel()
    var disposeBag = DisposeBag()
    
    deinit {
        print("Deinit \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        disposeBag.insert([
            viewModel.$countdown.asObservable()
                .compactMap { $0 }
                .map { "Loading \($0)" }
                .bind(to: countDownLabel.rx.text),
            viewModel.fetchInitialData().subscribe(onCompleted: { [weak self] in
                self?.coordinator?.triggerFlow(.finishedLoadData)
            })
        ])        
    }
    
    @IBOutlet weak var countDownLabel: UILabel!
}
