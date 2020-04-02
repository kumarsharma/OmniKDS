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
    
    //orders are received in JSON format. Following method parses json dictionary to actual CoreData Order object. 
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
            anOrder.orderDate = Date()
        }
        
        anOrder.setValue(jsonDict.value(forKey: "orderNo"), forKeyPath:"orderNo")
        anOrder.setValue(jsonDict.value(forKey: "customerName"), forKeyPath:"customerName")
        anOrder.setValue(jsonDict.value(forKey: "orderBy"), forKeyPath:"orderBy")
        anOrder.setValue(jsonDict.value(forKey: "tableName"), forKeyPath:"tableName")
        anOrder.setValue(jsonDict.value(forKey: "tableText"), forKeyPath:"tableText")
        anOrder.setValue(jsonDict.value(forKey: "orderType"), forKeyPath:"orderType")
        anOrder.setValue(jsonDict.value(forKey: "guestCount"), forKeyPath:"guestCount")
        
        /*//turn it ON when live
        do{
            let date = try OPDateTools.convertToDateFromString(dateStr: jsonDict.value(forKey: "orderDate") as? String)
            anOrder.orderDate = date
        }catch{
            
        }*/
        
        let items = jsonDict.value(forKey: "orderItems") as! NSArray
        for item in items {
            
            _ = OrderItem.createItemFromJSONDict(jsonDict: item as! NSDictionary, container: sharedCoredataCoordinator.persistentContainer)
        }
        
        return anOrder
    }
    
    class func viewFetchRequest()->NSFetchRequest<NSFetchRequestResult>{
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
         let sd = NSSortDescriptor(key: "orderDate", ascending: false)
         fetchRequest.sortDescriptors = [sd]
         fetchRequest.predicate = NSPredicate(format: "isOpen=true")
         return fetchRequest as! NSFetchRequest<NSFetchRequestResult>
    }
    
    class func fetchOrderDetailsForDay(date: Date) -> NSDictionary{
        
        let dict : NSMutableDictionary? = NSMutableDictionary()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
        let sd = NSSortDescriptor(key: "orderDate", ascending: false)
        fetchRequest.sortDescriptors = [sd]
        fetchRequest.predicate = NSPredicate(format: "isOpen=false")
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
       var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: date)

       components.hour = 0
       components.minute = 0
       components.second = 0
       
       let fromDate = gregorian.date(from: components)! as NSDate
       
       var components2 = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: date)
       components2.hour = 23
       components2.minute = 59
       components2.second = 59
       
       let toDate = gregorian.date(from: components2)! as NSDate
       
       let predicate = NSPredicate(format: "(orderDate > %@) AND (orderDate < %@)", fromDate, toDate)
        fetchRequest.predicate = predicate
        
        do {
            let records = try sharedCoredataCoordinator.persistentContainer.viewContext.fetch(fetchRequest)
            
            if records.count > 0{
                
                let orderCount = records.count
                var itemsCount : Int? = 0
                var totalProcessingTime : Float? = 0
                var latOrderCount : Int? = 0
                for order in records{
                    
                    let anOrder = order as? Order
                    let items = OrderItem.getItemsForOrderId(orderId: anOrder!.orderId!) 
                    itemsCount! += items.count
                    totalProcessingTime! += Float((anOrder?.processingTime)!)
                    if anOrder!.isLateOrder{
                        
                        latOrderCount! += 1
                    }
                }
                
                let avgProcessing = Float(totalProcessingTime!)/Float(orderCount)
                
                dict?.setValue(orderCount, forKey: "OrderCount")
                dict?.setValue(itemsCount, forKey: "ItemsCount")
                dict?.setValue(avgProcessing, forKey: "AvgProcessingTime")
                dict?.setValue(latOrderCount, forKey: "LateOrders")
            }
        } catch _ as NSError {
            
            
        }

        return dict!
    }
}
