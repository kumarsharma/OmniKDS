//
//  OPKitchenItemView.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 16/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import AVFoundation

class OPKitchenItemView: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var kitchenItems : NSArray?
    var tableView : UITableView?
    var headerLabel : UILabel?
    var footerButton : UIButton?
    var order : Order?
    var soundEffect : AVAudioPlayer?
    
    override init(frame: CGRect) {
        
        super.init(frame:.zero)
//        self.contentView.layer.cornerRadius=10
//        self.contentView.layer.borderWidth=2
//        self.contentView.layer.borderColor = UIColor.magenta.cgColor
        
        self.layer.cornerRadius=10
        self.layer.borderWidth=2
        self.layer.borderColor = UIColor.magenta.cgColor
   
    }
    
    func setupSubViews(){
        
        if headerLabel==nil{
            kitchenItems = []
            headerLabel=UILabel(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 70))
            headerLabel!.text="Table 1         10min"
            headerLabel!.textColor=UIColor.white
            headerLabel!.backgroundColor=UIColor.red
            headerLabel?.numberOfLines=10
            headerLabel?.textAlignment = .center
            headerLabel?.font = UIFont.boldSystemFont(ofSize: 19)
            
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
            
            footerButton = UIButton(type: UIButton.ButtonType.close)
            footerButton?.frame=CGRect(x: 0, y: 0, width: 44, height: 44)
            footerButton?.addTarget(self, action: #selector(orderDoneButtonAction), for: UIControl.Event.touchUpInside)
            footerButton?.backgroundColor = .green
            footerButton?.isHidden=true
            tableView?.tableFooterView=footerButton
            
            self.addSubview(headerLabel!)
            self.addSubview(tableView!)
        }
    }
    
    @objc func orderDoneButtonAction(){
        
        order?.isOpen = false
        sharedCoredataCoordinator.saveContext()
        self.playSound(soundName: "successful")
    }
    
    func reloadCell(){
        
        kitchenItems=OrderItem.getItemsForOrderId(orderId: order!.orderId!)
        tableView?.reloadData()
        self.updateHeaderWithTime()
    }
    
    func updateHeaderWithTime(){
        
        var headerInfo = order!.orderType! + ": " + order!.tableName!
        headerInfo += "\nOrder#: " + order!.orderNo!
        if (order?.customerName!.count)! >= 1{
                
            headerInfo += "\nCustomer: " + order!.customerName!
        }
        
        if order?.orderDate != nil{

            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            
            let now = Date.init()
            let formStr = formatter.string(from: order!.orderDate!, to: now)!
            
            headerInfo += "\n" + OPDateTools.getTimeStringFrom(date: order!.orderDate!) + "\t" + formStr
        }
        headerLabel!.text=headerInfo
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.kitchenItems!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.kitchenItems?.object(at: indexPath.row) as? OrderItem
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
            
        }
        let item = self.kitchenItems?.object(at: indexPath.row) as? OrderItem
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
        
        let item = self.kitchenItems?.object(at: indexPath.row) as? OrderItem
        
        let title = item!.isFinished ? "Redo" : "Done"
        let action = UIContextualAction(style: UIContextualAction.Style.normal, title: title) { (action, view, completionHandler) in
            
            if item!.isFinished{
                
                item?.isFinished=false
                self.playSound(soundName: "redo")
            }else{
                item?.isFinished=true
                self.playSound(soundName: "done")
            }
            sharedCoredataCoordinator.saveContext()
            
            let remainingItems = self.kitchenItems?.filtered(using: NSPredicate(format: "isFinished=false"))
            if remainingItems!.count <= 0{
                
                self.footerButton?.isHidden = false
            }else{
                self.footerButton?.isHidden=true
            }
            
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
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
    
    
}
