//
//  NewsDetailWireframe.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit
protocol NewsDetailWireframeInteractor : class
{
    
}

class NewsDetailWireframe: NSObject, NewsDetailWireframeInteractor {
    
    weak var newsDetailController: NewsDetailController?
    var newsDetailPresenter : NewsDetailsPresenter?
    
    override init() {
        super.init()
        self.configureStructure()
    }
    
    private func configureStructure()
    {
        let interactor  = NewsDetailsInteractor(networkInterface: NetworkService.sharedServices())
        newsDetailPresenter = NewsDetailsPresenter()
        newsDetailPresenter?.newsDetailInteractor = interactor
        
        interactor.interactorOutput = newsDetailPresenter
        newsDetailPresenter?.newsDetailWireframe = self
    }
    
    func openNewsDetailsController(parentController: UIViewController, newsInfoList:[NewsInfo], currentNewsIndex:Int,query:String)
    {
        let newsDetailController = parentController.storyboard?.instantiateViewController(withIdentifier: "NewsDetailController") as! NewsDetailController
        
        self.newsDetailController = newsDetailController
        
        newsDetailPresenter?.viewInterface = newsDetailController
        newsDetailController.newsDetailPresenter = newsDetailPresenter
        
        newsDetailPresenter?.setNewsInfoList(newsInfoList, currentNewsIndex: currentNewsIndex, query: query)
        
        parentController.navigationController?.pushViewController(newsDetailController, animated: true)
    }
    
}
