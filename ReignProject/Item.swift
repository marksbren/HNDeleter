//
//  Item.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/18/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

enum ItemType{
    case Url, StoryPost, SelfPost
    
    static let allValues = [Url, StoryPost, SelfPost]
}

class Item: Object, Mappable {
    dynamic var id: String?
    dynamic var author: String?
    dynamic var commentText: String?
    dynamic var createdAt: Double = 0.00
    dynamic var createdAtI: Double = 0.00
    dynamic var numComments: Int = 0
    dynamic var parentId: String?
    dynamic var points: Int = 0
    dynamic var storyId: String?
    dynamic var storyText: String?
    dynamic var storyTitle: String?
    dynamic var storyUrl: String?
    dynamic var title: String?
    dynamic var url: String?
    dynamic var deleted: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: Map){
        self.init()
    }
    
    // Object Mapper
    func mapping(map: Map) {
        
        if id == nil {
            id <- map["objectID"]
        }
        author <- map["author"]
        commentText <- map["comment_text"]
        createdAt <- (map["created_at"],RealmDateTransform())
        createdAtI <- map["created_at_i"]
        numComments <- map["num_comments"]
        parentId <- map["parent_id"]
        points <- map["points"]
        storyId <- map["story_id"]
        storyText <- map["story_text"]
        storyTitle <- map["story_title"]
        storyUrl <- map["story_url"]
        title <- map["title"]
        url <- map["url"]
    }
    
    func itemType() -> ItemType{
        if let _ = url {
            return ItemType.Url
        }else if let _ = storyUrl{
            return ItemType.StoryPost
        }else{
            return ItemType.SelfPost
        }
    }
    
    func safeSubtitle() -> String{
        return "\(author!) - \(DateHelperFunctions.timeAgoSinceDate(createdAt))"
    }
    
    func safeItemTitle() -> String {
        if let safeTitle = title {
            return safeTitle
        }else if let safeTitle = storyTitle {
            return safeTitle
        }else {
            return "Unknown Title"
        }
    }
    
    func safeItemUrl() -> String {
        if let safeUrl = url {
            return safeUrl
        }else if let safeUrl = storyUrl {
            return safeUrl
        }else{
            return "https://news.ycombinator.com/item?id=\(id!)"
        }
    }
    
}