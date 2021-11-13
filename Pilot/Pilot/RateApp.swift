//
//  RateApp.swift
//  Pilot
//
//  Created by Joshua Zhou on 3/19/19.
//  Copyright © 2019 Shuyu Zhou. All rights reserved.
//


import Foundation
import UIKit
import StoreKit

class RateMe {
    let launchCounts = "launchCounts"
    
    func isReviewDisplayed(minCounts: Int) -> Bool {
        let launchCnts =  UserDefaults.standard.integer(forKey: launchCounts)
        
        if launchCnts == minCounts {
            return true
        } else if launchCnts > minCounts {
            UserDefaults.standard.set(0, forKey: launchCounts)
        } else {
            UserDefaults.standard.set(launchCnts + 1, forKey: launchCounts)
        }
        
        return false
        
    }
    
    func showReview(afterMinCounts : Int) {
        if isReviewDisplayed(minCounts: afterMinCounts) {
            SKStoreReviewController.requestReview()
        }
    }
    
    
}
