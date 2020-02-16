//
//  DataManager.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/16/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

protocol DataPersistor {
    var favouriteUserIds: [Int] { get }
    func addFavorite(userId: Int)
    func removeFromFavorite(userId: Int)
}

class DataManager: DataPersistor {
    static let shared = DataManager()
    @UserDefault(key: "favoriteUsers", defaultValue: []) private var favoriteUsersIds: [Int]
    
    var favouriteUserIds: [Int] {
        return favoriteUsersIds
    }
    
    func addFavorite(userId: Int) {
        favoriteUsersIds.append(userId)
    }
    
    func removeFromFavorite(userId: Int) {
        favoriteUsersIds.removeAll(where: { $0 == userId })
    }
}
