//
//  KDScoreCardView.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 06/04/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class KDScoreCardView: UIView {

    var fromDate : Date?
    var toDate : Date?
    var currentGridView : KSGridView?
    
    public func fetchScoreCard(){
        
        self.backgroundColor = UIColor.init(hexString: sharedKitchen!.bgColor!)
        let dates = OPDateTools.datesFrom(fromDate: fromDate!, toDate: toDate!)
        
        var colHeaders : [String]? = ["Date"]
        var gridData : [Any]? = [Array<Any>.init()]        
        var sl : Int? = 1
        for date in dates{
         
            colHeaders?.append(KSDateUtil.getShortDateOnlyString(date))
            let orderDetails = Order.fetchOrderDetailsForDay(date: date)
            
            if orderDetails.allKeys.count > 0{
               
                var data : Array? = Array<String>.init()
                let avgProcTime = orderDetails.value(forKey: ReportingKeys.AvgProcessingTime) as! NSNumber
                data?.append("")
//                data?.append(KSDateUtil.getShortDateOnlyString(date))
                data?.append("\(orderDetails.value(forKey: ReportingKeys.TotalOrders) ?? "")")
                data?.append("\(orderDetails.value(forKey: ReportingKeys.TotalItems) ?? "")")
                data?.append(String(format: "%0.2f min", avgProcTime.floatValue))
                data?.append("\(orderDetails.value(forKey: ReportingKeys.LateOrders) ?? "")")
                sl! += 1
                
                gridData?.append(data!)
            }
        }
        
        if self.currentGridView == nil{
            
            let gridView = KSGridView.init()
                gridView.showInFullView = true
            gridView.headerText1 = String(format : "Scorecard\n%@", (sharedKitchen?.kitchenName!)!)
            gridView.frame = self.bounds
            self.currentGridView = gridView
            gridView.setupViews()
            self.addSubview(gridView)
        }
                
        if gridData!.count>1{
            
            let rowHeaders : [String]? = ["Date", "Total Orders", "Total Items", "Avg Processing Time", "Late Orders"]
            
            let section1 = KSGridSection.init(rowHeaders: rowHeaders, columnHeaders: colHeaders, gridData: gridData, andTitle: "Scorecard")
            let sections = [section1]
            self.currentGridView?.gridSections = sections as [Any]
        }
        else{
            
            self.currentGridView?.gridSections = []
        }
        
        self.currentGridView?.reloadGrid()
    }

}
