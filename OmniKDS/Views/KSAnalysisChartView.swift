//
//  KSAnalysisChartView.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 07/04/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import SwiftChart

class KSAnalysisChartView: UIView {

    var fromDate : Date?
    var toDate : Date?
    var currentChartView : Chart?
        
    public func fetchScoreCard(){
        
        self.backgroundColor = .darkGray //UIColor.init(hexString: sharedKitchen!.bgColor!)
        let dates = OPDateTools.datesFrom(fromDate: fromDate!, toDate: toDate!)
        
        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height/2))
        let label1 = UILabel(frame: CGRect(x: 10, y: 5, width: firstView.bounds.size.width-20, height: 33))
        label1.layer.borderWidth = 0.5
        label1.layer.borderColor = UIColor.lightGray.cgColor
        label1.text = "Order Counts"
        firstView.layer.borderColor = UIColor.darkGray.cgColor
        firstView.layer.borderWidth = 1
        firstView.layer.cornerRadius = 10
        firstView.addSubview(label1)
        
        let chart = Chart(frame: CGRect(x: 100, y: 40, width: firstView.bounds.size.width/2, height: firstView.bounds.size.height-50))
        
        var xLabels : [Double] = .init()        
        var gridData : [Double]? = .init() 
        
        for date in dates{
            
            let orderDetails = Order.fetchOrderDetailsForDay(date: date)
            
            if orderDetails.allKeys.count > 0{
                
                let no = orderDetails.value(forKey: ReportingKeys.TotalOrders) as! NSNumber
                gridData?.append(no.doubleValue)
                
                let calendar = Calendar.current
                let comps = calendar.dateComponents([.day], from: date)
                xLabels.append(Double(comps.day!))
            }
        }
        
        let series = ChartSeries(gridData!)
        chart.xLabels = xLabels
        chart.xLabelsFormatter = { String(Int(round($1))) + "h" }
        chart.add(series)
        series.area = true
        series.color = .green
        
        firstView.addSubview(chart)
        self.addSubview(firstView)
    }

}
