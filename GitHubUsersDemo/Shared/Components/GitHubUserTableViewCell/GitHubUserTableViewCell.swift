//
//  GitHubUserTableViewCell.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import UIKit
import Kingfisher

protocol GitHubUserTableViewCellDelegate: class {
    func userTableViewCell(_ cell: GitHubUserTableViewCell, didTapFavourite user: GitHubUser?)
}

class GitHubUserTableViewCell: UITableViewCell {
    weak var delegate: GitHubUserTableViewCellDelegate?
    var avatarDownloadTask: DownloadTask?
    var user: GitHubUser?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarDownloadTask?.cancel()
        avatarDownloadTask = nil
    }
    
    func configure(with user: GitHubUser) {
        loginLabel.text = user.login
        avatarDownloadTask = avatarImageView?.kf.setImage(with: ImageResource(downloadURL: URL(string: user.avatar!)!))
        githubUrlLabel.text = user.url
        accountTypeLabel.text = "Account Type: \(user.accountType ?? "")"
        siteAdminLabel.text = "Site Admin: \(user.siteAdmin ?? false)"
        favouriteButton.setTitle(user.isFavourited ? "Liked" : "Like", for: .normal)
        self.user = user
    }
    
    @IBAction func favouriteDidTap(_ sender: Any) {
        delegate?.userTableViewCell(self, didTapFavourite: user)
    }
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var githubUrlLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var siteAdminLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
}
