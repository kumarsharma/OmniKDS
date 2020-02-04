//
//  OmniKitchen+CoreDataClass.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData

@objc(OmniKitchen)
public class OmniKitchen: OPManagedObject {

    override class func primaryKeyName() -> String {
        return "kitchenId"
    }
    
    /**     
        Throughout the app, only one kitchen object is used. 
        Kitchen Display is one in the app, so do not create more than one kitchen
    */
    class func getSharedKItchen(container:NSPersistentContainer) -> OmniKitchen {
        
        let predicate = NSPredicate(format: "kitchenId=\(GlobalKitchenID)")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OmniKitchen")
        fetchRequest.predicate=predicate
        var kitchen : OmniKitchen! = nil
        
        fetchRequest.predicate=predicate
        
        do {
            let records = try sharedCoredataCoordinator.persistentContainer.viewContext.fetch(fetchRequest)
            
            if records.count>0
            {
                kitchen = records.first as? OmniKitchen
            }
        } catch let error as NSError {
            
            print("Could not fetch the shared kitchen. Error: \(error.userInfo)")
        }
 
        if kitchen==nil
        {
            let kitchenEntity = NSEntityDescription.entity(forEntityName: "OmniKitchen", in: container.viewContext)
            kitchen = NSManagedObject(entity: kitchenEntity!, insertInto: container.viewContext) as? OmniKitchen
            kitchen.setValue(Int32(GlobalKitchenID), forKey: "kitchenId")
            //all defaults are set on xcdatamodel
            sharedCoredataCoordinator.saveContext()
        }
        else{
            
            print("Global Kitchen is Active!!")
        }
        
        return kitchen
    } 
}
