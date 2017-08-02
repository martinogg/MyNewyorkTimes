//
//  BaseViewController.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    weak var activityIndicator : UIActivityIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func setNavigationIndicatorItem()
    {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        indicator.color = .white
        indicator.hidesWhenStopped = true
        
        let barItem = UIBarButtonItem(customView: indicator)
        navigationItem.rightBarButtonItem = barItem
        
        activityIndicator = indicator
    }
    
    /// Set Indicator visibility
    ///
    /// - Parameter visible: visibility value
    func setIndicatorVisibility(visible:Bool)
    {
        if visible
        {
            activityIndicator?.startAnimating()
        }
        else{
            activityIndicator?.stopAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
