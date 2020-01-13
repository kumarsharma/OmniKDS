//
//  OPManagedObject+CoreDataClass.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData

@objc(OPManagedObject)
public class OPManagedObject: NSManagedObject {

    class func primaryKeyName() -> String {
        return ""
    }
    
    class func fetchObjectWithId(objId:String) -> OPManagedObject? {
        
        let predicate = NSPredicate(format: "\(self.primaryKeyName())=\(GlobalKitchenID)")
        return self.fetchObjectWithPredicate(predicate: predicate)
    }
    
    class func fetchObjectWithPredicate(predicate:NSPredicate) -> OPManagedObject{
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entity().name!)
        fetchRequest.predicate=predicate
        
        var mObj : OPManagedObject! = nil
        do {
            let records = try sharedCoredataCoordinator.persistentContainer.viewContext.fetch(fetchRequest)
            
            if records.count>0
            {
                mObj = records.first as? OPManagedObject
            }
        } catch let error as NSError {
            
            print("Could not fetch the shared kitchen. Error: \(error.userInfo)")
        }
        
        return mObj
    }
}
