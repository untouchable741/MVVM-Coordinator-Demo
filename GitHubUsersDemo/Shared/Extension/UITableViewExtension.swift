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
        return offset.y + frame.size.height + threshold >= contentSize.height
    }
}
