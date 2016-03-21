//
//  ConnectivityManager.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/20/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation
class ConnectivityManager {
    private static var reachability: Reachability!
    private static var currentlyReachable: Bool = true
    
    
    class func initialize(){
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability.whenReachable = { reachability in
            self.currentlyReachable = true
        }
        
        reachability.whenUnreachable = { reachability in
            self.currentlyReachable = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    class func stopConnectivityManager() {
        reachability.stopNotifier()
    }
    
    class func isCurrentlyReachable() -> Bool {
        return self.currentlyReachable
    }
}