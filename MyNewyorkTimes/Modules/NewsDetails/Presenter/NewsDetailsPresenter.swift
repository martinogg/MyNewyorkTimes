//
//  NewsDetailsPresenter.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit

class NewsDetailsPresenter: NewsDetailsInteractorOutput , NewsDetailsModuleInterface, ThreadSupport {
    
    private var newsList: [NewsInfo]!
    private var selectedNewsInfoIndex: Int = 0
    
    var currentNewsIndex: Int{
        return selectedNewsInfoIndex
    }
    var newsInfoList:[NewsInfo] {
        return self.newsList
    }
    
    var canLoadMore : Bool {
        return newsDetailInteractor.canLoadmoreRequest()
    }
    
    private var query:String = ""
    
    var newsDetailInteractor: NewsDetailsInteractorInput!
    weak var viewInterface : NewsDetailViewInterface?
    weak var newsDetailWireframe : NewsDetailWireframeInteractor?
    
    func setNewsInfoList(_ newsInfoList:[NewsInfo], currentNewsIndex:Int, query:String)
    {
        self.newsList = newsInfoList
        self.selectedNewsInfoIndex  = currentNewsIndex
    }
    
    func requestMoreNewsInfoList()
    {
        self.newsDetailInteractor?.loadMoreNewsList(query: self.query)
    }
    
    //MARK:- News List Interactor output implementation
    
    /// News List result of request
    ///
    /// - Parameter newsList: contains array of NewsInfo models
    func newsListResult(_ resultNewsList:[NewsInfo])
    {
        newsList.removeAll()
        newsList.append(contentsOf: resultNewsList)
        
        self.dispatchOnMainQueue {
            self.viewInterface?.updateNewsDetailsViewInterface()
        }
    }
    
    /// News List result of load more request
    ///
    /// - Parameter newsList: contains array of NewsInfo models
    func newsListLoadMoreResult(_ resultNewsList:[NewsInfo])
    {
        newsList.append(contentsOf: resultNewsList)
        self.dispatchOnMainQueue {
            self.viewInterface?.updateNewsDetailsViewInterface()
        }
    }
    /// News List request error
    ///
    /// - Parameter errorMessage: error reason of array
    func newsListResultError(errorMessage:String)
    {
        self.dispatchOnMainQueue {
            self.viewInterface?.requestErrorOccured(errorMessage: errorMessage)
        }
    }
}
