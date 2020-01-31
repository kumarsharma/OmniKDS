//
//  KDSectionObject.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 21/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class KDSectionObject: NSObject {

    var sectionTitle : NSString?
    var rowObjects : NSArray?
    
    convenience init(title:NSString, objects:NSArray){
        
        self.init()
        sectionTitle=title
        rowObjects=objects
    }
}
