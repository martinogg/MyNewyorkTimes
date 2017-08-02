//
//  NewsListInteractorTest.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/12/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import XCTest
@testable import MyNewyorkTimes

class NewsListInteractorTest: XCTestCase ,NewsListInteractorOutput {
    
    var newsInteractor : NewsListInteractor!
    
    
    
    var newsListExpectation : XCTestExpectation?
    var newsListLoadMoreExpectation : XCTestExpectation?
    var apikeyErrorExpectation : XCTestExpectation?
    var responeErrorExpectation : XCTestExpectation?
    
    let testNetworkServices = TestNetworkService.sharedServices()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        testNetworkServices.setBaseUrl(stringURL: APIConstant.APIbaseURL)
        newsInteractor = NewsListInteractor(networkInterface: testNetworkServices)
        newsInteractor.interactorOutput = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func setAPIKeyHeader()
    {
        testNetworkServices.setValue(APIConstant.APIKey, forHTTPHeaderField: APIConstant.APIKeyField)
    }
    
    func testAPIKeyError() {
        
        apikeyErrorExpectation = XCTestExpectation(description: "API KEY error request")
        
        newsInteractor.loadNewsList(query: "")
        
        self.wait(for: [apikeyErrorExpectation!], timeout: 30)
    }
    
    func testResponseError() {
        
        self.setAPIKeyHeader()
        
        // out of page bound request error
        responeErrorExpectation = XCTestExpectation(description: "Bad request")
        newsInteractor.currentPage = 121
        newsInteractor.loadMoreNewsList(query: "")
        
        self.wait(for: [responeErrorExpectation!], timeout: 30)
    }
    
    func testNewsList() {
        // This is an example of a functional test case.
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        self.setAPIKeyHeader()
        newsListExpectation = XCTestExpectation(description: "News List request")
        
        newsInteractor.loadNewsList(query: "")
        
        self.wait(for: [newsListExpectation!], timeout: 30)
    }
    
    func testNewsListLoadmore() {
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        self.setAPIKeyHeader()
        newsListLoadMoreExpectation = XCTestExpectation(description: "News List load more request")
        newsInteractor.loadMoreNewsList(query: "")
        self.wait(for: [newsListLoadMoreExpectation!], timeout: 30)
    }

    func newsListResult(_ newsList:[NewsInfo])
    {
        newsListExpectation?.fulfill()
        XCTAssert(newsList.count > 0, "No News List Info receive")
    }
    
    func newsListLoadMoreResult(_ newsList:[NewsInfo])
    {
        newsListLoadMoreExpectation?.fulfill()
        XCTAssert(newsList.count > 0, "No News List info load more receive")
    }
    
    func newsListResultError(errorMessage:String)
    {
        switch errorMessage
        {
        case "No API key found in headers or querystring":
            apikeyErrorExpectation?.fulfill()
            break
        case "Pagination beyond page 120 is not allowed at this time.":
            responeErrorExpectation?.fulfill()
            break
        default:
            
            XCTAssertNil(errorMessage, "Received error.")
            newsListExpectation?.fulfill()
            newsListLoadMoreExpectation?.fulfill()
        }
    }
    
    func searchQueryResponse(query:String)
    {
        
    }
    
    func previousSearchListResponse(searchList:[String])
    {
        
    }
}
