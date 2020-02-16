//
//  UIViewControllerExtension.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/16/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

import UIKit
import SVProgressHUD
import RxSwift

extension UIViewController {
    func bindToProgressHUD<AnyViewModel: RxViewModel>(with viewModel: AnyViewModel,
                                                      shouldShowLoading: Bool = true,
                                                      shouldShowError: Bool = true) -> Disposable {
        return Observable.merge(rx.methodInvoked(#selector(viewWillDisappear(_:))).map { _ in ViewModelState<AnyViewModel.DataType>.idle },
                         viewModel.stateObservable.asObservable()).subscribe(onNext: { state in
            SVProgressHUD.dismiss()
            switch state {
            case .idle:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .loading(let status):
                if shouldShowLoading {
                    SVProgressHUD.show(withStatus: status)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            case .error(let error):
                if shouldShowError {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            default:
                break
            }
        })
    }
}
