//
//  HTTPManager.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/18/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation
import Alamofire

class HTTPManager {
    class func getFeedUrlInBackground(){
        Alamofire.request(.GET, "https://hn.algolia.com/api/v1/search_by_date?query=ios")//, parameters: ["foo": "bar"])
            .responseJSON { response in
                guard let JSON = response.result.value as? NSDictionary else { return }
                
                RealmManager.importItemsFromJSON(JSON)
        }

    }
    
    class func getFeedUrlWithBlock(closure: () -> Void){
        Alamofire.request(.GET, "https://hn.algolia.com/api/v1/search_by_date?query=ios")//, parameters: ["foo": "bar"])
            .responseJSON { response in
                guard let JSON = response.result.value as? NSDictionary else { return }
                
                RealmManager.importItemsFromJSON(JSON)
                closure()
        }
        
    }
}