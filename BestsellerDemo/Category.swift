//
//  Category.swift
//  BestsellerDemo
//
//  Created by Jon on 11/12/16.
//  Copyright © 2016 jm. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Realm

protocol JSONable {
    static func fromJSON(_: JSON) -> Self
}

final class Category : Object, JSONable {
    
    dynamic var displayName : String = ""
    dynamic var listNameEncoded : String = ""
    dynamic var sortStyle : Int = 0
    var books : List<BookDetails> = List<BookDetails>()
    
    override static func primaryKey() -> String? {
        return "listNameEncoded"
    }
    
    static func fromJSON(_ json: JSON) -> Category {
        let category : Category = Category()
        category.displayName = json["list_name"].stringValue
        category.listNameEncoded = json["list_name_encoded"].stringValue
        json["books"].arrayValue
            .map { BookDetails.fromJSON($0) }
            .forEach {
                $0.listNameEncoded = json["list_name_encoded"].stringValue
                category.books.append($0)
        }
        
        return category
    }
}
