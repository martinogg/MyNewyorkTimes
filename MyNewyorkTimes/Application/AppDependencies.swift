//
//  AppDependencies.swift
//  ContactApp
//
//  Created by Parth Dubal on 4/3/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit
import SVProgressHUD

/// AppDependencies : setup common initialization at app level

class AppDependencies: NSObject {
    
    var rootWireFrame : NewsListWireframe!
    weak var rootWindows: UIWindow?
    
    /// Init with key window from UIApplication
    override init() {
        super.init()
        
        let windows = UIApplication.shared.windows
        guard windows.count > 0 else {
            assertionFailure("Application needs UIWindow, provide UIWindow")
            return
        }
        
        rootWindows = windows[0]
        
        self.setupAppdependencies()
    }
    
    /// init with window
    ///
    /// - Parameter window: provide from external
    init(window:UIWindow)
    {
        super.init()
        rootWindows = window
        self.setupAppdependencies()
    }
    
    /// initialize app dependencies
    private func setupAppdependencies()
    {
        rootWireFrame = NewsListWireframe()
        
        self.setupNetworkDependecies()
        
        self.configureRootController()
        
        self.setNavigationDesign()
        
        self.setupProgressIndiator()
    }
    
    private func setNavigationDesign()
    {
        if let navigationController = rootWindows!.rootViewController as? UINavigationController
        {
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.barTintColor = UIColor.black
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
            navigationController.navigationBar.isTranslucent = false
            
            UISearchBar.appearance().barTintColor = UIColor.black
            UISearchBar.appearance().tintColor = UIColor.white
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.black
        }
    }
    
    /// initialize network dependencies
    private func setupNetworkDependecies()
    {
        assert(!APIConstant.APIKey.isStringEmpty(), "Please add API key at APIConstant.APIKey, Get API key from https://developer.nytimes.com/ ")
        NetworkService.sharedServices().setBaseUrl(stringURL: APIConstant.APIbaseURL)
        NetworkService.sharedServices().setValue(APIConstant.APIKey, forHTTPHeaderField: APIConstant.APIKeyField)
    }
    
    /// configure root wireframe for app initialization
    private func configureRootController()
    {
        rootWireFrame!.configureNewsList(window: rootWindows!)
    }
    
    private func setupProgressIndiator()
    {
        SVProgressHUD.setHUDdesign()
    }
}
