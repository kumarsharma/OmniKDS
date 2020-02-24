//
//  KitchenTransaction+CoreDataClass.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData

@objc(KitchenTransaction)
public class KitchenTransaction: OPManagedObject {

    override class func primaryKeyName() -> String {
        
        return "trId"
    }

    class func addTransactionItem(itemId:String, orderId:String, startTime:Date, endTime:Date, qty:Int32, userId:String) -> KitchenTransaction{
        
        var aTransaction : KitchenTransaction?
        
        let trEntity = NSEntityDescription.entity(forEntityName: "KitchenTransaction", in: sharedCoredataCoordinator.persistentContainer.viewContext)
        aTransaction = NSManagedObject(entity: trEntity!, insertInto: sharedCoredataCoordinator.persistentContainer.viewContext) as? KitchenTransaction
        
        aTransaction?.date = Date.init()
        aTransaction?.itemId = itemId
        aTransaction?.orderId = orderId
        aTransaction?.startTime = startTime
        aTransaction?.endTime = endTime
        aTransaction?.trId = UUID().uuidString
        aTransaction?.userId = userId
        
        return aTransaction!
    }
}
