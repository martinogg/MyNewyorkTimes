//
//  MyNewyorkTimesTests.swift
//  MyNewyorkTimesTests
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import XCTest
@testable import MyNewyorkTimes

class MyNewyorkTimesTests: XCTestCase {

    var networkClient:NetworkService!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        networkClient =  NetworkService.sharedInstace()
        networkClient.setBaseUrl(stringURL: APIConstant.APIbaseURL)
        networkClient.setValue(APIConstant.APIKey, forHTTPHeaderField: APIConstant.APIKeyField)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
