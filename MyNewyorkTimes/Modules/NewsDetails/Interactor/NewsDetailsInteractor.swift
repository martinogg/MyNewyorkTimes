//
//  NewsDetailInteractor.swift
//  MyNewyorkTimes
//
//  Created by Parth Dubal on 7/10/17.
//  Copyright © 2017 Parth Dubal. All rights reserved.
//

import UIKit

/// NewsListInteractor input protocol
protocol NewsDetailsInteractorInput : NewsLoadInteractorInput
{
    
}

/// NewsListInteractor output protocol
protocol NewsDetailsInteractorOutput : NewsLoadInteractorOutput
{
    
}

class NewsDetailsInteractor : NewsLoadInteractor , NewsDetailsInteractorInput {

}
