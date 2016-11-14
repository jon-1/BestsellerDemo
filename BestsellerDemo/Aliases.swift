//
//  Aliases.swift
//  BestsellerDemo
//
//  Created by Jon on 11/12/16.
//  Copyright © 2016 jm. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias Callback = (success: (JSON?) -> Void, failure: (Any?) -> Void)
typealias Parameters = [String : String]
