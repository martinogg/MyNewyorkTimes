//
//  NetworkServiceInterface.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/27/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit
import Foundation

public protocol NetworkServiceInterface : class
{
    static func sharedServices() -> NetworkServiceInterface
    func setBaseUrl(stringURL:String)
    func setTimeInterval(_ interval : TimeInterval)
    func setShowNetworkIndicator(indicator:Bool)
    func setValue(_ value: String, forHTTPHeaderField field: String)
    func removeHTTPHeaderField(_ field:String)
    func valueForHTTPHeaderField(_ field:String) -> String?
    func getRequest(urlPath: String, parameters: [String:String]?, resultBlock:@escaping ((_ response:Any) -> Void), errorBlock:  @escaping ((NSError) -> Void))
    func downloadImage(stringUrl:String, resultBlock:@escaping ((_ image:UIImage?)->Void))
}
