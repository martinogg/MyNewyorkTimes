//
//  NewsListController.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewsListController: BaseViewController , UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate, UISearchControllerDelegate , NewsSearchResultDelegate , NewsListViewInterface
{
    var loadMoreFooter : UIView?
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableNewsList: UITableView!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    var searchController: UISearchController!
    
    weak var newsListPresenter: NewsListModuleInterface!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupViews()
        
        SVProgressHUD.showHUD()
        newsListPresenter.requestNewsInfoList(query: "")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableNewsList.reloadData()
    }
    
    //MARK:- Common View initializer
    func setupViews()
    {
        // Creating search result controller
        let searchResultController = NewsSearchResultController()
        searchResultController.newsListPresenter = self.newsListPresenter
        searchResultController.newsSearchDelegate = self
        
        // creating search controller
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.delegate = self
        
        //adding search bar in controller
        searchController.searchBar.delegate = self
        self.view.addSubview(searchController.searchBar)
        
        // update table view constraints
        tableTopConstraint.constant = searchController.searchBar.frame.height
        
        let rowHeight:CGFloat = 130.0
        tableNewsList.estimatedRowHeight = rowHeight
        tableNewsList.rowHeight = rowHeight
        
        self.createPulltoRefresh()
        self.setNavigationIndicatorItem()
        self.definesPresentationContext = true
    }
    
    func createPulltoRefresh()
    {
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(pulltoRefresh(control:)), for: UIControlEvents.valueChanged)
        tableNewsList.addSubview(refreshControl)
    }
    
    func createLoadMoreView()
    {
        // create load more if its nill
        if loadMoreFooter != nil  {
            
            // incase of no news list but load more is present so removing from view.
            if newsListPresenter.newsListInfo.count <= 0
            {
                self.removeLoadMoreView()
            }
            return
        }
        
        loadMoreFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableNewsList.frame.size.width, height: 44))
        
        loadMoreFooter?.autoresizingMask = [.flexibleWidth,.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin]
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = .black
        
        activityIndicator.startAnimating()
        
        activityIndicator.center = loadMoreFooter!.center
        
        loadMoreFooter?.addSubview(activityIndicator)
        tableNewsList.tableFooterView = loadMoreFooter
    }
    
    func removeLoadMoreView()
    {
        tableNewsList.tableFooterView = nil
    }
    
    //MARK:- Internal Events
    func pulltoRefresh(control : UIRefreshControl)
    {
        let query = getSearchBarText()
        newsListPresenter.requestNewsInfoList(query: query)
    }
    
    //MARK:- Internal helper methods
    func getSearchBarText() -> String
    {
        var query = ""
        if !searchController.searchBar.text!.isStringEmpty()
        {
            query = searchController.searchBar.text!
        }
        return query
    }
    
    func performSearchCommonOpeartion(query:String)
    {
        if !query.isStringEmpty()
        {
            newsListPresenter.requestNewsInfoList(query: query)
        }
        
        searchController.isActive = false
        
        searchController.searchBar.text = query
        
        self.setIndicatorVisibility(visible: true)
    }
    
    //MARK:- View interface implementation
    
    func updateListViewInterface()
    {
        if refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
        tableNewsList.reloadData()
        self.createLoadMoreView()
        SVProgressHUD.dismissHUD()
        self.setIndicatorVisibility(visible: false)
    }
    
    func requestErrorOccured(errorMessage:String)
    {
        // SHOW error on UI & update flags / variables
        if refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
        
        self.removeLoadMoreView()
        tableNewsList.reloadData()
        
        SVProgressHUD.dismissHUD(error: errorMessage)
        self.setIndicatorVisibility(visible: false)
    }
    
    //MARK:- SearchController & Search bar delegate
    func didPresentSearchController(_ searchController: UISearchController)
    {
        if newsListPresenter.searchList.count > 0
        {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.performSearchCommonOpeartion(query: searchBar.text ?? "")
    }
    
    /// Previous Search result delegates
    ///
    /// - Parameter query: provide selected result from list
    func searchResultClick(query:String)
    {
        self.performSearchCommonOpeartion(query: query)
    }
    
    //MARK:- Table Datasource & Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListPresenter.newsListInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.cellIdentifier) as? NewsListCell
        cell?.newsInfo = newsListPresenter.newsListInfo[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == newsListPresenter.newsListInfo.count - 2 && newsListPresenter.canLoadMore
        {
            // request for load more
            let query = getSearchBarText()
            self.setIndicatorVisibility(visible: true)
            newsListPresenter.requestMoreNewsInfoList(query: query)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        newsListPresenter.showNewsDetails(indexPath.row, query:"")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
