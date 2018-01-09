//
//  NetworkService.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/11/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit
import Foundation

typealias JSONDictionary = [String:Any]

public class NetworkService: NSObject, NetworkServiceInterface , ThreadSupport
{
    private var baseURL:URL?
    
    private var timeInterval : TimeInterval = 60.0
    private var sessionManager:URLSession?
    
    private var imageCache: NSCache<AnyObject, AnyObject>?
    private var imageDownloaderManager: URLSession?
    private var httpHeaders =  [String:String]()
    
    private var showNetworkIndicator : Bool = true
    
    static private var sharedNetworkServices:NetworkService = {
        
        let networkServicesObject = NetworkService()
        
        return networkServicesObject
        
    }()
    
    private var cacheDirectoryPath:String = {
        
        var urlPath = ""
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true)
        if paths.count > 0
        {
            urlPath = paths[0]
        }
        else
        {
            urlPath = NSTemporaryDirectory()
        }
        
        return urlPath
    }()
    
    //MARK:- Network services private init
    private override init()
    {
        super.init()
        
        self.configureSessinManager()
        self.configureImageDownloaderSession()
    }
    
    //MARK:- Internal helper methods
    
    private func configureSessinManager()
    {
        let configuration  = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = timeInterval
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        sessionManager = URLSession(configuration: configuration)
    }
    
    private func configureImageDownloaderSession()
    {
        imageCache = NSCache()
        imageCache?.totalCostLimit = 50
        
        let downloaderConfiguration  = URLSessionConfiguration.default
        downloaderConfiguration.allowsCellularAccess = true
        downloaderConfiguration.timeoutIntervalForRequest = timeInterval
        
        let opQueue = OperationQueue.init()
        opQueue.name = "networkservices.imagedownloader"
        
        imageDownloaderManager = URLSession(configuration: downloaderConfiguration, delegate: nil, delegateQueue: opQueue)
    }
    
    //MARK: Query builder helper
    /// Query builder for HTTP GET request
    ///
    /// - Parameter parameters: parameters
    /// - Returns: string query form of parameters
    private func buildQueryStringParameters(parameters:[String:String]) -> String
    {
        var queryList = [String]();
        
        for (key,value) in parameters
        {
            let newKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let newValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            if newKey != nil && newValue != nil
            {
                let queryItem = String(stringLiteral: newKey! + "=" + newValue!)
                queryList.append(queryItem)
            }
        }
        
        return queryList.joined(separator: "&")
    }
    
    /// Request Builder helper
    ///
    /// - Parameters:
    ///   - urlPath: Http resource path
    ///   - methodType: Http method type
    ///   - parameters: parameters for http request
    /// - Returns: URLReqeust object build from request
    
    private func buildRequest(urlPath:String, methodType:String,parameters:[String:String]?) -> URLRequest
    {
        let url = URL(string: urlPath, relativeTo: self.baseURL!)
        
        var urlRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeInterval)
        
        switch methodType {
        case "GET":
            if let queryParameters = parameters
            {
                let queryString = buildQueryStringParameters(parameters: queryParameters)
                
                if let queryURL = urlRequest.url?.absoluteString.appending("?"+queryString)
                {
                    urlRequest.url = URL(string: queryURL)
                }
            }
            break
            
        case "POST":
            
            break
            
        default: break
            
        }
        
        for (key,value) in httpHeaders
        {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    //MARK:- Public methods
    
    /// Network services single function
    ///
    /// - Returns: Network client singleton object
    public static func sharedInstace() -> NetworkService
    {
        return sharedNetworkServices
    }
        
    public static func sharedServices() -> NetworkServiceInterface
    {
        return sharedNetworkServices
    }
    
    /// Set base url for network services
    ///
    /// - Parameter stringURL: url string
    public func setBaseUrl(stringURL:String)
    {
        baseURL = URL(string: stringURL)
    }
    
    /// set request Time interval
    ///
    /// - Parameter interval: set interval for request
    public func setTimeInterval(_ interval : TimeInterval)
    {
        timeInterval = interval
    }
    
    /// set network indicator
    ///
    /// - Parameter indicator: indicator value
    public func setShowNetworkIndicator(indicator:Bool)
    {
        showNetworkIndicator = indicator
    }
    
    /// set HTTP headers for request
    ///
    /// - Parameters:
    ///   - value: http value
    ///   - field: http header field
    public func setValue(_ value: String, forHTTPHeaderField field: String) {
        httpHeaders[field] = value
    }
    
    /// Remove http headers
    ///
    /// - Parameter field: field to remove
    public func removeHTTPHeaderField(_ field:String)
    {
        httpHeaders.removeValue(forKey: field)
    }
    
    /// value for specific http field
    ///
    /// - Parameter field: field to retriev
    /// - Returns: http value for specific field
    public func valueForHTTPHeaderField(_ field:String) -> String?
    {
        return httpHeaders[field]
        
    }
    
    //MARK: VARIOUS HTTP Request methods
    
    /// Perform Get request for network services
    ///
    /// - Parameters:
    ///   - urlPath: url Path to retriev
    ///   - parameters: http parameters
    ///   - resultBlock: return request result
    ///   - errorBlock: return request error if any
    
    public func getRequest(urlPath: String, parameters: [String:String]?, resultBlock:@escaping ((_ response:Any) -> Void), errorBlock:  @escaping ((NSError) -> Void))
    {
        assert(self.baseURL != nil, "Network services need baseUrl, provide baseUrl")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = self.showNetworkIndicator
        
        let urlReqeuest = buildRequest(urlPath: urlPath,methodType: "GET", parameters: parameters)
        
        let task = sessionManager?.dataTask(with: urlReqeuest, completionHandler: { [weak self](resultData:Data?, response:URLResponse?, httpError:Error?) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let weakSelf = self
            {
                guard httpError == nil else {
                    
                    weakSelf.dispatchOnMainQueue {
                        errorBlock(httpError! as NSError)
                    }
                    return
                }
                
                do{
                    let jsonSerialize = try JSONSerialization.jsonObject(with: resultData!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    weakSelf.dispatchOnMainQueue {
                        resultBlock(jsonSerialize)
                    }
                }
                catch let parseError{
                    weakSelf.dispatchOnMainQueue {
                        errorBlock(parseError as NSError)
                    }
                }
            }
        })
        task?.resume()
    }
    
    //MARK:- image downloader
    
    /// Download image for url
    ///
    /// - Parameters:
    ///   - stringUrl: string url for image
    ///   - resultBlock: return download image
    
    public func downloadImage(stringUrl:String, resultBlock:@escaping ((_ image:UIImage?)->Void))
    {
        // download and catch
        let url = URL(string: stringUrl)
        
        if let image = checkImageOnLocal(fileUrl: url!) {
            
            resultBlock(image)
        }
        
        let task = imageDownloaderManager?.dataTask(with: url!, completionHandler: { [weak self] (data:Data?, response:URLResponse?, error:Error?) in
            
            if let weakSelf = self
            {
                guard error == nil else {
                    weakSelf.dispatchOnMainQueue {
                        resultBlock(nil)
                    }
                    return
                }
                
                let path = weakSelf.cacheDirectoryPath+"\(url!.lastPathComponent)"
                
                if let imageData = data{
                    let imageUrl = URL(fileURLWithPath: path)
                    do{
                        try imageData.write(to: imageUrl, options: Data.WritingOptions.atomic)
                        
                        if let image = UIImage(data: imageData)
                        {
                            weakSelf.dispatchOnMainQueue {
                                resultBlock(image)
                            }
                            weakSelf.imageCache?.setObject(image, forKey: imageUrl.absoluteString as AnyObject)
                        }
                    }
                    catch{
                        weakSelf.dispatchOnMainQueue {
                            resultBlock(nil)
                        }
                    }
                }
            }
        })
        task?.resume()
    }
    
    /// Request image from cache
    ///
    /// - Parameter fileUrl: image url
    /// - Returns: image if found on local / cache
    func checkImageOnLocal(fileUrl:URL) -> UIImage?
    {
        if let image = self.imageCache?.object(forKey: fileUrl.absoluteString as AnyObject) as? UIImage{
            return image
        }
        
        var urlPath = cacheDirectoryPath
        urlPath.append(fileUrl.lastPathComponent)
        if FileManager.default.fileExists(atPath: urlPath){
            
            if let image = UIImage(contentsOfFile: urlPath)
            {
                self.imageCache?.setObject(image, forKey: fileUrl.absoluteString as AnyObject)
                return image
            }
        }
        return nil
    }
}
