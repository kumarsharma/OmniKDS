//
//  KitchenTransaction+CoreDataProperties.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData


extension KitchenTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KitchenTransaction> {
        return NSFetchRequest<KitchenTransaction>(entityName: "KitchenTransaction")
    }

    @NSManaged public var date: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var itemId: String?
    @NSManaged public var orderId: String?
    @NSManaged public var quantity: Int32
    @NSManaged public var startTime: Date?
    @NSManaged public var trId: String?
    @NSManaged public var userId: String?
    @NSManaged public var itemName: String?
}
