//
//  RealmDateTransform.swift
//  
//
//  Created by Mark Brenneman on 3/18/16.
//
//


import Foundation
import ObjectMapper

public class RealmDateTransform: TransformType {
    public typealias Object = NSTimeInterval
    public typealias JSON = String
    let dateFormatter = NSDateFormatter()
    let dateFormatterISO = NSDateFormatter()
    let baseDateString: String = "2010-01-01T00:00:00.000Z"
    
    public init() {
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatterISO.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        dateFormatterISO.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        //        baseDate = dateFormatter.dateFromString(baseDateString)!
    }
    
    public func transformFromJSON(value: AnyObject?) -> NSTimeInterval? {
        if let dateString = value as? String{
            if let currentDate = dateFormatter.dateFromString(dateString) {
                return Double(round(1000*currentDate.timeIntervalSince1970)/1000)
            }else if let currentDate = dateFormatterISO.dateFromString(dateString){
                return Double(round(1000*currentDate.timeIntervalSince1970)/1000)
            }else{
                print("Counld not convert date: \(dateString)")
                return nil
            }
            
            
        }
        return nil
    }
    
    public func transformToJSON(value: NSTimeInterval?) -> String? {
        if let interval = value {
            let newDate = NSDate(timeIntervalSince1970: interval)
            if !dateFormatter.stringFromDate(newDate).isEmpty{
                return dateFormatter.stringFromDate(newDate)
            }else if !dateFormatterISO.stringFromDate(newDate).isEmpty{
                return dateFormatterISO.stringFromDate(newDate)
            }else{
                print("Counld not convert date: \(newDate)")
                return nil
            }
            
        }
        return nil
    }
}
