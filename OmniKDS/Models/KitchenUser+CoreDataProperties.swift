//
//  KitchenUser+CoreDataProperties.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData


extension KitchenUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KitchenUser> {
        return NSFetchRequest<KitchenUser>(entityName: "KitchenUser")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var isAdmin: Bool
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var userId: String?
    @NSManaged public var userPIN: String?

}
