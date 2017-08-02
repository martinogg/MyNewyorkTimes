//
//  NewsListWireframe.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit

protocol NewsListWireframeInteractor : class
{
    func showNewsDetails(_ newsListInfo:[NewsInfo], currentNewsIndex : Int, query: String)
}

class NewsListWireframe: NSObject , NewsListWireframeInteractor {
    
    weak var newsListController: NewsListController?
    var newsListPresenter : NewsListPresenter?
    
    var newsDetailsWireframe : NewsDetailWireframe?
    
    override init() {
        super.init()
        self.configureStructure()
    }
    
    private func configureStructure()
    {
        let interactor  = NewsListInteractor(networkInterface: NetworkService.sharedServices())
        newsListPresenter = NewsListPresenter()
        interactor.interactorOutput = newsListPresenter
        newsListPresenter?.newsListInteractor = interactor
        newsListPresenter?.newsListWireframe = self
    }
    
    func configureNewsList(window: UIWindow)
    {
        if let navigationController = window.rootViewController as? UINavigationController
        {
            let controller = navigationController.viewControllers.first
            
            newsListController = controller as? NewsListController
            
            newsListController?.newsListPresenter = newsListPresenter
            newsListPresenter?.viewInterface = newsListController
        }
    }
    
    /// Present News details
    ///
    /// - Parameters:
    ///   - newsListInfo: conatins newsInfo list
    ///   - currentNewsIndex: current news to present in detail
    ///   - fromController: parent controller
    func showNewsDetails(_ newsListInfo:[NewsInfo], currentNewsIndex : Int, query: String)
    {
        newsDetailsWireframe = NewsDetailWireframe()
        newsDetailsWireframe?.openNewsDetailsController(parentController: newsListController!, newsInfoList: newsListInfo, currentNewsIndex: currentNewsIndex,query:query);
    }
}
