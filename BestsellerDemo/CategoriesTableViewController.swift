//
//  CategoriesTableViewController.swift
//  BestsellerDemo
//
//  Created by Jon on 11/12/16.
//  Copyright © 2016 jm. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class CategoriesTableViewController: UITableViewController, AlertPresenter {
    
    // MARK: - Properties
    var categories : Results<Category>?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        initialCheck()
    }
    
    // MARK: - Reloading
    
    @IBAction func refresh(_ sender: AnyObject) {
        if (NetworkReachabilityManager()?.isReachable)!  {
            getCategoryData(reload: true)
        } else {
            // Trying to get data offline message
            self.presentAlert(alertOptions: AlertOptions(message:"You don't appear to be connected to the internet. Please check your connection.", closure: { _ in self.stopRefresh() }))
        }
    }
    
    func initialCheck() {
        reloadTable()
        // Starting offline message: No persisted data, no internet connection
        if !(NetworkReachabilityManager()?.isReachable)! && categories?.count == 0 {
            self.presentAlert(alertOptions: AlertOptions(message:"You don't appear to be connected to the internet. Please check your connection, then pull to refresh.", closure: { _ in self.stopRefresh() }))
        } else if categories?.count == 0  || categories == nil {
            // First time run
            tableView.refreshControl?.beginRefreshing()
            self.presentAlert(alertOptions: AlertOptions(message:"Welcome! Currently retrieving book data. Going forward, you can pull down to refresh books, though they'll persist offline (including your sorting preferences).", title: "Welcome"))
            getCategoryData(reload: true)
        }
    }
    
    func reloadTable() {
        let realm = try! Realm()
        self.categories = realm.objects(Category.self)
        self.tableView.reloadData()
        stopRefresh()
    }
    
    func stopRefresh() {
        if let refresh = self.tableView.refreshControl, refresh.isRefreshing {
            refresh.endRefreshing()
        }
    }
    
    // MARK: - API Call
    
    func getCategoryData(reload: Bool) {
        let callback : Callback = (
            success: { response in
                if let json = response {
                    autoreleasepool {
                        let realm = try! Realm()
                        json["results"]["lists"].arrayValue
                            .map { Category.fromJSON($0) }
                            .forEach { category in
                                do {
                                    try realm.write {
                                        realm.add(category, update: true)
                                    }
                                }
                                catch (let error) {
                                    self.presentAlert(alertOptions: AlertOptions(message:"\(error)"))
                                }
                        }
                        if reload {
                            self.reloadTable()
                        }
                    }
                }
            },
            failure: { _ in
                self.presentAlert(alertOptions: AlertOptions(message: "Error retrieving categories."))
            }
        )
        DispatchQueue(label: "background").async {
            APIManager.sharedInstance.getCategories(parameters: nil, callback: callback)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("ERROR - Expected a CategoryTableViewCell.")
        }
    
        cell.category = categories?[indexPath.row]
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.lightGray.withAlphaComponent(0.04)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.toBestsellers.rawValue, sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell,
            let destination = segue.destination as? BestsellersTableViewController,
            segue.identifier == SegueIdentifier.toBestsellers.rawValue {
            destination.category = cell.category
        }
    }
}
