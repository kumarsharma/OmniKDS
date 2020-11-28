//
//  KDSummaryViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 15/02/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData

class KDSummaryViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    var itemSummary : NSArray?
    var searchItemSummary : NSArray?
    var isSearchActive: Bool?
    var presenter : ItemSummaryPresenter?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Item Summary"
        isSearchActive = false
        self.view.backgroundColor = .darkGray
        //fetchSummaryOfItems()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation=false
        searchController.searchBar.placeholder = "Search Items"
        searchController.searchBar.scopeButtonTitles = ["Name (A-Z)", "Name (Z-A)", "Qty>", "Qty<"]
        searchController.searchBar.showsScopeBar=true
        navigationItem.searchController=searchController
        definesPresentationContext=true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text!.count > 0{
            
            isSearchActive = true
            let predicate = NSPredicate(format: "itemName CONTAINS[c] %@", searchController.searchBar.text!)
            
            let searchItems =  NSMutableArray(array: (self.itemSummary?.filtered(using: predicate) as NSArray?)!)
            
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                
                let sd = NSSortDescriptor(key: "itemName", ascending: true)
                searchItems.sort(using: [sd])
            }
            else if searchController.searchBar.selectedScopeButtonIndex == 1 {
                
                let sd = NSSortDescriptor(key: "itemName", ascending: false)
                searchItems.sort(using: [sd])
            }
            else if searchController.searchBar.selectedScopeButtonIndex == 2 {
                
                let sd = NSSortDescriptor(key: "quantity", ascending: false)
                searchItems.sort(using: [sd])
            }else if searchController.searchBar.selectedScopeButtonIndex == 3 {
                
                let sd = NSSortDescriptor(key: "quantity", ascending: true)
                searchItems.sort(using: [sd])
            }
            
            self.searchItemSummary = searchItems
        }else{
            
            let allItems = NSMutableArray(array: self.itemSummary!)
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                
                let sd = NSSortDescriptor(key: "itemName", ascending: true)
                allItems.sort(using: [sd])
            }
            else if searchController.searchBar.selectedScopeButtonIndex == 1 {
                
                let sd = NSSortDescriptor(key: "itemName", ascending: false)
                allItems.sort(using: [sd])
            }
            else if searchController.searchBar.selectedScopeButtonIndex == 2 {
                
                let sd = NSSortDescriptor(key: "quantity", ascending: false)
                allItems.sort(using: [sd])
            }else if searchController.searchBar.selectedScopeButtonIndex == 3 {
                
                let sd = NSSortDescriptor(key: "quantity", ascending: true)
                allItems.sort(using: [sd])
            }
            
            self.itemSummary = allItems            
            isSearchActive = false
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
