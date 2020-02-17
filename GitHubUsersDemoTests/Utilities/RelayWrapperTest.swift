//
//  RelayWrapperTest.swift
//  GitHubUsersDemoTests
//
//  Created by TAI VUONG on 2/16/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import XCTest
@testable import GitHubUsersDemo
import RxRelay
import RxBlocking

class RelayWrapperTest: XCTestCase {
    
    @Relay var intRelay: Int?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_projectedValue() {
        intRelay = 99
        XCTAssertEqual(try! $intRelay.toBlocking(timeout: 1).first()!, 99)
        intRelay = 88
        XCTAssertEqual(try! $intRelay.toBlocking(timeout: 1).first()!, 88)
    }
}
