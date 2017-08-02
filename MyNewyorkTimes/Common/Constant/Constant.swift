//
//  Constant.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/11/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import Foundation


class APIConstant
{
    static var APIbaseURL = "https://api.nytimes.com/svc/search/v2/"
    static var APIKey = "" // Add your API key here
    static var APIKeyField = "api-key"
    static var APIImageUrl = "https://static01.nyt.com/"
    
    enum APIServices : String
    {
        case ArticleSearch = "articlesearch.json"
    }
}

