//
//  ThreadSupport.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 15/07/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import Foundation

protocol ThreadSupport : class
{
    func dispatchOnMainQueue(block: @escaping (()->Void))
    func dispatchOnQueue(queue:DispatchQueue?, block: @escaping (()->Void))
}

extension ThreadSupport
{
    /// Dispatch block on main thread
    ///
    /// - Parameter block: block to perform operation
    func dispatchOnMainQueue(block: @escaping (()->Void))
    {
        DispatchQueue.main.async(execute: block)
    }
    
    /// Dispatch block on queue
    ///
    /// - Parameters:
    ///   - queue: get a global queue if no queue pass
    ///   - block: block to execute on queue
    func dispatchOnQueue(queue:DispatchQueue?, block: @escaping (()->Void))
    {
        var dispatchQueue = queue
        
        if dispatchQueue == nil {
            dispatchQueue = DispatchQueue.global(qos: .default)
        }
        
        dispatchQueue?.async(execute: block)
    }
}
