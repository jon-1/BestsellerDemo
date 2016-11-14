//
//  APIManager.swift
//  OpenEventsDemo
//
//  Created by Jon on 10/6/16.
//  Copyright © 2016 jm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class APIManager {
    
    private init(){}
    
    // MARK: - Singleton
    
    static let sharedInstance : APIManager = APIManager()

    private static let authParams : [String : String] = ["api-key" :  "957a8b18e5644db2ba0be425e4ac923b"]
    
    // Append the api key to the parameters or pass them in alone
    private func auth(p : Parameters?) -> Parameters {
        if var params = p {
            for key in APIManager.authParams.keys {
                params[key] = APIManager.authParams[key]
            }
            return params
        } else {
            return APIManager.authParams
        }
    }
    
    private func getRequest(url: URL, parameters: Parameters, callback: Callback) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success(let data):           
                callback.success(JSON(data))
            case .failure(let error):
                callback.failure(error)
            }
        }
    }
    
    func getCategories(parameters: Parameters?, callback: Callback) {
        guard let url = Endpoint.url(destination: .categories) else { callback.failure(nil); return }
        getRequest(url: url, parameters: auth(p: parameters), callback: callback)
    }
    
}
