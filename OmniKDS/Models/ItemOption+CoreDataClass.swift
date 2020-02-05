//
//  ItemOption+CoreDataClass.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ItemOption)
public class ItemOption: OPManagedObject {

    override class func primaryKeyName() -> String {
        
        return "optionId"
    }
    
    //orders are received in JSON format. Following method parses json dictionary to actual CoreData ItemOption object. 
    class func createOptionFromJSONDict(jsonDict:NSDictionary, container:NSPersistentContainer) -> ItemOption {
        var anItemOPtion : ItemOption!
        let optionId : String! = jsonDict.value(forKey: "optionId") as? String
        
        do{
            try anItemOPtion = ItemOption.fetchObjectWithId(objId: optionId) as? ItemOption
        }
        catch{
            
        }
        
        if(anItemOPtion==nil)
        {
            let itemEntity = NSEntityDescription.entity(forEntityName: "ItemOption", in: container.viewContext)
            anItemOPtion = NSManagedObject(entity: itemEntity!, insertInto: container.viewContext) as? ItemOption
            anItemOPtion.optionId = optionId
        }
        
        anItemOPtion.itemName = jsonDict.value(forKey: "itemName") as? String
        anItemOPtion.orderItemId = jsonDict.value(forKey: "orderItemId") as? String
        return anItemOPtion
    }
    
    class func getOptionsForOrderItemId(orderItemId:String)-> [ItemOption]{
          
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ItemOption")
        fetchRequest.predicate=NSPredicate(format: "orderItemId=%@",orderItemId)
        var records : [ ItemOption ]
        records = []
        do {
            records = try sharedCoredataCoordinator.persistentContainer.viewContext.fetch(fetchRequest) as! [ItemOption]
        } catch let error as NSError {
               
               print("Could not fetch the requested object. Error: \(error.userInfo)")
        }   
        return records
       }
}
