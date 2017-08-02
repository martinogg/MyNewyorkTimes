//
//  NewsListViewInterface.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/12/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import Foundation


protocol NewsListViewInterface : class
{
    func updateListViewInterface()
    func requestErrorOccured(errorMessage:String)
}

