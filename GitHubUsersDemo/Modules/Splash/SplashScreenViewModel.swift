//
//  SplashScreenViewModel.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/15/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import RxSwift

class SplashScreenViewModel {
    @Relay var countdown: Int?
    
    deinit {
        print("Deinit \(type(of: self))")
    }
    
    func fetchInitialData() -> Observable<Void> {
        // Simulate 3 seconds initial data fetching
        return Observable.from(Array(1...3))
            .concatMap({ Observable.just($0).delay(.seconds(1), scheduler: MainScheduler.instance) })
            .do(onNext: { [weak self] value in
                self?.countdown = value
            }).map { _ in Void() }
    }
}
