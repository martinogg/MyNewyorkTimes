//
//  NetworkServicesTest.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/11/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import XCTest
@testable import MyNewyorkTimes


class NetworkServicesTest: MyNewyorkTimesTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetRequest()
    {
        let testGetReqeust = XCTestExpectation(description: "Normal Get request")
        
        var response:Any?
        var responseerror:NSError?
        
        
        networkClient.getRequest(urlPath: APIConstant.APIServices.ArticleSearch.rawValue, parameters: nil, resultBlock: { (result:Any) in
            
            response = result
            testGetReqeust.fulfill()
            
        }, errorBlock: { (error:NSError) in
            responseerror = error
            testGetReqeust.fulfill()
            
        })
        
        self.wait(for: [testGetReqeust], timeout: 120.0)
        
        
        XCTAssertNil(responseerror, "Recieved error for testGetRequest \(String(describing: responseerror?.localizedDescription))")
        XCTAssertNotNil(response, "Get request response object is nil");
    }
    
    func testGetWithParameterRequets()
    {
        let testGetReqeust = XCTestExpectation(description: "Get request with custom parameters")
        
        var response:Any?
        var responseerror:NSError?
        
        let parameters = ["q":"india","page":"0"]
        
        networkClient.getRequest(urlPath: APIConstant.APIServices.ArticleSearch.rawValue, parameters: parameters, resultBlock: { (result:Any) in
            
            response = result
            testGetReqeust.fulfill()
            
        }, errorBlock: { (error:NSError) in
            responseerror = error
            testGetReqeust.fulfill()
            
        })
        self.wait(for: [testGetReqeust], timeout: 120.0)
        
        
        XCTAssertNil(responseerror, "Recieved error for testGetWithParameterRequets \(String(describing: responseerror?.localizedDescription))")
        XCTAssertNotNil(response, "Get request response object is nil");
    }
}
