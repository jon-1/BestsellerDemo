//
//  Endpoint.swift
//  BestsellerDemo
//
//  Created by Jon on 11/12/16.
//  Copyright © 2016 jm. All rights reserved.
//

import Foundation

struct Endpoint {
    
    private init() {}
    
    static let baseURLString = "https://api.nytimes.com/svc/books/v3"
    
    enum Destination : String {
        case categories = "/lists/overview.json"
    }
    
    static func url(destination : Endpoint.Destination) -> URL? {
        do {
            return try String(format: "%@%@", Endpoint.baseURLString, destination.rawValue).asURL()
        } catch {
            print("Couldn't form URL")
        }
        return nil
    }
}
