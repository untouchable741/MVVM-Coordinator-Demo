//
//  StubManager.swift
//  GitHubUsersDemoTests
//
//  Created by TAI VUONG on 2/17/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation
import Mockingjay

class StubManager {
    static func stub(path: String, file: String) {
        let filePath = Bundle.main.path(forResource: file, ofType: "json")
        let data = try! String(contentsOfFile: filePath!).data(using: .utf8)
        MockingjayProtocol.addStub(matcher: uri(path), builder: jsonData(data!))
    }
}
