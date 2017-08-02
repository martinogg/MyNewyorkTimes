//
//  NewsListInteractor.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit

/// NewsListInteractor input protocol
protocol NewsListInteractorInput : NewsLoadInteractorInput
{
    func performSearchResult(query:String)
    func requestPreviousSearchList()
}

/// NewsListInteractor output protocol
protocol NewsListInteractorOutput : NewsLoadInteractorOutput
{
    func searchQueryResponse(query:String)
    func previousSearchListResponse(searchList:[String])
}


/// News list load interactor with network layer and perform parsing operation of JSON
class NewsListInteractor : NewsLoadInteractor , NewsListInteractorInput
{
    var lastSearchListSet:Set<String>!
    
    private var searchListLimit:Int = 10
    
    private let SEARCHLISTKEY = "previousSearches"
    
    override init(networkInterface: NetworkServiceInterface) {
        super.init(networkInterface: networkInterface)
        
        if let list = self.userDefaults().array(forKey: SEARCHLISTKEY) as? [String]
        {
            lastSearchListSet = Set(list)
        }
        else
        {
            lastSearchListSet = Set<String>()
        }
    }
    
    /// Save previous searches list in user default.
    private func saveLastSearchList()
    {
        self.userDefaults().set(Array<String>(self.lastSearchListSet), forKey: SEARCHLISTKEY)
        self.userDefaults().synchronize()
    }
    
    private func userDefaults() -> UserDefaults
    {
        return UserDefaults.standard
    }
    
    private func listInteractorOutput() -> NewsListInteractorOutput?
    {
        return self.interactorOutput as? NewsListInteractorOutput
    }
    
    /// Request for previous search list
    func requestPreviousSearchList()
    {
        if let list = self.userDefaults().array(forKey: SEARCHLISTKEY) as? [String]
        {
            self.listInteractorOutput()?.previousSearchListResponse(searchList: list)
        }
        else
        {
            self.listInteractorOutput()?.previousSearchListResponse(searchList: [])
        }
    }
    
    /// Perform search query operation
    ///
    /// - Parameter query: search query
    func performSearchResult(query:String)
    {
        guard query.isStringEmpty() == false else {
            
            return
        }
        
        // check for query exist in set
        if self.lastSearchListSet.contains(query) == false
        {
            // limit set count
            if self.lastSearchListSet.count == searchListLimit
            {
                self.lastSearchListSet.removeFirst()
            }
            
            self.lastSearchListSet.insert(query)
            self.listInteractorOutput()?.searchQueryResponse(query: query)
            self.saveLastSearchList()
        }
    }
}
