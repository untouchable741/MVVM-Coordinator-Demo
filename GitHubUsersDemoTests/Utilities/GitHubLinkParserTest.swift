//
//  GitHubLinkParserTest.swift
//  GitHubUsersDemoTests
//
//  Created by TAI VUONG on 2/16/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import XCTest
@testable import GitHubUsersDemo

class GitHubLinkParserTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_canParseSingleNextLink() {
        let nextRawLink = #"<next_link>; rel="next""#
        let parsedLinkHeader = GitHubLinkParser.parseGitHubLinkHeader(nextRawLink)
        XCTAssertNotNil(parsedLinkHeader.nextLink)
        XCTAssertNil(parsedLinkHeader.prevLink)
        XCTAssertNil(parsedLinkHeader.lastLink)
        XCTAssertNil(parsedLinkHeader.firstLink)
        XCTAssertEqual(parsedLinkHeader.nextLink, "next_link")
    }
    
    func test_canParseMultipleLinks() {
        let rawLink = #"<next_link>; rel="next", <first_link>; rel="first", <prev_link>; rel="prev", <last_link>; rel="last""#
        let parsedLinkHeader = GitHubLinkParser.parseGitHubLinkHeader(rawLink)
        XCTAssertNotNil(parsedLinkHeader.nextLink)
        XCTAssertNotNil(parsedLinkHeader.prevLink)
        XCTAssertNotNil(parsedLinkHeader.lastLink)
        XCTAssertNotNil(parsedLinkHeader.firstLink)
        XCTAssertEqual(parsedLinkHeader.nextLink, "next_link")
        XCTAssertEqual(parsedLinkHeader.prevLink, "prev_link")
        XCTAssertEqual(parsedLinkHeader.lastLink, "last_link")
        XCTAssertEqual(parsedLinkHeader.firstLink, "first_link")
    }
    
    func test_parseNilLink() {
        let parsedLinkHeader = GitHubLinkParser.parseGitHubLinkHeader(nil)
        XCTAssertNotNil(parsedLinkHeader)
        XCTAssertNil(parsedLinkHeader.nextLink)
        XCTAssertNil(parsedLinkHeader.prevLink)
        XCTAssertNil(parsedLinkHeader.lastLink)
        XCTAssertNil(parsedLinkHeader.firstLink)
    }
    
    func test_parseInvalidLink() {
        let invalidLink = "This is an invalid link"
        let parsedLinkHeader = GitHubLinkParser.parseGitHubLinkHeader(invalidLink)
        XCTAssertNotNil(parsedLinkHeader)
        XCTAssertNil(parsedLinkHeader.nextLink)
        XCTAssertNil(parsedLinkHeader.prevLink)
        XCTAssertNil(parsedLinkHeader.lastLink)
        XCTAssertNil(parsedLinkHeader.firstLink)
    }
}
