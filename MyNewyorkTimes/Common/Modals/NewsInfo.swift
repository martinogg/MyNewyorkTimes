//
//  NewsInfo.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/11/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit

class NewsInfo {
    
    var snippet:String
    var imageUrl:String
    
    var originalDate : String
    
    var dateStr:String // readable formate
    
    var title:String
    var webUrl: String

    fileprivate init()
    {
        snippet = "-"
        imageUrl = ""
        dateStr = "-"
        title = "-"
        originalDate = ""
        webUrl = ""
    }
}

extension NewsInfo{
    
    convenience init(json:JSONDictionary) {
        
        self.init()
        
        snippet =  json["snippet"] as? String ?? ""
        
        if let headline = json["headline"] as? JSONDictionary
        {
            title = headline["main"] as? String ?? ""
        }
        
        originalDate =  json["pub_date"] as? String ?? ""
        
        if !originalDate.isStringEmpty()
        {
            //2017-07-11T23:49:57+0000
            if let date = Date.stringToDate(stringDate: originalDate, formate: "yyyy-MM-dd'T'HH:mm:ssZ")
            {
                dateStr = date.shortDateTimeFormate()
            }
        }
        
        if let thumbArray = json["multimedia"] as? [JSONDictionary], thumbArray.count > 0
        {
            imageUrl = thumbArray[0]["url"] as? String ?? ""
            
            if !imageUrl.isStringEmpty()
            {
                imageUrl = APIConstant.APIImageUrl.appending(imageUrl)
            }
        }
        
        webUrl = json["web_url"] as? String ?? ""
    }
   
}
