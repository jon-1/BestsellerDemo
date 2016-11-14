//
//  BestsellersTableViewController.swift
//  BestsellerDemo
//
//  Created by Jon on 11/12/16.
//  Copyright © 2016 jm. All rights reserved.
//

import UIKit
import RealmSwift

class BestsellersTableViewController: UITableViewController {

    enum SortStyle : String {
        case rank
        case weeksOnList
    }
    // MARK: - Properties 
    
    var category : Category!
    var books : List<BookDetails> {
        return category.books
    }
    var expandedIndexPaths = Set<NSIndexPath>()
    @IBOutlet var sorterSegmentedControl: UISegmentedControl!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "BestsellerTableViewCell", bundle: nil), forCellReuseIdentifier: BestsellerTableViewCell.reuseIdentifier)
        sorterSegmentedControl.selectedSegmentIndex = category.sortStyle
        selectedSorter(sorterSegmentedControl)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let realm = try! Realm()
        try! realm.write {
            category.sortStyle = sorterSegmentedControl.selectedSegmentIndex
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BestsellerTableViewCell.reuseIdentifier, for: indexPath) as? BestsellerTableViewCell else {
            fatalError("ERROR - Expected a BestSellerTableViewCell.")
        }
        
        cell.book = books[indexPath.row]

        if sorterSegmentedControl.selectedSegmentIndex == 0 {
            cell.rankLabel.alpha = 1.0
            cell.weeksOnListLabel.alpha = 0.0
        } else {
            cell.rankLabel.alpha = 0.0
            cell.weeksOnListLabel.alpha = 1.0
        }

        if expandedIndexPaths.contains(indexPath as NSIndexPath) {
            UIView.animate(withDuration: 0.35, animations: { cell.lowerView.alpha = 1.0})
        } else {
            cell.lowerView.alpha = 0.0
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var height : CGFloat = 51.0
        
        if expandedIndexPaths.contains(indexPath as NSIndexPath) {
             height += 232.0
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        
        if expandedIndexPaths.contains(indexPath as NSIndexPath) {
           expandedIndexPaths.remove(indexPath as NSIndexPath)
            (tableView.cellForRow(at: indexPath) as! BestsellerTableViewCell).lowerView.alpha = 0.0
        } else {
            expandedIndexPaths.insert(indexPath as NSIndexPath)
            UIView.animate(withDuration: 0.35, delay: 0.3, animations: {(tableView.cellForRow(at: indexPath) as! BestsellerTableViewCell).lowerView.alpha = 1.0})
            
        }
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    // MARK: - Sorting
    
    @IBAction func selectedSorter(_ sender: UISegmentedControl) {
        expandedIndexPaths.removeAll()
        if sender.selectedSegmentIndex == 0 {
            sortTable(sortStyle: .rank)
        } else {
            sortTable(sortStyle: .weeksOnList)
        }
    }
    
    func sortTable(sortStyle : SortStyle) {
        let ascending = sortStyle == .rank ? true : false
        let sorted = Array(category.books.sorted(byProperty: sortStyle.rawValue, ascending: ascending))
        let realm = try! Realm()

        try! realm.write {
            category.books.removeAll()
            category.books.append(contentsOf: sorted)
        }
        tableView.reloadData()
    }
}
