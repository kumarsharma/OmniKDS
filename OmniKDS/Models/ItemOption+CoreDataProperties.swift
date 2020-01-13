//
//  ItemOption+CoreDataProperties.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemOption> {
        return NSFetchRequest<ItemOption>(entityName: "ItemOption")
    }

    @NSManaged public var itemName: String?
    @NSManaged public var itemName2: String?
    @NSManaged public var optionId: String?
    @NSManaged public var orderItemId: String?

}
