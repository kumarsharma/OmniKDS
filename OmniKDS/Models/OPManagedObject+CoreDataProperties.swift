//
//  OPManagedObject+CoreDataProperties.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData


extension OPManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OPManagedObject> {
        return NSFetchRequest<OPManagedObject>(entityName: "OPManagedObject")
    }


}
