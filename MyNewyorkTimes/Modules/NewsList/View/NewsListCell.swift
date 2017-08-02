//
//  NewsListCell.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/11/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit

class NewsListCell: UITableViewCell
{
    
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleSnippet: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    static var cellIdentifier = "NewsListCell"
    
    weak var newsInfo: NewsInfo? {
        didSet{
            self.updateCellInfo()
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        articleTitle.numberOfLines = 0
        articleSnippet.numberOfLines = 0
        articleDate.numberOfLines = 0
        articleDate.lineBreakMode = .byWordWrapping
        articleSnippet.lineBreakMode  = .byWordWrapping
    }
    
    func updateCellInfo()
    {
        if let info = newsInfo
        {
            articleDate.text =  info.dateStr
            
            articleSnippet.text = info.snippet
            
            articleTitle.text = info.title
            
            if !info.imageUrl.isStringEmpty()
            {
                articleImage.asyncImageDownload(url: info.imageUrl)
            }
            else
            {
                articleImage.image = UIImage(named: "thumb-article")
            }
        }
    }
}
