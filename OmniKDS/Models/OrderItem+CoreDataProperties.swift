//
//  OrderItem+CoreDataProperties.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderItem> {
        return NSFetchRequest<OrderItem>(entityName: "OrderItem")
    }

    @NSManaged public var courseId: String?
    @NSManaged public var courseName: String?
    @NSManaged public var endTime: Date?
    @NSManaged public var isFinished: Bool
    @NSManaged public var isStarted: Bool
    @NSManaged public var itemId: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemName2: String?
    @NSManaged public var note: String?
    @NSManaged public var orderId: String?
    @NSManaged public var orderItemId: String?
    @NSManaged public var placeTime: Date?
    @NSManaged public var quantity: Float
    @NSManaged public var seatNo: String?
    @NSManaged public var startTime: Date?
    @NSManaged public var takenBy: String?

}
