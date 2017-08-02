//
//  NewsDetailsCell.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/13/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class NewsDetailsCell: UICollectionViewCell
{
    @IBOutlet weak var innerContetnView: UIView!

    weak var wkwebView: WKWebView!
    
    static var cellIdentifer = "NewsDetailsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.createWKWebView()
        self.contentView.addSubview(innerContetnView)
        
    }
    
    func createWKWebView()
    {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        innerContetnView.addSubview(webView)
        
        let views:[String : Any] = ["webView" : webView]
        
        
        let hConstrainsts = NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: .init(rawValue: 0), metrics: nil, views: views)
        let vConstrainsts = NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: .init(rawValue: 0), metrics: nil, views: views)
        
        innerContetnView.addConstraints(hConstrainsts)
        innerContetnView.addConstraints(vConstrainsts)
        
        wkwebView = webView
    }
    
    func loadUrl(stringUrl:String)
    {
        if let url = URL(string: stringUrl)
        {
            let urlReqeust = URLRequest(url: url)
            wkwebView.load(urlReqeust)
        }
        else
        {
            // SHOW ERROR ON UI.
            SVProgressHUD.dismissHUD(error: "Unable to load URL")
        }
    }
}
