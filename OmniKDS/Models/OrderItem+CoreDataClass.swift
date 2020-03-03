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

    var itemOptions:NSArray?
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
        
        
        var course_Id = jsonDict.value(forKey: "courseId") as? String
        if course_Id == nil{
            
            course_Id = "0"
        }
        anItem.courseId = course_Id
        
        
        var course_Name = jsonDict.value(forKey: "courseName") as? String
        if course_Name == nil || course_Name!.count <= 0 {
            
            course_Name = "NO COURSE"
        }
        anItem.courseName = course_Name
        
        anItem.seatNo = jsonDict.value(forKey: "seatNo") as? String
        anItem.takenBy = jsonDict.value(forKey: "takenBy") as? String
        
        let str2:String! = jsonDict.value(forKey: "quantity") as? String 
        anItem.quantity = Float(str2) ?? 0
        
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
    
    class func getItemsForOrderId(orderId:String)-> NSArray{
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OrderItem")
        fetchRequest.predicate=NSPredicate(format: "orderId=%@",orderId)
        var records : NSArray?
        do {
            records = try sharedCoredataCoordinator.persistentContainer.viewContext.fetch(fetchRequest) as NSArray?
            
        } catch let error as NSError {
            
            print("Could not fetch the requested object. Error: \(error.userInfo)")
        }
        
        return records!
    }
    
    func getItemOptions()->NSArray{
        
        if itemOptions==nil{
            
            itemOptions = ItemOption.getOptionsForOrderItemId(orderItemId: self.orderItemId!) as NSArray?
        }
        
        return itemOptions!
    }
    
    class func viewFetchRequest(order_Id: String)->NSFetchRequest<NSFetchRequestResult>{
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OrderItem")
         let sd = NSSortDescriptor(key: "placeTime", ascending: false)
         let sd2 = NSSortDescriptor(key: "courseName", ascending: true)
         fetchRequest.sortDescriptors = [sd2, sd]
        
        if order_Id.elementsEqual("0"){
            
            fetchRequest.predicate = NSPredicate(format: "isFinished=false")
        }else{
            
            fetchRequest.predicate = NSPredicate(format: "orderId=%@", order_Id)
        }
         
         return fetchRequest as! NSFetchRequest<NSFetchRequestResult>
    }
}
