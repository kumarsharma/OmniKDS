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
    
    //throughout this app we will use only kitchen object. Kitchen Display is one in the app
    //do not create more than one kitchen
    class func getSharedKItchen(container:NSPersistentContainer) -> OmniKitchen {
        
        let predicate = NSPredicate(format: "kitchenId=\(GlobalKitchenID)")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OmniKitchen")
        fetchRequest.predicate=predicate
        var kitchen : OmniKitchen! = OmniKitchen.fetchObjectWithId(objId: "\(GlobalKitchenID)") as? OmniKitchen
 
        if kitchen==nil
        {
            let kitchenEntity = NSEntityDescription.entity(forEntityName: "OmniKitchen", in: container.viewContext)
            kitchen = NSManagedObject(entity: kitchenEntity!, insertInto: container.viewContext) as? OmniKitchen
            kitchen.setValue(Int32(GlobalKitchenID), forKey: "kitchenId")
            kitchen.bgColor="gray"
            kitchen.fontSize=17
            kitchen.kitchenName="Kitchen Display"
            kitchen.soundMode = false
            kitchen.soundType=""
            kitchen.ticketSize = 1
            kitchen.turnToRedAfter=5
            kitchen.turnToYellowAfter=5
            kitchen.viewMode=1
            
            sharedCoredataCoordinator.saveContext()
        }
        else{
            
            print("Global KItchen is Active!!")
        }
        
        return kitchen
    }
}
