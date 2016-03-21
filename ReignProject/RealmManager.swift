//
//  RealmManager.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/18/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class RealmManager {
    class func importItemsFromJSON(json: NSDictionary){
        let deletedPosts = deletedPostIds()
        guard let hits = json.objectForKey("hits") as? NSArray else { return }
        for item in hits {
            guard let safeItem = item as? NSDictionary else { continue }
            guard !deletedPosts.contains(safeItem.objectForKey("objectID") as! String) else { continue }  // IF the object has been deleted, do not import
            importItem(safeItem)
        }
    }
    
    class func importItem(item: NSDictionary){
        // save to Realm
        let realm = try! Realm()
        do {
            try realm.write {
                let newItem = Mapper<Item>().map(item)!
                realm.add(newItem)
            }
        }catch{
            return
        }
    }
    
    class func setItemAsDeleted(id: String){
        let realm = try! Realm()
        let itemResult = realm.objects(Item).filter("id = '\(id)'").first
        let item = itemResult.map { $0 }
        try! realm.write {
            item?.deleted = true
        }
        print("Deleted item \(item)")
    }
    
    class func getItemFeed() -> [Item]{
        let realm = try! Realm()
        let results = realm.objects(Item).filter("deleted = false").sorted("createdAt", ascending: false)
        let realmResults = results.map { $0 }
        return realmResults
    }
    
    class func deleteAllNonDeletedItems() {
        let realm = try! Realm()
        let itemResults = realm.objects(Item).filter("deleted = false")
        try! realm.write {
            realm.delete(itemResults)
        }
    }
    
    class func deletedPostIds() -> [String] {
        var deletedIds: [String] = []
        let realm = try! Realm()
        let results = realm.objects(Item).filter("deleted = true")
        let realmResults = results.map { $0 }
        for item in realmResults{
            guard let safeId = item.id else { continue }
            deletedIds.append(safeId)
        }
        return deletedIds
    }
    
    class func deleteAllItems() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}