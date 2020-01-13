//
//  KitchenUser+CoreDataClass.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData

@objc(KitchenUser)
public class KitchenUser: OPManagedObject {

    override class func primaryKeyName() -> String {
        
        return "userId"
    }
}
