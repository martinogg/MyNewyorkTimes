//
//  NewsLoadInteractor.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 15/07/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import Foundation

/// Error types for news list loading
///
/// - errorMessage: error message
enum NewsListError: Error
{
    case errorMessage(message:String)
}

protocol NewsLoadInteractorInput : class {
    func loadNewsList(query:String)
    func loadMoreNewsList(query:String)
    func canLoadmoreRequest() -> Bool
}

protocol NewsLoadInteractorOutput : class
{
    func newsListResult(_ resultNewsList:[NewsInfo])
    func newsListLoadMoreResult(_ resultNewsList:[NewsInfo])
    func newsListResultError(errorMessage:String)
}

class NewsLoadInteractor : NewsLoadInteractorInput, ThreadSupport {
    
    /// Refer to page list
    var currentPage : Int = 0
    
    /// Refer to current active load more request
    var loadmoreInRequest : Bool = false
    
    weak var interactorOutput: NewsLoadInteractorOutput?
    
    var interactorQueue = DispatchQueue(label: NSStringFromClass(NewsListInteractor.self))
    
    private weak var networkInterface:  NetworkServiceInterface?
    
    init(networkInterface:NetworkServiceInterface)
    {
        self.networkInterface = networkInterface
    }
    
    //MARK:- Input Protocol implementation
    func loadNewsList(query:String)
    {
        currentPage = 0
        
        var parameters = ["page":"\(currentPage)"]
        
        if !query.isStringEmpty()
        {
            parameters["q"] = query
        }
        
        networkInterface?.getRequest(urlPath: APIConstant.APIServices.ArticleSearch.rawValue, parameters: parameters, resultBlock: { [weak self] (result:Any) in
            
            if let weakSelf = self
            {
                weakSelf.newsResponseHandler(result: result, isLoadMore: false)
            }
            
        }) { [weak self] (error:NSError) in
            
            if let weakSelf = self
            {
                let stringError = error.localizedDescription
                weakSelf.interactorOutput?.newsListResultError(errorMessage: stringError)
            }
        }
    }
    
    func loadMoreNewsList(query:String)
    {
        if !loadmoreInRequest
        {
            self.setLoadmoreStatus(status: true)
            
            var parameters = ["page":"\(currentPage+1)"]
            
            if !query.isStringEmpty()
            {
                parameters["q"] = query
            }
            
            networkInterface?.getRequest(urlPath: APIConstant.APIServices.ArticleSearch.rawValue, parameters: parameters, resultBlock: { [weak self] (result:Any) in
                
                if let weakSelf = self
                {
                    weakSelf.newsResponseHandler(result: result, isLoadMore: true)
                }
                
            }) { [weak self] (error:NSError) in
                
                if let weakSelf = self
                {
                    weakSelf.interactorOutput?.newsListResultError(errorMessage: error.localizedDescription)
                    weakSelf.setLoadmoreStatus(status: false)
                }
            }
        }
    }
    
    /// get status of load more request
    ///
    /// - Returns: bool flag for load more
    func canLoadmoreRequest() -> Bool
    {
        return !loadmoreInRequest
    }
    
    /// set load more status
    ///
    /// - Parameter status: bool flag determine
    private func setLoadmoreStatus(status:Bool)
    {
        self.loadmoreInRequest = status
    }
    
    /// handle Response handler
    ///
    /// - Parameters:
    ///   - result: news list result
    ///   - isLoadMore: load more status
    private func newsResponseHandler(result:Any, isLoadMore:Bool)
    {
        self.dispatchOnQueue(queue: self.interactorQueue, block: { [weak self] in
            
            do{
                let resultArray = try self?.parseNewsList(jsonResult: result as! JSONDictionary)
                
                if let newsArray = resultArray
                {
                    self?.dispatchOnMainQueue {
                        
                        if isLoadMore
                        {
                            self?.interactorOutput?.newsListLoadMoreResult(newsArray)
                        }
                        else
                        {
                            self?.interactorOutput?.newsListResult(newsArray)
                        }
                    }
                }
                self?.setLoadmoreStatus(status: false)
                
                
            } catch NewsListError.errorMessage(let message) {
                
                self?.interactorOutput?.newsListResultError(errorMessage: message)
            }
            catch{
                // throw some default error
            }
        })
        
        if isLoadMore
        {
            self.currentPage += 1
        }
    }
    
    
    /// parsing function validate and parse news info details
    ///
    /// - Parameter jsonResult: json received from server
    /// - Returns: List of NewsInfo objects
    /// - Throws: throws NewsListError incase of error
    private func parseNewsList(jsonResult:JSONDictionary) throws -> [NewsInfo]
    {
        var defaultErrorMessage = "There is an error with server connection. Please try again later."
        if let message = jsonResult["message"] as? String
        {
            // recieve message key as error in case of http status code other than 200
            throw NewsListError.errorMessage(message: message)
        }
        
        if let status = jsonResult["status"] as? String, status != "OK"
        {
            //we receive satus code but its no 'OK'. there could be some error.
            // check for errors
            
            if let errors = jsonResult["errors"] as? [String] , errors.count > 0
            {
                defaultErrorMessage = errors[0]
            }
            throw NewsListError.errorMessage(message: defaultErrorMessage)
        }
        
        guard let jsonResponse = jsonResult["response"] as? JSONDictionary
            else { throw NewsListError.errorMessage(message: defaultErrorMessage) }
        
        guard let jsonList = jsonResponse["docs"] as? [JSONDictionary]
            else { throw NewsListError.errorMessage(message: defaultErrorMessage) }
        
        return jsonList.flatMap { return NewsInfo(json: $0)}
    }
}
