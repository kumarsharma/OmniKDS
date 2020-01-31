//
//  KDRowObject.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 21/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class KDRowObject: NSObject {

    var dbObject:OPManagedObject?
    var rowType:RowType?
    var rowName:NSString?
    var rowValue:NSObject?
    
    convenience init(row_Type:RowType, row_Name:NSString, row_Value:NSObject) {
        self.init()
        
        rowName=row_Name
        rowValue=row_Value
        rowType=row_Type
    }
    
    
}
