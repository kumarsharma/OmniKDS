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
    
    class func datesFrom(fromDate: Date, toDate: Date)->[Date]{
        
        var dates : [Date]? = .init()
        
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: fromDate)
        let date2 = calendar.startOfDay(for: toDate)
        
        if date1.compare(date2) == .orderedSame{
            
            dates = [date1]
        }
        else if date1.compare(date2) == .orderedDescending{
            
            dates = [date2]
        }
        else{
        
            let totalDays = KSDateUtil.daysBetweenFirstDate(date1, secndDate: date2)
            if totalDays == 2{
                
                dates = [date1, date2]
            }else{
                
                for i in 0..<totalDays{
                    
                    let date = KSDateUtil.getNextDay(byCount: Int(i), from: date1)
                    dates?.append(calendar.startOfDay(for: date!))
                }
            }
        }
        
        return dates!
    }
    
    class func initializeToBegining(date:Date)->Date{
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = gregorian.components([.year, .day, .hour, .minute, .second], from: date)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return gregorian.date(from: components)!
    }
}
