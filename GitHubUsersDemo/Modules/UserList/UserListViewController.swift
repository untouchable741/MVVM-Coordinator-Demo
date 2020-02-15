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
        setupTableView()
        bindViewModel()
    }
    
    func setupTableView() {
        userListTableView.register(UINib(resource: R.nib.gitHubUserTableViewCell),
                                   forCellReuseIdentifier: R.reuseIdentifier.gitHubUserCell.identifier)
    }
    
    func bindViewModel() {
        disposeBag.insert([
            viewModel.$users.bind(to: userListTableView.rx.items(cellIdentifier: R.reuseIdentifier.gitHubUserCell.identifier, cellType: GitHubUserTableViewCell.self)) { [weak self] _, user, cell in
            cell.configure(with: user)
            cell.delegate = self
        },
        userListTableView.rx.contentOffset.distinctUntilChanged().compactMap { [weak userListTableView] offset in
            return userListTableView?.isReachingBottom(with: offset)
        }.filter { $0 }.subscribe(onNext: { [weak self] _ in
            self?.viewModel.loadMore()
        }),
        userListTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let user = self?.viewModel.user(at: indexPath.row) {
                self?.coordinator?.triggerFlow(.openUserRepo(user))
            }
            self?.userListTableView.deselectRow(at: indexPath, animated: true)
        })])
        viewModel.fetchInitialPage()
    }

    @IBOutlet weak var userListTableView: UITableView!
}

extension UserListViewController: GitHubUserTableViewCellDelegate {
    func userTableViewCell(_ cell: GitHubUserTableViewCell, didTapFavourite user: GitHubUser?) {
        viewModel.toggleFavorite(on: user)
    }
}
