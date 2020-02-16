//
//  UITableViewExtension.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func isReachingBottom(with offset: CGPoint, threshold: CGFloat = 50) -> Bool {
        // Ignore reaching bottom check when table view content is empty
        guard contentSize.height > 0 else { return false }
        return offset.y + frame.size.height + threshold >= contentSize.height
    }
    
    func showReachedEndPage() {
        tableFooterView = makeFooterView(with: "Reached end of users list.")
    }
    
    func showLoadMoreFooter() {
        tableFooterView = makeFooterView(with: "Loading more users ...", hasLoadingIndicator: true)
    }
    
    func showExceedRateLimitFooter() {
        tableFooterView = makeFooterView(with: "Exceeded GitHub API rate limit")
    }
    
    func showEmptyDataFooter() {
        tableFooterView = makeFooterView(with: "No users data.")
    }
    
    func resetFooter() {
        tableFooterView = UIView(frame: .zero)
    }
}

private extension UITableView {
    private func makeFooterView(with message: String, hasLoadingIndicator: Bool = false) -> UIStackView {
        let containerStackView = UIStackView(frame: .init(origin: .zero, size: .init(width: 0, height: 50)))
        containerStackView.axis = .horizontal
        
        if hasLoadingIndicator {
            let loadingIndicator = UIActivityIndicatorView()
            loadingIndicator.style = .gray
            loadingIndicator.tintColor = .black
            loadingIndicator.hidesWhenStopped = false
            containerStackView.addArrangedSubview(loadingIndicator)
            loadingIndicator.startAnimating()
        }
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = hasLoadingIndicator ? .left : .center
        containerStackView.addArrangedSubview(messageLabel)
        
        return containerStackView
    }
}
