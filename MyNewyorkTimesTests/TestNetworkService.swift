//
//  TestNetworkService.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/27/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import Foundation
import UIKit

@testable import MyNewyorkTimes

/// MOCK Test services class for various types of response
class TestNetworkService : NSObject , NetworkServiceInterface
{
    private var baseURL:URL?

    private var httpHeaders =  [String:String]()
    
    private var reachability = Reachability()
    
    static private var sharedNetworkServices:TestNetworkService = {
        
        let networkServicesObject = TestNetworkService()
        
        return networkServicesObject
        
    }()
    
    static func sharedServices() -> NetworkServiceInterface
    {
        
        return sharedNetworkServices
    }
    
    private func bundle() -> Bundle
    {
        return Bundle(for: self.classForCoder)
    }
    
    func setBaseUrl(stringURL:String)
    {
        
    }
    
    func setTimeInterval(_ interval : TimeInterval)
    {
        
    }
    
    func setShowNetworkIndicator(indicator:Bool)
    {
        
    }
    
    func setValue(_ value: String, forHTTPHeaderField field: String)
    {
        httpHeaders[field] = value
    }
    
    func removeHTTPHeaderField(_ field:String)
    {
        httpHeaders[field] = nil
    }
    
    func valueForHTTPHeaderField(_ field:String) -> String?
    {
        return httpHeaders[field]
    }
    
    /// Perform mock Get request for all network services
    ///
    /// - Parameters:
    ///   - urlPath: url Path to retriev
    ///   - parameters: http parameters
    ///   - resultBlock: return request result
    ///   - errorBlock: return request error if any
    
    func getRequest(urlPath: String, parameters: [String:String]?, resultBlock:@escaping ((_ response:Any) -> Void), errorBlock:  @escaping ((NSError) -> Void))
    {
        
        //We will perform checkpoint for all cases here.
        let bundle = self.bundle()
        
        guard (httpHeaders[APIConstant.APIKeyField] != nil) else {
            // no api key provided
            
            if let url = bundle.url(forResource: "NoKeyResponse", withExtension: "json"), let errorData = try? Data(contentsOf: url), let errorResponse = try? JSONSerialization.jsonObject(with: errorData, options: .mutableContainers)
            {
                resultBlock(errorResponse)
            }
            return
        }
        
        if let requestParameters = parameters
        {
            //check and validate parameters
            if let pageno = Int(requestParameters["page"] ?? "") , pageno > 120
            {
                // page parameter excede limit send error
                if let url = bundle.url(forResource: "BadRequest", withExtension: "json"), let errorData = try? Data(contentsOf: url), let errorResponse = try? JSONSerialization.jsonObject(with: errorData, options: .mutableContainers)
                {
                    resultBlock(errorResponse)
                }
                return
            }
        }
        
        // send success response
        
        if let url = bundle.url(forResource: "SuccessResponse", withExtension: "json"), let errorData = try? Data(contentsOf: url), let errorResponse = try? JSONSerialization.jsonObject(with: errorData, options: .mutableContainers)
        {
            resultBlock(errorResponse)
        }
    }
    
    func downloadImage(stringUrl:String, resultBlock:@escaping ((_ image:UIImage?)->Void))
    {
        
    }
}
