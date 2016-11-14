//
//  BestsellerTableViewCell.swift
//  BestsellerDemo
//
//  Created by Jon on 11/13/16.
//  Copyright © 2016 jm. All rights reserved.
//

import UIKit
import SDWebImage

class BestsellerTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "BestsellerTableViewCell"
    @IBOutlet var upperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lowerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var weeksOnListLabel: UILabel!
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var reviewLinkTextView: UITextView!
    @IBOutlet var amazonLinkTextView: UITextView!
    @IBOutlet var lowerView: UIView!
    @IBOutlet var upperView: UIView!
    
    var book : BookDetails! {
        didSet {
            titleLabel.text = book.title
            weeksOnListLabel.text = String(format: "%d%@", book.weeksOnList, " WEEKS ON THE LIST")
            rankLabel.text = String(format: "%@%d", "Rank: ", book.rank)
            authorLabel.text = String(format: "%@%@", "Written By ", book.author)
            descriptionLabel.text = book.desc
            bookImageView.sd_setImage(with: NSURL(string: book.bookImageURLString) as URL!)
       
            let attributedString = NSMutableAttributedString(string: book.amazonURLString)
            attributedString.addAttribute(NSLinkAttributeName, value:book.amazonURLString, range: NSMakeRange(0, (book.amazonURLString as NSString).length))
            amazonLinkTextView.attributedText = attributedString

            let attributedString2 = NSMutableAttributedString(string: book.reviewURLString)
            attributedString2.addAttribute(NSLinkAttributeName, value:book.reviewURLString, range: NSMakeRange(0, (book.reviewURLString as NSString).length))
            reviewLinkTextView.attributedText = attributedString2

            amazonLinkTextView.text = "Buy On Amazon"
            reviewLinkTextView.text = "Read Review"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bookImageView.layer.borderColor = UIColor.gray.cgColor
        bookImageView.layer.borderWidth = 1.0
        lowerView.alpha = 0.0
        selectionStyle = .none
        amazonLinkTextView.textContainerInset = .zero
        amazonLinkTextView.textContainer.lineFragmentPadding = 0
        reviewLinkTextView.textContainerInset = .zero
        reviewLinkTextView.textContainer.lineFragmentPadding = 0
    }
    
    // Allow interaction with links
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }

}
