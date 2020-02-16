//
//  Paginatable.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/16/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

enum PaginationStatus {
    case canLoadMore
    case inProcessing
    case reachedLastPage
}

protocol Paginatable {
    var paginationStatus: PaginationStatus { get set }
    func triggerLoadMoreIfNeeded()
    func handleLoadMore()
    func loadMoreCancelled(with status: PaginationStatus)
}

extension Paginatable {
    func triggerLoadMoreIfNeeded() {
        // Check load more precondition
        guard paginationStatus == .canLoadMore else {
            return loadMoreCancelled(with: paginationStatus)
        }
        handleLoadMore()
    }

    /// (optional)  Can be implement if want to handle state when  load more state is cancelled (e.g: for analytics tracking purpose ...)
    func loadMoreCancelled(with status: PaginationStatus) {
        
    }
}
