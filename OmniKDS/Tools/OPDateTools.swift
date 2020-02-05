//
//  OPDateTools.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class OPDateTools: NSObject {

    class func convertToDateFromString(dateStr: String?) throws -> Date{
        
        var date : Date! = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY, hh-mm-ss"
        
        if dateStr?.count == 0 || dateStr == nil{
            
            throw DBError.UnknownError
        }else{
            date = formatter.date(from: dateStr!)
            return date
        }
    }
    
    class func getTimeStringFrom(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
