//
//  BookDetails.swift
//  BestsellerDemo
//
//  Created by Jon on 11/12/16.
//  Copyright © 2016 jm. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class BookDetails : Object, JSONable {
    dynamic var author : String = ""
    dynamic var desc : String = ""
    dynamic var rank : Int = 0
    dynamic var weeksOnList : Int = 0
    dynamic var amazonURLString : String = ""
    dynamic var reviewURLString : String = ""
    dynamic var bookImageURLString : String = ""
    dynamic var listNameEncoded : String = "" {
        didSet {
            compositeKey = compositeValue()
        }
    }
    dynamic var title : String = "" {
        didSet {
            compositeKey = compositeValue()
        }
    }
    dynamic var compositeKey : String = ""
    
    override static func primaryKey() -> String? {
        return "compositeKey"
    }
    
    // Make a composite key out of the listName + title, since these books will show up on multiple lists
    func compositeValue() -> String {
        return String(format: "%@%@", listNameEncoded, title)
    }
    
    static func fromJSON(_ json: JSON) -> BookDetails {
        let bookDetails = BookDetails()
        bookDetails.title = json["title"].stringValue
        bookDetails.author = json["author"].stringValue
        bookDetails.desc = json["description"].stringValue
        bookDetails.rank = json["rank"].intValue
        bookDetails.weeksOnList = json["weeks_on_list"].intValue
        bookDetails.amazonURLString = json["amazon_product_url"].stringValue
        bookDetails.reviewURLString = json["book_review_link"].stringValue
        bookDetails.bookImageURLString = json["book_image"].stringValue
        return bookDetails
    }
}
