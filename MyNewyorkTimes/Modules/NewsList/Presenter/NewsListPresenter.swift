//
//  NewsListPresenter.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit

class NewsListPresenter: NSObject , NewsListInteractorOutput , NewsListModuleInterface
{
    private var newsList:[NewsInfo]!
    private var previousSearchList:[String]!
    
    var newsListInfo:[NewsInfo] {
        return newsList
    }
    var canLoadMore : Bool {
        return newsListInteractor.canLoadmoreRequest()
    }
    var searchList:[String]{
        return previousSearchList
    }
    
    var newsListInteractor : NewsListInteractorInput! {
        
        didSet{
            newsListInteractor.requestPreviousSearchList()
        }
        
    }
    
    weak var viewInterface : NewsListViewInterface?
    weak var newsListWireframe: NewsListWireframeInteractor?
    
    override init() {
        super.init()
        newsList = [NewsInfo]()
        previousSearchList = [String]()
    }
    
    //MARK:- News List Module Interface implementation
    
    /// Request news info list
    ///
    /// - Parameter query: query request to perform
    func requestNewsInfoList(query:String)
    {
        newsListInteractor.performSearchResult(query: query)
        newsListInteractor.loadNewsList(query: query)
    }
    
    /// Request more news info list
    ///
    /// - Parameter query: query request to perform
    
    func requestMoreNewsInfoList(query:String)
    {
        newsListInteractor.performSearchResult(query: query)
        newsListInteractor.loadMoreNewsList(query: query)
    }
    
    //MARK:- News List Interactor output implementation
    
    /// News List result of request
    ///
    /// - Parameter newsList: contains array of NewsInfo models
    func newsListResult(_ resultNewsList:[NewsInfo])
    {
        newsList.removeAll()
        newsList.append(contentsOf: resultNewsList)
        self.viewInterface?.updateListViewInterface()
    }
    
    /// News List result of load more request
    ///
    /// - Parameter newsList: contains array of NewsInfo models
    func newsListLoadMoreResult(_ resultNewsList:[NewsInfo])
    {
        newsList.append(contentsOf: resultNewsList)
        self.viewInterface?.updateListViewInterface()
    }
    /// News List request error
    ///
    /// - Parameter errorMessage: error reason of array
    func newsListResultError(errorMessage:String)
    {
        self.viewInterface?.requestErrorOccured(errorMessage: errorMessage)
    }
    
    /// update search list
    ///
    /// - Parameter query: new query to addd in search list
    func searchQueryResponse(query:String)
    {
        previousSearchList.append(query)
    }
    
    /// Previous search list result
    ///
    /// - Parameter searchList: list of query previously searched
    func previousSearchListResponse(searchList:[String])
    {
        previousSearchList = []
        previousSearchList.append(contentsOf: searchList)
    }
    
    /// Present News details
    ///
    /// - Parameter selectedIndex: show selected index for news details
    func showNewsDetails(_ selectedIndex:Int , query: String)
    {
        newsListWireframe?.showNewsDetails(newsList, currentNewsIndex: selectedIndex, query: query)
    }
}
