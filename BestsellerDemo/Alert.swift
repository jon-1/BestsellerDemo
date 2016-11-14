//
//  Alert.swift
//  BestsellerDemo
//
//  Created by Jon on 11/13/16.
//  Copyright © 2016 jm. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct AlertOptions {
    var message : String
    let title : String
    let cancelButtonEnabled : Bool
    let errorJSON : JSON?
    let closure : ((AnyObject) -> Void)?
    init(message : String = "", title: String = "Error", cancelButtonEnabled: Bool = false, errorJSON: JSON = nil, closure :((AnyObject) -> Void)? = nil) {
        self.message = message
        self.title = title
        self.cancelButtonEnabled = cancelButtonEnabled
        self.closure = closure
        self.errorJSON = errorJSON
    }
}

protocol AlertPresenter {
    func presentAlert(alertOptions: AlertOptions)
}

extension AlertPresenter where Self: UIViewController {
    func presentAlert(alertOptions : AlertOptions = AlertOptions()){
        
        var errorString : String = alertOptions.message
        
        if let error = alertOptions.errorJSON {
            let warnings = error["warnings"].dictionaryValue
            for warning in warnings {
                errorString += "\(warning.1.arrayValue.first!)\n"
            }
        }
        
        let alertController = UIAlertController(title:alertOptions.title, message:errorString, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: alertOptions.closure)
        alertController.addAction(OKAction)
        if alertOptions.cancelButtonEnabled {
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in }
            alertController.addAction(cancelAction)
        }
        present(alertController, animated: true, completion:nil)
    }
}
