//
//  Utility.swift
//  ContactApp
//
//  Created by Parth on 01/04/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIColor
{
    class func RGB(_ red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat = 1.0) -> UIColor
    {
        
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

extension UIImageView{
    
    func asyncImageDownload(url:String) -> Void
    {
        NetworkService.sharedServices().downloadImage(stringUrl: url) { (resultImage:UIImage?) in
            if let image = resultImage{
                self.image = image
            }
        }
    }
}

extension NSError
{
    class func serverError(errorMessage: String = "Server error occured") -> NSError
    {
        return NSError(domain: Bundle.main.bundleIdentifier!, code: -1, userInfo: [NSLocalizedDescriptionKey:errorMessage])
    }
}

extension String
{
    func isNumber() -> Bool
    {
        let range = self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted)
        if range == nil {
            return true
        }
        return false
    }
    func isStringEmpty() -> Bool
    {
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if str.isEmpty {
            return true
        }
        return false
    }
}


extension Date
{
    static func stringToDate(stringDate:String,formate:String) -> Date?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let convertDate = formatter.date(from: stringDate)
        return convertDate
    }
    
    func shortDateTimeFormate() -> String
    {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        let convertString = formatter.string(from: self)
        return convertString
    }
    
}

extension UIView
{
    func setBorder(color:UIColor)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
}

extension SVProgressHUD
{
    class func setHUDdesign()
    {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white);
        SVProgressHUD.setDefaultStyle(.dark)
    }

    class func showHUD(status: String = "Loading...")
    {
        SVProgressHUD.show(withStatus: status)
    }

    class func dismissHUD(error:String = "")
    {
        if error.isEmpty
        {
            SVProgressHUD.dismiss()
        }
        else
        {
            SVProgressHUD.showError(withStatus: error)
        }
    }
}
