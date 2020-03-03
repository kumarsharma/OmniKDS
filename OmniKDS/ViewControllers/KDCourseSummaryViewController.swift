//
//  KDCourseSummaryViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 03/03/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData

class KDCourseSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var itemsTableView : UITableView?
    var headerLabel : UILabel?
    
    lazy var itemFRC :  NSFetchedResultsController<NSFetchRequestResult> = {
        
        let orderId = "0" 
        
        let frc = NSFetchedResultsController(fetchRequest: OrderItem.viewFetchRequest(order_Id: orderId), managedObjectContext: sharedCoredataCoordinator.persistentContainer.viewContext, sectionNameKeyPath: "courseName", cacheName: nil)
        frc.delegate=self
        do{
            try frc.performFetch()
        }catch _{
            
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Items by Course"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelBtnAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneBtnAction))
     
        headerLabel=UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 70))
         headerLabel!.textColor=UIColor.black
         headerLabel!.backgroundColor=UIColor.red
         headerLabel?.numberOfLines=10
         headerLabel?.textAlignment = .center
         headerLabel?.font = KDTools.docketHeaderFont()
         headerLabel?.layer.cornerRadius=10
         headerLabel?.clipsToBounds=true
         headerLabel?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         
         itemsTableView=UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
         itemsTableView?.frame=CGRect.init(x: 0, y: headerLabel!.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height-headerLabel!.frame.size.height)
         itemsTableView!.delegate=self; itemsTableView!.dataSource=self
         
        let bgview = UIView(frame: itemsTableView!.frame)
        bgview.backgroundColor = .clear
        itemsTableView!.backgroundView=bgview
        itemsTableView?.backgroundColor = .clear
         
         let footerView = UIView(frame: CGRect(x: 0, y: 0, width: (itemsTableView?.frame.size.width)!, height: 64))
         footerView.backgroundColor = .clear   
//        self.view.addSubview(headerLabel!)
        self.view.addSubview(itemsTableView!)
    }
    
    @objc func cancelBtnAction(){
           
        self.dismiss(animated: true, completion: nil)
    }
       
    @objc func doneBtnAction(){
          
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.itemFRC.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = self.itemFRC.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = self.itemFRC.sections?[section] else {
            return nil
        }
        return sectionInfo.name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.itemFRC.object(at: indexPath) as? OrderItem
        let optionCount = item?.getItemOptions().count
        var h = 30+(optionCount!*20)
        if (item?.note!.count)! > 0{
         
            h += 20
        }
        
        if (item?.seatNo!.count)! > 0{
         
            h += 20
        }
        
        return CGFloat(h)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cell.textLabel?.numberOfLines=10
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.layer.cornerRadius=5
            cell.layer.borderWidth=1
            cell.layer.borderColor = UIColor.brown.cgColor
            
            cell.textLabel?.font = KDTools.docketTextFont()
        }
        let item = self.itemFRC.object(at: indexPath) as? OrderItem
        var title = String(format:"%0.0f X ", item!.quantity)+item!.itemName!
        if (item?.getItemOptions().count)!>=1{
            
            for item_op in (item?.getItemOptions())! {
                
                let op = item_op as! ItemOption
                title += "\n ~~"+op.itemName!
            }
        }
        
        if (item?.note!.count)! > 0{
         
            title += "\n -"+item!.note!
        }
        
        if (item?.seatNo!.count)! > 0{
         
            title += "\n #"+item!.seatNo!
        }
        
        cell.textLabel?.text=title
        
        if item!.isFinished{
            
            cell.backgroundColor = UIColor.black
            cell.textLabel?.textColor=UIColor.green
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            
            cell.backgroundColor = UIColor.lightGray
            cell.textLabel?.textColor=UIColor.black
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
          
          view.tintColor = .red
          let header = view as! UITableViewHeaderFooterView
          header.textLabel?.textColor = .orange
          header.textLabel?.font = .boldSystemFont(ofSize: 27)
    }
}
