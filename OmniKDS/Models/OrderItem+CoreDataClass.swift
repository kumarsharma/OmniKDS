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
    
    func createItemFromJSONDict(jsonDict:NSDictionary, container:NSPersistentContainer) -> OrderItem {
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
        
        anItem.courseId = jsonDict.value(forKey: "courseId") as? String
        anItem.courseName = jsonDict.value(forKey: "courseName") as? String
        anItem.itemId = jsonDict.value(forKey: "itemId") as? String
        anItem.itemName = jsonDict.value(forKey: "itemName") as? String
        anItem.itemName2 = jsonDict.value(forKey: "itemName2") as? String
        anItem.note = jsonDict.value(forKey: "note") as? String
        anItem.orderId = jsonDict.value(forKey: "orderId") as? String
        
        let str:String! = jsonDict.value(forKey: "placeTime") as? String
        anItem.placeTime = OPDateTools.convertToDateFromString(dateStr: str)
        
        let str2:String! = jsonDict.value(forKey: "quantity") as? String 
        anItem.quantity = Int32(str2)!
        
        anItem.seatNo = jsonDict.value(forKey: "seatNo") as? String
        anItem.takenBy = jsonDict.value(forKey: "takenBy") as? String
        return anItem
    }
    
}
