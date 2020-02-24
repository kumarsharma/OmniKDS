//
//  KDSummaryItem.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 18/02/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class KDSummaryItem: NSObject {

    @objc var itemName : String!
    @objc var quantity : NSNumber!
    
    convenience init(itemname : String, qty: Float){
        
        self.init()
        self.itemName = itemname
        self.quantity = NSNumber(value: qty)
    }
}
