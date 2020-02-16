//
//  UserListViewController.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import UIKit
import RxSwift

class UserListViewController: UIViewController, CoordinatableController {
    typealias Flow = UserListFlow
    var coordinator: TriggerableCoordinator<UserListFlow>?
    let viewModel = UserListViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "GitHub Users"
        setupTableView()
        setupRefreshControl()
        bindViewModel()
    }
    
    func setupTableView() {
        userListTableView.register(UINib(resource: R.nib.gitHubUserTableViewCell),
                                   forCellReuseIdentifier: R.reuseIdentifier.gitHubUserCell.identifier)
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        userListTableView.addSubview(refreshControl)
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self, weak refreshControl] in
            self?.viewModel.fetchInitialPage(isPullRefresh: true)
            refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        disposeBag.insert([
            viewModel.$users.asDriver()
                .drive(userListTableView.rx.items(cellIdentifier: R.reuseIdentifier.gitHubUserCell.identifier, cellType: GitHubUserTableViewCell.self)) { [weak self] _, user, cell in
                cell.configure(with: user)
                cell.delegate = self
            },
            userListTableView.rx.contentOffset.distinctUntilChanged().compactMap { [weak userListTableView] offset in
                return userListTableView?.isReachingBottom(with: offset)
            }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.loadMore()
            }),
            userListTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
                if let user = self?.viewModel.user(at: indexPath.row) {
                    self?.coordinator?.triggerFlow(.openUserRepo(user))
                }
                self?.userListTableView.deselectRow(at: indexPath, animated: true)
            }),
            
            // Binding for custom state which depend on various screen scenario
            // For this User List screen, we use it to notify various situation of the app state
            viewModel.stateObservable
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (state) in
                if case .completed(let action) = state {
                    switch action {
                    case .exceedRateLimit:
                        self?.userListTableView.showExceedRateLimitFooter()
                    case .sentLoadMoreRequest:
                        self?.userListTableView.showLoadMoreFooter()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    case .receiveEmptyData:
                        self?.userListTableView.showEmptyDataFooter()
                    case .reachedLastPage:
                        self?.userListTableView.showReachedEndPage()
                    }
                } else {
                    self?.userListTableView.resetFooter()
                }
            }),
            // Binding common app state (idle, loading, error)
            bindToProgressHUD(with: viewModel)])
        
        // Start fetching initial data
        viewModel.fetchInitialPage()
    }
    
    @IBOutlet weak var userListTableView: UITableView!
}

extension UserListViewController: GitHubUserTableViewCellDelegate {
    func userTableViewCell(_ cell: GitHubUserTableViewCell, didTapFavourite user: GitHubUser?) {
        viewModel.toggleFavorite(on: user)
    }
}
