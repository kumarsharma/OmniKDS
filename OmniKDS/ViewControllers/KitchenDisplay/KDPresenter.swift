//
//  KDPresenter.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 10/10/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData

class KDPresenter: KDSPresenter {
    
    var isLoadingSampleOrder:Bool!
    weak var docketCollectionViewObj : UICollectionView!
    weak var orderCollectionViewObj : UICollectionView!
    
    lazy var orderFetchedController :  NSFetchedResultsController<NSFetchRequestResult> = {
        
        let frc = NSFetchedResultsController(fetchRequest: Order.viewFetchRequest(), managedObjectContext: sharedCoredataCoordinator.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate=self
        do{
            try frc.performFetch()
        }catch _{
            
        }
        return frc
    }()
    
    init(with docketCollectionView:UICollectionView, orderCollectionView:UICollectionView){
        
        self.docketCollectionViewObj = docketCollectionView
        self.orderCollectionViewObj = orderCollectionView
        
        super.init()
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func loadData(loadWithSampleOrder shouldLoadWithSample:Bool)
    {
        if shouldLoadWithSample
        {
            
            self.isLoadingSampleOrder = true
            sharedCoredataCoordinator.loadSampleOrders()
            self.delegate.didCompleteDataSync(from: self)
            self.isLoadingSampleOrder = false
        }
    }
    
    func loadData(withOpenOrders openOrder:Bool){
        
        if(openOrder){
            
            self.orderFetchedController.fetchRequest.predicate = NSPredicate(format: "isOpen=true")
        }else{
            
            self.orderFetchedController.fetchRequest.predicate = NSPredicate(format: "isOpen=false")
        }
        
        do{
            try self.orderFetchedController.performFetch()
        }catch{
            
        }
        
        self.delegate.didUpdateModel()
    }
    
    func loadData(withSearchTerm searchTerm:String)
    {
        if searchTerm.count>0{
            
            let predicate = NSPredicate(format: "isOpen=true AND (orderNo CONTAINS[c] %@ OR tableName CONTAINS[c] %@ OR customerName CONTAINS[c] %@) ", searchTerm, searchTerm, searchTerm)
            self.orderFetchedController.fetchRequest.predicate = predicate
            
            do{
                try self.orderFetchedController.performFetch()
            }catch _{
                
            }
            
            self.delegate.didUpdateModel()
        }
    }
    
    func updateCountLabels(orderLabel:UILabel, itemLabel:UILabel){
        
        let totalOrders = orderFetchedController.fetchedObjects?.count
        let orderIds = NSMutableArray()
        var totalItems = 0
        var totalItemsDone = 0
        var totalItemsPending = 0
        for order in orderFetchedController.fetchedObjects! {
            
            let anOrder = order as? Order
            orderIds.add(anOrder?.orderId! as Any)
        }
        
        var predicate = NSPredicate(format: "orderId IN %@ AND isFinished=true", orderIds)
        do{
            predicate = NSPredicate(format: "orderId IN %@ AND isFinished=true", orderIds)
            totalItemsDone = try OrderItem.fetchCountWithPredicate(predicate: predicate)
            predicate = NSPredicate(format: "orderId IN %@ AND isFinished=false", orderIds)
            totalItemsPending = try OrderItem.fetchCountWithPredicate(predicate: predicate)
            
            totalItems = totalItemsDone + totalItemsPending
        }catch{
            
        }
        
        orderLabel.text = String(format: "Total orders: %d", totalOrders ?? 0)
        itemLabel.text = String(format: "Totam items: %d (Done: %d, Pending: %d)", totalItems, totalItemsDone, totalItemsPending)
    }
    
    func registerCells(for collectionView:UICollectionView){
        
        collectionView.register(OPKitchenItemView.self, forCellWithReuseIdentifier: "large_cell0")
        collectionView.register(OPKitchenItemView.self, forCellWithReuseIdentifier: "large_cell1")
        collectionView.register(OPKitchenItemView.self, forCellWithReuseIdentifier: "large_cell2")
        
        collectionView.register(OPKitchenItemView.self, forCellWithReuseIdentifier: "small_cell0")
        collectionView.register(OPKitchenItemView.self, forCellWithReuseIdentifier: "small_cell1")
        collectionView.register(OPKitchenItemView.self, forCellWithReuseIdentifier: "small_cell2")
        
        self.orderCollectionViewObj.register(OPTableItemView.self, forCellWithReuseIdentifier: "cell_2")
    }
    
}

extension KDPresenter : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orderFetchedController.fetchedObjects!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cellPrefix = sharedKitchen?.screenTemplate == 1 ? "large" : "small"
            
            var cellId = cellPrefix+"_cell0"
            if sharedKitchen?.docketSize == 1{
                
                cellId = cellPrefix+"_cell1"
            }else if sharedKitchen?.docketSize == 2{
                
                cellId = cellPrefix+"_cell2"
            }
            
            var colCell : UICollectionViewCell?
            let anOrder = self.orderFetchedController.object(at: indexPath) as? Order
        if collectionView==self.docketCollectionViewObj{
                let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? OPKitchenItemView
                cell?.order = anOrder
                cell?.setupSubViews()
                cell?.reloadCell()
                colCell = cell
            }
            else{
                
                let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "cell_2", for: indexPath) as? OPTableItemView
                cell?.order = anOrder
                cell?.setupSubViews()
                colCell = cell
            }
          
            return colCell!
        }
    
    //MARK: --
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate.didSelectItem(atIndexPath: indexPath, inCollectionView: collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let docketHeight = sharedKitchen?.screenTemplate == 1 ? 600 : 300
        
        let size = (collectionView.isEqual(self.docketCollectionViewObj)) ? CGSize(width: KDTools.docketWidth(), height: docketHeight) : CGSize(width: 90, height: 55)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let sp = (collectionView==self.docketCollectionViewObj) ? 1.0 : 5.0
        return CGFloat(Float(sp))
    }
        
}

extension KDPresenter: NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           
        self.delegate.didUpdateModel()
       }
       
       func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
           
           if type == NSFetchedResultsChangeType.insert{
           
               if sharedKitchen!.newDocketNotification{
                   
                   if !self.isLoadingSampleOrder!{
                   
                        DispatchQueue.main.async {
                            
                            self.delegate.playKitchenSound(withSoundName: sharedKitchen!.newDocketSoundName!)
                        }
                   }
               }
            
                self.docketCollectionViewObj.insertItems(at: [newIndexPath!])
                self.orderCollectionViewObj.insertItems(at: [newIndexPath!])
           }else if type == NSFetchedResultsChangeType.delete{
           
                self.docketCollectionViewObj.deleteItems(at: [indexPath!])
                self.orderCollectionViewObj.deleteItems(at: [indexPath!])
           }else if type == NSFetchedResultsChangeType.update{
           
                self.docketCollectionViewObj.reloadItems(at: [indexPath!])
                self.orderCollectionViewObj.reloadItems(at: [indexPath!])
           }
       }       
}
