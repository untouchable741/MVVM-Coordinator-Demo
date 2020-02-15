//
//  GitHubLinkParser.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

struct GitHubLinkHeader {
    enum LinkType: String {
        case prev
        case next
        case first
        case last
        
        init?(value: String?) {
            guard let value = value, let type = LinkType(rawValue: value) else {
                return nil
            }
            self = type
        }
    }
    
    var prevLink: String?
    var nextLink: String?
    var firstLink: String?
    var lastLink: String?
    
    mutating func updateLink(_ link: String, of type: LinkType) {
        switch type {
        case .first:
            firstLink = link
        case .last:
            lastLink = link
        case .next:
            nextLink = link
        case .prev:
            prevLink = link
        }
    }
}

class GitHubLinkParser {
    static func parseGitHubLinkHeader(_ rawLinkHeader: String?) -> GitHubLinkHeader {
        var parsedLinkHeader = GitHubLinkHeader()
        guard let rawLinkHeader = rawLinkHeader else { return parsedLinkHeader }
        for linkString in rawLinkHeader.split(separator: ",") {
            let linkMatches = String(linkString).firstMatches(for: "(?<=<).+?(?=>)")
            let relMatches = String(linkString).firstMatches(for: #"(?<=rel=").+?(?=")"#)
            if let link = linkMatches, let type = GitHubLinkHeader.LinkType(value: relMatches) {
                parsedLinkHeader.updateLink(link, of: type)
            }
        }
        return parsedLinkHeader
    }
}
