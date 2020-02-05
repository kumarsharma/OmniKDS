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

    //child classes will override this method returning exact name for primary-key attribute
    class func primaryKeyName() -> String {
        return ""
    }
    
    //a function to fetch any object using its id (primary-key attribute)
    class func fetchObjectWithId(objId:String) throws -> OPManagedObject? {
        
        let predicate = NSPredicate(format: "\(self.primaryKeyName())=%@",objId)
        return try self.fetchObjectWithPredicate(predicate: predicate)
    }
    
    //a function to fetch any object using a predicate (search criteria)
    class func fetchObjectWithPredicate(predicate:NSPredicate) throws -> OPManagedObject{
        
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
            
            print("Could not fetch the requested object. Error: \(error.userInfo)")
        }
        if mObj == nil{
            
            throw DBError.NoObjectFound
        }
        else{
            return mObj
        }
    }
}
