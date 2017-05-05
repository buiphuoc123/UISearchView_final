//
//  ViewController.swift
//  UISearchController
//
//  Created by Cntt05 on 5/3/17.
//  Copyright © 2017 Cntt05. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Setup the Search Controller
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.searchBar.delegate = self as! UISearchBarDelegate
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false

        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Tat ca", "Trai cay", "Hoa qua", "Khac"]
        tableView.tableHeaderView = searchController.searchBar
        
        
        candies = [
            Candy(category:"Trai cay", name:"chomchom"),
            Candy(category:"Trai cay", name:"dua"),
            Candy(category:"Trai cay", name:"duahau"),
            Candy(category:"Hoa qua", name:"chuoi"),
            Candy(category:"Hoa qua", name:"nho"),
            Candy(category:"Hoa qua", name:"vai"),
            Candy(category:"Hoa qua", name:"xoai")
            
        ]
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCandies.count
        }

        
        return candies.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let candy: Candy
        if searchController.isActive && searchController.searchBar.text != "" {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        cell.textLabel!.text = candy.name
        cell.detailTextLabel!.text = candy.category
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Tat ca") {
        filteredCandies = candies.filter({( candy : Candy) -> Bool in
            let categoryMatch = (scope == "Tat ca") || (candy.category == scope)
            return categoryMatch && candy.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let candy: Candy
                if searchController.isActive && searchController.searchBar.text != "" {
                    candy = filteredCandies[indexPath.row]
                } else {
                    candy = candies[indexPath.row]
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailCandy = candy
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}
extension ViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
