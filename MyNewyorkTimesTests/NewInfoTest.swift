//
//  NewInfoTest.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/12/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import XCTest
@testable import MyNewyorkTimes

class NewInfoTest: XCTestCase {
    
    var jsonURL : URL?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = Bundle(for: self.classForCoder)
        
        jsonURL = bundle.url(forResource: "NewsModal", withExtension: "json")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewInfo() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var newsModal: NewsInfo?
        
        if let url = jsonURL
        {
            if let jsonData = try? Data(contentsOf: url)
            {
                do{
                    let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONDictionary
                    
                    if let jsonResult = jsonDictionary
                    {
                        newsModal = NewsInfo(json: jsonResult)
                        
                        XCTAssertTrue(newsModal!.title != "Indian Court Suspends Ban On Cattle Sales")
                        XCTAssertTrue(newsModal!.snippet != "The court said a ban intended to protect cows, which Hindus consider sacred, imposed hardships on the beef and leather industries, lar!ely run by Muslims....")
                        XCTAssertFalse(newsModal!.dateStr == "Random Date")
                    }
                }
                catch let error{
                    
                    XCTAssertNil(error, "JSON Parsing error")
                }
            }
            else
            {
                XCTAssert(true, "Unable to create JSON Data from JSON URL")
            }
        }
        else
        {
            XCTAssertNotNil(jsonURL, "JSON File is missing for modal test")
        }
    }
    
    
}
