//
//  StringExtension.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

extension String {
    func firstMatches(for regex: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            guard let firstMatches = regex.firstMatch(in: self, range: NSRange(self.startIndex..., in: self)),
                  let range = Range(firstMatches.range, in: self) else { return nil }
            return String(self[range])
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
}
