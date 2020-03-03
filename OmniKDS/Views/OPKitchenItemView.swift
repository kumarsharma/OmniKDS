//
//  OPKitchenItemView.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 16/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class OPKitchenItemView: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var tableView : UITableView?
    var headerLabel : UILabel?
    var footerButton : UIButton?
    var order : Order?
    var soundEffect : AVAudioPlayer?
    var bgColor : UIColor?
    var timer : Timer?
    var servedByLabel : UILabel?
    
    lazy var itemFRC :  NSFetchedResultsController<NSFetchRequestResult> = {
        
        let orderId = self.order != nil ? self.order!.orderId! : "0" 
        
        let frc = NSFetchedResultsController(fetchRequest: OrderItem.viewFetchRequest(order_Id: orderId), managedObjectContext: sharedCoredataCoordinator.persistentContainer.viewContext, sectionNameKeyPath: "courseName", cacheName: nil)
        frc.delegate=self
        do{
            try frc.performFetch()
        }catch _{
            
        }
        return frc
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame:.zero)
        bgColor = UIColor(hexString: "E0E0E0")
        
        self.layer.cornerRadius=10
        self.layer.borderWidth=2
        self.layer.borderColor = UIColor.magenta.cgColor
    }
    
    func setupSubViews(){
        
        if headerLabel==nil{
            
            headerLabel=UILabel(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 70))
            headerLabel!.textColor=UIColor.black
            headerLabel!.backgroundColor=UIColor.red
            headerLabel?.numberOfLines=10
            headerLabel?.textAlignment = .center
            headerLabel?.font = KDTools.docketHeaderFont()
            headerLabel?.layer.cornerRadius=10
            headerLabel?.clipsToBounds=true
            headerLabel?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            tableView=UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
            tableView?.frame=CGRect.init(x: 0, y: headerLabel!.frame.size.height, width: self.frame.size.width, height: self.frame.size.height-headerLabel!.frame.size.height)
            tableView!.delegate=self; tableView!.dataSource=self
            
           let bgview = UIView(frame: tableView!.frame)
           bgview.backgroundColor = .clear
           tableView!.backgroundView=bgview
            tableView?.backgroundColor = .clear
            
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: (tableView?.frame.size.width)!, height: 64))
            footerView.backgroundColor = .clear
            
            servedByLabel = UILabel(frame: CGRect(x: 0, y: 0, width: footerView.frame.size.width, height: 20))
            servedByLabel?.backgroundColor = .lightGray
            servedByLabel?.font = .italicSystemFont(ofSize: 17)
            servedByLabel?.textAlignment = .center

            footerButton = UIButton(type: UIButton.ButtonType.custom)
            footerButton?.setImage(UIImage(named: "checkAllIcn"), for: UIControl.State.normal)
            footerButton?.frame=CGRect(x: 0, y: 20, width: footerView.frame.size.width, height: 44)
            footerButton?.addTarget(self, action: #selector(orderDoneButtonAction), for: UIControl.Event.touchUpInside)
            footerButton?.backgroundColor = .green
            footerButton?.isHidden = !self.hasDoneAllItems()
            footerButton?.layer.cornerRadius = 8
            footerButton?.layer.borderWidth = 0.5
            footerButton?.layer.borderColor = UIColor.darkGray.cgColor
            
            footerView.addSubview(servedByLabel!)
            footerView.addSubview(footerButton!)
            tableView?.tableFooterView=footerView
            
            self.addSubview(headerLabel!)
            self.addSubview(tableView!)
        }
    }

    @objc func orderDoneButtonAction(){
        
        order?.isOpen = false
        order?.closedAt = Date()
        sharedCoredataCoordinator.saveContext()
        
        if sharedKitchen!.closeDocketNotification{
        
            self.playSound(soundName: sharedKitchen!.closeDocketSoundName!)
        }
    }
    
     func reloadCell(){
        
//        kitchenItems=OrderItem.getItemsForOrderId(orderId: order!.orderId!)
        self.itemFRC.fetchRequest.predicate = NSPredicate(format: "orderId=%@", self.order!.orderId!)
        do{
            try self.itemFRC.performFetch()
        }catch{
            
        }
        
        bgColor = UIColor(hexString: "E0E0E0")
        tableView?.reloadData()
        self.updateHeaderWithTime()
        
        if order!.isOpen{
            
            self.footerButton?.isHidden = !self.hasDoneAllItems()
        }else{
            
            self.footerButton?.isHidden = true
        }
                
        if timer != nil && timer!.isValid{
            
            timer?.invalidate()
        }
        
        if order?.isOpen == true{
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateHeaderWithTime), userInfo: nil, repeats: true)
            timer?.fire()
        }
        
        if (order?.orderBy!.count)!>0{
            
            servedByLabel?.text = "Served by " + (order?.orderBy!)!
        }
    }
    
    @objc func updateHeaderWithTime(){

        var headerInfo = order!.orderType! + ": " + order!.tableName!
        
        headerInfo += " (" + order!.guestCount! + ")"
        headerInfo += "\nOrder#: " + order!.orderNo!
        if (order?.customerName!.count)! >= 1{
                
            headerInfo += "\nCustomer: " + order!.customerName!
        }
        
        if order?.orderDate != nil{

            let endDate = order!.isOpen ? Date() : order?.closedAt
            
            let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: order!.orderDate!, to: endDate!)
            let formattedString = String(format: "%02ld:%02ld:%02ld", difference.hour!, difference.minute!, difference.second!)

            headerInfo += "\n" + OPDateTools.getTimeStringFrom(date: order!.orderDate!) + ", \t" + formattedString
            
            if difference.minute! >= Int(sharedKitchen!.turnToYellowAfter){
                
                bgColor = .yellow
            }
            
            if difference.minute! >= Int(sharedKitchen!.turnToRedAfter){
                
                bgColor = .red
            }
        }
        
        self.layer.borderColor = bgColor?.cgColor
        headerLabel!.backgroundColor = bgColor
        headerLabel!.text=headerInfo
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if order?.isOpen == true{
            
            self.performDoneOnItemAt(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       
        if order?.isOpen == true{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = self.itemFRC.object(at: indexPath) as? OrderItem
        let title = item!.isFinished ? "Redo" : "Done"
        let action = UIContextualAction(style: UIContextualAction.Style.normal, title: title) { (action, view, completionHandler) in
            
            self.performDoneOnItemAt(indexPath: indexPath)
            completionHandler(true)
        }
        
        action.backgroundColor=UIColor.red
        
        let config = UISwipeActionsConfiguration(actions: [action])
//        config.performsFirstActionWithFullSwipe=false
        return config
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = .red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .orange
        header.textLabel?.font = .boldSystemFont(ofSize: 21)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    //MARK: play sound

    func playSound(soundName:String){
        
        let path = Bundle.main.path(forResource: soundName, ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
    }
    
    //MARK: Actions on individual Items
    
    func performDoneOnItemAt(indexPath: IndexPath){
        
        let item = self.itemFRC.object(at: indexPath) as? OrderItem
        if item!.isFinished{
            
            item?.isFinished=false
            
            if (sharedKitchen?.unDoItemNotification)!{
                
                self.playSound(soundName: sharedKitchen!.unDoItemSoundEffect!)
            }
        }else{
            item?.isFinished=true
            
            if sharedKitchen!.doneItemNotification{
                
                self.playSound(soundName: sharedKitchen!.doneItemSoundEffect!)
            }
        }
        sharedCoredataCoordinator.saveContext()
        self.footerButton?.isHidden = !self.hasDoneAllItems()
        self.tableView!.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        NotificationCenter.default.post(name: NSNotification.Name(kSomeItemStateDidChangeNotification), object: nil)
    }
    
    func hasDoneAllItems()->Bool{
        
        var kitchenItems : NSArray?
        kitchenItems = self.itemFRC.fetchedObjects as NSArray?
        let remainingItems = kitchenItems?.filtered(using: NSPredicate(format: "isFinished=false"))
        
        if remainingItems != nil{
            if remainingItems!.count <= 0{
                
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
}
