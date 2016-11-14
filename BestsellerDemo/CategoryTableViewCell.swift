//
//  CategoryTableViewCell.swift
//  BestsellerDemo
//
//  Created by Jon on 11/13/16.
//  Copyright © 2016 jm. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryTableViewCell"
    @IBOutlet var nameLabel: UILabel!

    var category : Category! {
        didSet {
            nameLabel.text = category.displayName
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
