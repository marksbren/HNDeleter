//
//  HomeFeedManager.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/18/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation


class HomeFeedManager {
    static var currentFeed: [Item] = []
    class func fetchFeed() {
        HTTPManager.getFeedUrlInBackground()
    }
    
    class func feedIsEmpty() -> Bool {
        if currentFeed.count == 0 {
            return true
        }else{
            return false
        }
    }
    
    class func fetchFeedWithBlock(closure: () -> Void){
        HTTPManager.getFeedUrlWithBlock { () -> Void in
            closure()
        }
    }
    
    private class func setCurrentFeed(){
        currentFeed = RealmManager.getItemFeed()
    }
    
    class func getLocalFeed(closure: () -> Void){
        currentFeed = RealmManager.getItemFeed()
        closure()
    }
    
    class func numberOfItems() -> Int {
        return currentFeed.count
    }
    
    class func itemForRow(row: Int) -> Item{
        return currentFeed[row]
    }
    
    class func urlForRow(row: Int) -> String?{
        return currentFeed[row].safeItemUrl()
    }
    
    class func deleteItemAtRow(row: Int) {
        let item = itemForRow(row)
        currentFeed.removeAtIndex(row)
        RealmManager.setItemAsDeleted(item.id!)
    }
    
    class func deleteFeed() {
        currentFeed = []
        RealmManager.deleteAllNonDeletedItems()
    }
    
    class func refreshFeedWithBlock(closure: () -> Void) {
        //deleteFeed()
        fetchFeedWithBlock { () -> Void in
            setCurrentFeed()
            closure()
        }
        
    }
}