//
//  KDCoreDataCoordinator.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 09/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData

let sharedCoredataCoordinator = KDCoreDataCoordinator ()

class KDCoreDataCoordinator: NSObject {

    override init() {
            
    }
    
    func getPersistentContainer() -> NSPersistentContainer {
        return persistentContainer
    }
    
    lazy var persistentContainer: NSPersistentContainer={
        
        let container = NSPersistentContainer(name:"OmniKDS");
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        
        let context = persistentContainer.viewContext
        if context.hasChanges{
            
            do{
                try context.save()
            } catch{
                
                let nserror = error as NSError
                fatalError("Got error in context save \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadSampleOrders(){
        
        Order.removeAll()
        OrderItem.removeAll()
        ItemOption.removeAll()
        
        let filePath = Bundle.main.path(forResource: "SampleOrders", ofType: "txt")
        let url = URL.init(fileURLWithPath: filePath!)
        
        do{
            let ordersFromFile = try String(contentsOf: url)            
            if ordersFromFile.count>0
            {
                var dictionary : Dictionary<String, Any>?
                let data = Data(ordersFromFile.utf8)
                    
                do{
                    dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    
                    let dict = NSDictionary(dictionary: dictionary!)
                    if dict != nil{
                        
                        let allOrders = (dict.value(forKey: "SampleOrders") as? NSArray)!
                        
                        for orderDict in allOrders{
                        
                            let newOrder = Order.createOrderFromJSONDict(jsonDict: orderDict as! NSDictionary, container: sharedCoredataCoordinator.persistentContainer)
                            if newOrder != nil{
                                sharedCoredataCoordinator.saveContext()
                            }
                        }
                    }
                }catch let error as NSError{
                    
                    print("error in parsing \(error.userInfo)")
                }
            }
            
            
        }catch{
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(kDidChangeOrderContentNotification), object: nil)
    }
    
}
