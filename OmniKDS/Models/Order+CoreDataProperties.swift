//
//  Order+CoreDataProperties.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var closedAt: Date?
    @NSManaged public var customerName: String?
    @NSManaged public var orderBy: String?
    @NSManaged public var orderDate: Date?
    @NSManaged public var orderId: String?
    @NSManaged public var orderNo: String?
    @NSManaged public var tableName: String?
    @NSManaged public var tableText: String?
    @NSManaged public var isOpen: Bool
    @NSManaged public var orderType: String?
    @NSManaged public var guestCount: String?
    @NSManaged public var processingTime : Float
    @NSManaged public var isLateOrder : Bool
}
