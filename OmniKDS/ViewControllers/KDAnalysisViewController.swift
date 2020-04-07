//
//  KDAnalysisViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 19/03/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class KDAnalysisViewController: UIViewController, OPDateSelectionDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var backgroundView: UIImageView?
    @IBOutlet weak var fromDateField: UITextField?
    @IBOutlet weak var submitButton: UIButton?
    @IBOutlet weak var segmentedControl : UISegmentedControl?
    @IBOutlet weak var dateBgView : UIView?
    var activeTextField : UITextField?
    var currentPopoverController : UIViewController?
    var fromDate: Date? = Date()
    var toDate: Date? = Date()
    var currentScoreCard : KDScoreCardView?
    var currentChartView : KSAnalysisChartView?
    
    let xPos = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fromDateField?.text = String(format: "%@ - %@", KSDateUtil.getShortDateOnlyString(self.fromDate), KSDateUtil.getShortDateOnlyString(self.toDate))

        self.title="Analytics"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelBtnAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneBtnAction))
        
        backgroundView?.frame = self.view.bounds
        dateBgView?.frame = CGRect(x: 30, y: 85, width: self.view.frame.size.width-60, height: (dateBgView?.frame.size.height)!)
        segmentedControl?.frame = CGRect(x: 30, y: (dateBgView?.frame.size.height)!+(dateBgView?.frame.origin.y)!, width: (dateBgView?.frame.size.width)!, height: (segmentedControl?.frame.size.height)!)
        
    }
    
    @objc func cancelBtnAction(){
           
        self.dismiss(animated: true, completion: nil)
    }

    @objc func doneBtnAction(){
            
        self.dismiss(animated: true, completion: nil)   
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        self.activeTextField = textField
        if textField == fromDateField{
            
            self.showCalendar()
            return false
        }
        
        return true
    }
    
    @objc func showCalendar(){
        
        let calendarVc = OPCalendarViewController(date1: self.fromDate, date2: self.toDate)
        calendarVc?.delegate = self
        let nav = UINavigationController(rootViewController: calendarVc!)
        nav.modalPresentationStyle = .popover
        
        let viewPresentationController = nav.popoverPresentationController
        if let presentationController = viewPresentationController{
            
            presentationController.delegate=self
            presentationController.sourceView=self.activeTextField
            presentationController.permittedArrowDirections=UIPopoverArrowDirection.any
         }
        
        nav.preferredContentSize = CGSize(width: 400, height: 345)
        self.present(nav, animated: true, completion: nil)
        self.currentPopoverController=nav
    }
    
    @IBAction func segmentedControlAction(sender:UISegmentedControl){
        
        self.fetchReports()
    }
    
    func didSelectDate1(_ date1: Date!, andDate2 date2: Date!) {
           
        self.fromDate = date1
        self.toDate = date2
        
        fromDateField?.text = String(format: "%@ - %@", KSDateUtil.getShortDateOnlyString(self.fromDate), KSDateUtil.getShortDateOnlyString(self.toDate))        
        self.currentPopoverController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fetchReports(){
        
        if segmentedControl?.selectedSegmentIndex == 0{
            
            self.showScoreCard()
        }else{
            
            self.showChartView()
        }
    }
       
    func showScoreCard(){
        
        if self.currentChartView != nil{
            
            self.currentChartView?.isHidden = true
        }
        
        if self.currentScoreCard == nil{
                   
           let scoreCard = KDScoreCardView.init()
           scoreCard.frame = CGRect(x: 30, y: (segmentedControl?.frame.size.height)!+(segmentedControl?.frame.origin.y)!, width: (segmentedControl?.frame.size.width)!, height: self.view.frame.size.height-((dateBgView?.frame.size.height)! + (segmentedControl?.frame.size.height)!)-105)
           self.currentScoreCard = scoreCard
           self.view.addSubview(scoreCard)
       }
       
        self.currentScoreCard?.isHidden = false
       self.currentScoreCard!.fromDate = self.fromDate!
       self.currentScoreCard!.toDate = self.toDate!
       self.currentScoreCard!.fetchScoreCard()
    }
    
    func showChartView(){
        
        if self.currentScoreCard != nil{
            
            self.currentScoreCard?.isHidden = true
        }
        
        if self.currentChartView == nil{
            
            let chartView = KSAnalysisChartView.init()
            chartView.frame = CGRect(x: 30, y: (segmentedControl?.frame.size.height)!+(segmentedControl?.frame.origin.y)!, width: (segmentedControl?.frame.size.width)!, height: self.view.frame.size.height-((dateBgView?.frame.size.height)! + (segmentedControl?.frame.size.height)!)-105)
            self.currentChartView = chartView
            self.view.addSubview(chartView)
        }
        
        self.currentChartView?.isHidden = false
        self.currentChartView!.fromDate = self.fromDate!
        self.currentChartView!.toDate = self.toDate!
        self.currentChartView!.fetchScoreCard()
    }
}
