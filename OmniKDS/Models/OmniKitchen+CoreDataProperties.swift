//
//  OmniKitchen+CoreDataProperties.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData


extension OmniKitchen {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OmniKitchen> {
        return NSFetchRequest<OmniKitchen>(entityName: "OmniKitchen")
    }

    @NSManaged public var bgColor: String?
    @NSManaged public var fontSize: Int32
    @NSManaged public var kitchenId: Int32
    @NSManaged public var kitchenName: String?
    @NSManaged public var soundMode: Bool
    @NSManaged public var soundType: String?
    @NSManaged public var ticketSize: Int32
    @NSManaged public var turnToRedAfter: Int32
    @NSManaged public var turnToYellowAfter: Int32
    @NSManaged public var viewMode: Int32

}
