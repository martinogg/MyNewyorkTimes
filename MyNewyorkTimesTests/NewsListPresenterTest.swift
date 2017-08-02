//
//  NewsListPresenterTest.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/28/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import XCTest
@testable import MyNewyorkTimes

class NewsListPresenterTest: XCTestCase ,NewsListViewInterface{
    
//    var presenter : N
    var presenter : NewsListModuleInterface!
    var searchString  = "world news"
    
    var searchException : XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let testNetworkServices = TestNetworkService.sharedServices()
        testNetworkServices.setBaseUrl(stringURL: APIConstant.APIbaseURL)
        testNetworkServices.setValue(APIConstant.APIKey, forHTTPHeaderField: APIConstant.APIKeyField)
        
        
        let interactor = NewsListInteractor(networkInterface: testNetworkServices)
        let localPresenter = NewsListPresenter()
        
        interactor.interactorOutput = localPresenter
        localPresenter.newsListInteractor = interactor
        localPresenter.viewInterface = self
        
        presenter = localPresenter
        
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   
    func testSearchQuery()
    {
        searchException = XCTestExpectation(description: "Search string exception")
        presenter.requestNewsInfoList(query: searchString)
        self.wait(for: [searchException], timeout: 30.0)
    }
    
    func updateListViewInterface()
    {
        if presenter.searchList.contains(searchString)
        {
            searchException.fulfill()
        }
        
    }
    
    func requestErrorOccured(errorMessage:String)
    {
        
    }
}
