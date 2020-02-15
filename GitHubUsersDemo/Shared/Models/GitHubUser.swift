//
//  GitHubUser.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

struct GitHubUser: Codable {
    var id: Int
    var login: String?
    var avatar: String?
    var url: String?
    var accountType: String?
    var siteAdmin: Bool?
    var isFavourited: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatar = "avatar_url"
        case url = "html_url"
        case accountType = "type"
        case siteAdmin = "site_admin"
    }
}
