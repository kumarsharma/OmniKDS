//
//  OPDateTools.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class OPDateTools: NSObject {

    class func convertToDateFromString(dateStr: String) -> Date{
        
        var date : Date! = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        date = formatter.date(from: dateStr)
        
        return date
    }
}
