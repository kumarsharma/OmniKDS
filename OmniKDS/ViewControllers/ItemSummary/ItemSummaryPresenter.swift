//
//  ItemSummaryPresenter.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 14/10/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData

class ItemSummaryPresenter: KDSPresenter {

    var itemSummary : NSArray?
    var searchItemSummary : NSArray?
    var isSearchActive: Bool?

    init(with itemSummary:NSArray)
    {
        self.itemSummary = itemSummary
        super.init()
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
//        frc.delegate=self
        do{
            try frc.performFetch()
        }catch _{
            
        }
        return frc
    }()

}

extension ItemSummaryPresenter : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cell.textLabel?.numberOfLines=2
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.layer.cornerRadius=5
            cell.layer.borderWidth=1
            cell.layer.borderColor = UIColor.brown.cgColor
            
            cell.textLabel?.font = KDTools.docketTextFont()
        }
        
        let item = isSearchActive! ? self.searchItemSummary?.object(at: indexPath.row) as! KDSummaryItem : self.itemSummary?.object(at: indexPath.row) as! KDSummaryItem
        
        cell.textLabel?.text=String(format: "(%0.0f) %@", item.quantity!.floatValue, item.itemName!)    
        cell.backgroundColor = UIColor.lightGray
        cell.textLabel?.textColor=UIColor.green
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchActive!{
             
             return self.searchItemSummary!.count
         }else{
             
             return self.itemSummary!.count
         }
    }
    
    // MARK: - Table view data source
}
