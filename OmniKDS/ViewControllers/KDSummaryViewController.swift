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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Item Summary"
        isSearchActive = false
        self.view.backgroundColor = .darkGray
        
        let closeBtn = UIBarButtonItem(image: UIImage(named: "closeIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelBtnAction))
        closeBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = closeBtn
        
        let doneBtn = UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneBtnAction))
        doneBtn.tintColor = .white
        self.navigationItem.rightBarButtonItem = doneBtn
        
        fetchSummaryOfItems()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation=false
        searchController.searchBar.placeholder = "Search Items"
        searchController.searchBar.scopeButtonTitles = ["Name (A-Z)", "Name (Z-A)", "Qty>", "Qty<"]
        searchController.searchBar.showsScopeBar=true
        searchController.searchBar.tintColor = .white
        navigationItem.searchController=searchController
        definesPresentationContext=true
    }
    
    @objc func cancelBtnAction(){
           
        self.dismiss(animated: true, completion: nil)
    }
       
    @objc func doneBtnAction(){
          
        self.dismiss(animated: true, completion: nil)
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
    
    func fetchSummaryOfItems(){
        
        let orderIds = NSMutableArray()
        var orderItems = NSArray.init()
        for order in orderFetchedController.fetchedObjects! {
            
            let anOrder = order as? Order
            orderIds.add(anOrder?.orderId! as Any)
        }
        
        let predicate = NSPredicate(format: "orderId IN %@ AND isFinished=false", orderIds)
        do{
            
            orderItems = try OrderItem.fetchWithPredicate(predicate: predicate)
        }catch{
            
        }
        
        let summaryItems = NSMutableArray.init()
        let processedIDs = NSMutableArray.init()
        for item in orderItems{
            
            let anItem = item as? OrderItem
            
            if !processedIDs.contains(anItem!.itemId!){
               
                let similarItems = orderItems.filtered(using: NSPredicate(format: "itemId=%@", anItem!.itemId!))
                var count : Float = 0.0
                for simItem in similarItems{
                    
                    let citem = simItem as? OrderItem
                    count += citem!.quantity
                }
                
//                summaryItems.add(String(format: "(%0.0f) %@", count, anItem!.itemName!))
                
                let summaryItem = KDSummaryItem(itemname: anItem!.itemName!, qty: count)
                summaryItems.add(summaryItem)
                processedIDs.add(anItem!.itemId!)
            }
        }

        let sd = NSSortDescriptor(key: "itemName", ascending: true)
        summaryItems.sort(using: [sd])
        
        self.itemSummary = summaryItems
    }
    
    lazy var orderFetchedController :  NSFetchedResultsController<NSFetchRequestResult> = {
        
        let frc = NSFetchedResultsController(fetchRequest: Order.viewFetchRequest(), managedObjectContext: sharedCoredataCoordinator.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate=self
        do{
            try frc.performFetch()
        }catch _{
            
        }
        return frc
    }()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchActive!{
            
            return self.searchItemSummary!.count
        }else{
            
            return self.itemSummary!.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cell.textLabel?.numberOfLines=2
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.layer.cornerRadius=5
            cell.layer.borderWidth=1
            cell.layer.borderColor = UIColor.brown.cgColor
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 21)
        }
        
        let item = isSearchActive! ? self.searchItemSummary?.object(at: indexPath.row) as! KDSummaryItem : self.itemSummary?.object(at: indexPath.row) as! KDSummaryItem
        
        cell.textLabel?.text=String(format: "(%0.0f) %@", item.quantity!.floatValue, item.itemName!)    
        cell.backgroundColor = .lightGray
        cell.textLabel?.textColor = .black
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
