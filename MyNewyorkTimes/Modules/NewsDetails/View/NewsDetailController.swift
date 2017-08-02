//
//  NewsDetailController.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class NewsDetailController: BaseViewController , NewsDetailViewInterface, UICollectionViewDelegate, UICollectionViewDataSource, WKNavigationDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var newsDetailPresenter : NewsDetailsModuleInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // showing selected news detail information in view
        let selectedIndexPath = IndexPath(item: newsDetailPresenter.currentNewsIndex, section: 0)
        self.collectionView.scrollToItem(at: selectedIndexPath, at: .left, animated: true)
    }
    
    func setupView()
    {
        self.title = "News Details"
        self.setCellSize()
        self.collectionView.isPagingEnabled = true
        self.updateNewsDetailsViewInterface()
        self.setNavigationIndicatorItem()
    }
    
    func setCellSize()
    {
        // Update cell size according to device screen size.
        var size = self.navigationController!.navigationBar.frame.size
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        size.height += statusBarHeight
        
        // updateing item size according to self.view size
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.itemSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height-size.height)
        }
    }
    
    //    MARK:- View Interface implementation
    
    func updateNewsDetailsViewInterface()
    {
        collectionView.reloadData()
    }
    
    func requestErrorOccured(errorMessage:String)
    {
        SVProgressHUD.dismissHUD(error: errorMessage)
    }
    
    //MARK:- Collection View datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return newsDetailPresenter.newsInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailsCell.cellIdentifer, for: indexPath) as! NewsDetailsCell
        let newsInfo = newsDetailPresenter.newsInfoList[indexPath.item]
        cell.loadUrl(stringUrl: newsInfo.webUrl)
        cell.wkwebView.navigationDelegate = self
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if let newsDetailCell = cell as? NewsDetailsCell
        {
            newsDetailCell.wkwebView.tag = indexPath.row + 1
            activityIndicator?.tag = indexPath.row + 1
            if newsDetailCell.wkwebView.isLoading
            {
                activityIndicator?.startAnimating()
            }
        }
        
        if indexPath.item >= newsDetailPresenter.newsInfoList.count - 3 && newsDetailPresenter.canLoadMore
        {
            newsDetailPresenter.requestMoreNewsInfoList()
        }
    }
    
    // MARK: - WKWebView Navigation delegates
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        if webView.tag == activityIndicator?.tag
        {
            activityIndicator?.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if webView.tag == activityIndicator?.tag
        {
            activityIndicator?.stopAnimating()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
