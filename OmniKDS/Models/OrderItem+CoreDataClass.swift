//
//  OrderItem+CoreDataClass.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData

@objc(OrderItem)
public class OrderItem: OPManagedObject {

    override class func primaryKeyName() -> String {
        
        return "orderItemId"
    }
    
    //orders are received in JSON format. Following method parses json dictionary to actual CoreData OrderItem object. 
    class func createItemFromJSONDict(jsonDict:NSDictionary, container:NSPersistentContainer) -> OrderItem {
        var anItem : OrderItem!
        let orderItemId : String! = jsonDict.value(forKey: "orderItemId") as? String
        
        do{
            try anItem = OrderItem.fetchObjectWithId(objId: orderItemId) as? OrderItem
        }
        catch{
            
        }
        if(anItem==nil)
        {
            let itemEntity = NSEntityDescription.entity(forEntityName: "OrderItem", in: container.viewContext)
            anItem = NSManagedObject(entity: itemEntity!, insertInto: container.viewContext) as? OrderItem
            anItem.orderItemId = orderItemId
        }
        
        anItem.itemId = jsonDict.value(forKey: "itemId") as? String
        anItem.itemName = jsonDict.value(forKey: "itemName") as? String
        anItem.itemName2 = jsonDict.value(forKey: "itemName2") as? String
        anItem.note = jsonDict.value(forKey: "note") as? String
        anItem.orderId = jsonDict.value(forKey: "orderId") as? String
        anItem.courseId = jsonDict.value(forKey: "courseId") as? String
        anItem.courseName = jsonDict.value(forKey: "courseName") as? String
        anItem.seatNo = jsonDict.value(forKey: "seatNo") as? String
        anItem.takenBy = jsonDict.value(forKey: "takenBy") as? String
        
        let str2:String! = jsonDict.value(forKey: "quantity") as? String 
        anItem.quantity = Int32(str2) ?? 0
        
        let str:String! = jsonDict.value(forKey: "placeTime") as? String
        
        do{
            let date = try OPDateTools.convertToDateFromString(dateStr: str)
            anItem.placeTime = date
        }catch{
            
        }
    
        let options = jsonDict.value(forKey: "itemOPtions") as! NSArray
        for option in options {
            
            _ = ItemOption.createOptionFromJSONDict(jsonDict: option as! NSDictionary, container: sharedCoredataCoordinator.persistentContainer)
        }
        return anItem
    }
    
}
