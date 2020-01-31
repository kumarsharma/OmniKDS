//
//  Order+CoreDataClass.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: OPManagedObject {

    override class func primaryKeyName() -> String {
        
        return "orderId"
    }
    
    class func createOrderFromJSONDict(jsonDict:NSDictionary, container:NSPersistentContainer) -> Order {
        
        var anOrder : Order!
        let orderId : String! = jsonDict.value(forKey: "orderId") as? String
        
        do {
            try anOrder = Order.fetchObjectWithId(objId: orderId) as? Order
        } catch {
            
        }

        if(anOrder==nil)
        {
            let orderEntity = NSEntityDescription.entity(forEntityName: "Order", in: container.viewContext)
            anOrder = NSManagedObject(entity: orderEntity!, insertInto: container.viewContext) as? Order
            anOrder.setValue(jsonDict.value(forKey: "orderId"), forKeyPath:"orderId")
        }
        
        anOrder.setValue(jsonDict.value(forKey: "orderNo"), forKeyPath:"orderNo")
        anOrder.setValue(jsonDict.value(forKey: "customerName"), forKeyPath:"customerName")
        anOrder.setValue(jsonDict.value(forKey: "orderBy"), forKeyPath:"orderBy")
        anOrder.setValue(jsonDict.value(forKey: "tableName"), forKeyPath:"tableName")
        anOrder.setValue(jsonDict.value(forKey: "tableText"), forKeyPath:"tableText")
        
        anOrder.orderDate = OPDateTools.convertToDateFromString(dateStr: jsonDict.value(forKey: "orderDate") as! String)
        anOrder.closedAt = OPDateTools.convertToDateFromString(dateStr: jsonDict.value(forKey: "closedAt") as! String)
        
        return anOrder
    }
}
