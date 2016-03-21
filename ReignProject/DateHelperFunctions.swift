//
//  DateHelperFunctions.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/18/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation


class DateHelperFunctions {
    
    class func timeAgoSinceDate(interval: NSTimeInterval) -> String {
        return timeAgoSinceDate(realmDateToNSDate(interval))
    }
    
    class func timeAgoSinceDate(date:NSDate) -> String {
        let now = NSDate()
        return timeDifferentBetweenDates(date,date2: now)
        
    }
    
    class func realmDateToNSDate(interval: NSTimeInterval) -> NSDate {
        let newDate = NSDate(timeIntervalSince1970: interval)
        return newDate
    }
    
    class func timeDifferentBetweenDates(date1: NSDate,date2: NSDate)->String{
        let calendar = NSCalendar.currentCalendar()
        let earliest = date1.earlierDate(date2)
        let latest = (earliest == date1) ? date2 : date1
        
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 1) {
            return "\(components.year)y"
        } else if (components.day >= 1) {
            return "\(components.day)d"
        } else if (components.hour >= 1) {
            return "\(components.hour)h"
        } else if (components.minute >= 1) {
            return "\(components.minute)m"
        } else if (components.second >= 3) {
            return "\(components.second)s"
        } else {
            return "Just now"
        }
    }
}