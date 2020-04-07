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

        let calendar = NSCalendar.current
        let startDate = calendar.startOfDay(for: date) as NSDate
        let endDate = calendar.date(byAdding: .day, value: 1, to: date, wrappingComponents: false)! as NSDate
        
        let predicate = NSPredicate(format: "(isOpen = false) && (orderDate >= %@ && orderDate < %@)", startDate, endDate)
        let sortD = NSSortDescriptor(key: "orderDate", ascending: false)
        fetchRequest.sortDescriptors = [sortD]
        fetchRequest.predicate = predicate 
        do {
            let records = try sharedCoredataCoordinator.persistentContainer.viewContext.fetch(fetchRequest)
            
            let orderCount = records.count
            var itemsCount : Int? = 0
            var totalProcessingTime : Float? = 0
            var latOrderCount : Int? = 0
            
            if records.count > 0{
                
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
                
                dict?.setValue(orderCount, forKey: ReportingKeys.TotalOrders)
                dict?.setValue(itemsCount, forKey: ReportingKeys.TotalItems)
                dict?.setValue(avgProcessing, forKey: ReportingKeys.AvgProcessingTime)
                dict?.setValue(latOrderCount, forKey: ReportingKeys.LateOrders)
            }
            else{
                
                let avgProcessing = Float(0)
                dict?.setValue(orderCount, forKey: ReportingKeys.TotalOrders)
                dict?.setValue(itemsCount, forKey: ReportingKeys.TotalItems)
                dict?.setValue(avgProcessing, forKey: ReportingKeys.AvgProcessingTime)
                dict?.setValue(latOrderCount, forKey: ReportingKeys.LateOrders)
            }
        } catch let error as NSError {
            
            print("\(error)")
        }

        return dict!
    }
}
