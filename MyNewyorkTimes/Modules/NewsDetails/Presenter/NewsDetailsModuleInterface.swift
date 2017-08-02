//
//  NewsDetailsModuleInterface.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/13/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import Foundation


protocol NewsDetailsModuleInterface : class
{
    var canLoadMore : Bool {get}
    var currentNewsIndex: Int{get}
    var newsInfoList:[NewsInfo] {get}
    func requestMoreNewsInfoList()
}
