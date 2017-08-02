//
//  NewsListModuleInterface.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/12/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import Foundation

protocol NewsListModuleInterface : class
{
    func requestNewsInfoList(query:String)
    
    func requestMoreNewsInfoList(query:String)
    
    func showNewsDetails(_ selectedIndex:Int, query: String)
    
    var newsListInfo:[NewsInfo] { get }
    
    var canLoadMore : Bool {get}
    
    var searchList:[String] {get}
}
