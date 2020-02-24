//
//  OPSettingsViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 20/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class OPSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, OPColorPickerDelegate,UITextFieldDelegate,KDPickerDelegate, NSFetchedResultsControllerDelegate {

    var sectionObjects : NSArray?
    var settingsTableView:UITableView?
    var selectedBgColorHex : String?
    var currentPopoverController : UIViewController?
    var soundEffect : AVAudioPlayer?
    @IBOutlet weak var userTableView:UITableView?
    
    @IBOutlet weak var bgColorButton : UIButton?
    @IBOutlet weak var kitchenNameField:UITextField?
    @IBOutlet weak var soundModeSwitch:UISwitch?
    @IBOutlet weak var soundTypeField:UITextField?
    @IBOutlet weak var docketSizeControl:UISegmentedControl?
    @IBOutlet weak var turnToRedField:UITextField?
    @IBOutlet weak var turnToYelloField:UITextField?
    @IBOutlet weak var controlsBgView:UIView?
    @IBOutlet weak var userBgView:UIView?
    @IBOutlet weak var mainBgView:UIView?
    
    @IBOutlet weak var addUserButton : UIButton?
    
    var userFRC : NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Display Settings"

        let sharedKitchen = OmniKitchen.getSharedKItchen(container: sharedCoredataCoordinator.getPersistentContainer())
        kitchenNameField?.text=sharedKitchen.kitchenName
        turnToRedField?.text="\(sharedKitchen.turnToRedAfter)"
        turnToYelloField?.text="\(sharedKitchen.turnToYellowAfter)"
        soundModeSwitch?.isOn=sharedKitchen.soundMode
        docketSizeControl?.selectedSegmentIndex=Int(sharedKitchen.ticketSize)
        soundTypeField?.text=sharedKitchen.soundType
                
        if sharedKitchen.soundType!.count>0{
            
            soundTypeField?.rightViewMode = UITextField.ViewMode.always
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: 0, y: 0, width: 200, height: (soundTypeField?.frame.size.height)!)
            btn.setTitleColor(.blue, for: UIControl.State.normal)
            btn.setTitle("▶️", for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(playBtnAction), for: UIControl.Event.touchUpInside)
            soundTypeField?.rightView=btn
        }
        
        self.selectedBgColorHex=sharedKitchen.bgColor
        bgColorButton?.backgroundColor=UIColor.init(hexString: self.selectedBgColorHex!)
        bgColorButton?.layer.cornerRadius=15
        bgColorButton?.layer.borderWidth=0.5
        bgColorButton?.layer.borderColor=UIColor.darkGray.cgColor
        
        
        let privacyBtn=UIBarButtonItem(image: UIImage(named: "privacyIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(privacyAction))
        let saveBtn=UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(saveChanges))
        self.navigationItem.rightBarButtonItems = [saveBtn, privacyBtn]
        
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: UIImage(named: "closeIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissView))
            
        userFRC = NSFetchedResultsController(fetchRequest: KitchenUser.viewFetchRequest(), managedObjectContext: sharedCoredataCoordinator.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        userFRC?.delegate=self
        do{
            try userFRC?.performFetch()
        }catch _{
            
        }
        
        if !loggedInUser!.isAdmin {
            
            addUserButton?.isEnabled = false
            kitchenNameField?.isUserInteractionEnabled=false
            turnToRedField?.isUserInteractionEnabled=false
            turnToYelloField?.isUserInteractionEnabled=false
            bgColorButton?.isUserInteractionEnabled=false
            soundModeSwitch?.isUserInteractionEnabled=false
            soundTypeField?.isUserInteractionEnabled=false
            docketSizeControl?.isUserInteractionEnabled=false
        }
        
        controlsBgView?.layer.borderWidth = 2
        controlsBgView?.layer.borderColor = UIColor.darkGray.cgColor
        controlsBgView?.layer.cornerRadius = 5
        
        userBgView?.layer.borderWidth = 2
        userBgView?.layer.borderColor = UIColor.darkGray.cgColor
        userBgView?.layer.cornerRadius = 5
        
//        mainBgView?.frame = self.view.bounds
        mainBgView?.backgroundColor = .clear
        mainBgView?.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
    }
    
    @objc func playBtnAction(){
        
        let sharedKitchen = OmniKitchen.getSharedKItchen(container: sharedCoredataCoordinator.getPersistentContainer())
        let path = Bundle.main.path(forResource: "\(sharedKitchen.soundType!)", ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
    }
    
    @objc func dismissView(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (userFRC?.fetchedObjects!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil{
            
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        let user = userFRC?.object(at: indexPath) as? KitchenUser
        cell.textLabel?.text=user!.firstName!+" "+user!.lastName!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if loggedInUser!.isAdmin {
           
            let user = userFRC?.object(at: indexPath) as! KitchenUser
            let cell = tableView.cellForRow(at: indexPath)
            let userVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UserViewController") as? KDUserViewController
            userVc?.currentUser = user
            userVc!.modalPresentationStyle = .popover
           
            let viewPresentationController = userVc!.popoverPresentationController
            if let presentationController = viewPresentationController{
               
                   presentationController.delegate=self
                   presentationController.sourceView=cell
                   presentationController.permittedArrowDirections=UIPopoverArrowDirection.any
            }
           
            userVc!.preferredContentSize = CGSize(width: 900, height: 200)
            self.present(userVc!, animated: true, completion: nil)
            self.currentPopoverController=userVc!
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: IB Actions
    @IBAction func bgColorButtonAction(sender:UIButton){
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:100, height:100)
        layout.scrollDirection = .vertical
        let colorVc = OPColorPickerController(collectionViewLayout: layout)
        colorVc.modalPresentationStyle = .popover
        colorVc.delegate=self
        let viewPresentationController = colorVc.popoverPresentationController
        if let presentationController = viewPresentationController {
            presentationController.delegate = self
            presentationController.sourceView = bgColorButton
            presentationController.permittedArrowDirections = UIPopoverArrowDirection.left
        }
        
        colorVc.preferredContentSize=CGSize(width: 500, height: 700)
        self.present(colorVc, animated: true, completion: nil)
        self.currentPopoverController=colorVc
    }
    
    @IBAction func soundModeSwitchAction(sender:UISwitch){
        
        
    }
    
    @IBAction func docketSizeBarAction(sender:UISegmentedControl){
        
        
    }
    
    @objc func saveChanges(){
        
        let sharedKitchen = OmniKitchen.getSharedKItchen(container: sharedCoredataCoordinator.getPersistentContainer())
        
        sharedKitchen.kitchenName = kitchenNameField?.text
        let n=turnToRedField?.text as NSString?
        sharedKitchen.turnToRedAfter = n?.intValue ?? 0
        
        let m=turnToYelloField?.text as NSString?
        sharedKitchen.turnToYellowAfter=m?.intValue ?? 0
        
        sharedKitchen.soundMode=soundModeSwitch!.isOn
        sharedKitchen.ticketSize=Int32(docketSizeControl?.selectedSegmentIndex ?? 0)
        sharedKitchen.bgColor=self.selectedBgColorHex!
        sharedKitchen.soundType=soundTypeField?.text
        sharedCoredataCoordinator.saveContext()
        
        //dismiss now
        dismissView()
    }
    
    func didSelectColorHex(colorHex: String) {
     
        let sharedKitchen = OmniKitchen.getSharedKItchen(container: sharedCoredataCoordinator.getPersistentContainer())
        bgColorButton?.backgroundColor=UIColor.init(hexString: colorHex)
        sharedKitchen.bgColor=colorHex
        sharedCoredataCoordinator.saveContext()
        self.selectedBgColorHex=colorHex
        
        if self.currentPopoverController != nil{
            self.currentPopoverController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: text-field delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if textField == soundTypeField{
            
            self.showSoundTypeSelectionUI()
            return false
        }
        
        return true
    }
    
    func showSoundTypeSelectionUI(){
        
        let pickerVc = KDPickerController(style: UITableView.Style.grouped)
        pickerVc.delegate=self
        pickerVc.itemList=NSArray(array: ["sound1","sound2", "sound3", "sound4", "sound5"])
        pickerVc.selectedItem=soundTypeField?.text
        let navVc = UINavigationController(rootViewController: pickerVc)
        navVc.modalPresentationStyle = .popover
        
        let viewPresentationController = navVc.popoverPresentationController
        if let presentationController = viewPresentationController{
            
            presentationController.delegate=self
            presentationController.sourceView=soundTypeField
            presentationController.permittedArrowDirections=UIPopoverArrowDirection.down
        }
        
        navVc.preferredContentSize = CGSize(width: 300, height: 450)
        self.present(navVc, animated: true, completion: nil)
        self.currentPopoverController=pickerVc
    }
    
    func didSelectItem(item: String) {
    
        soundTypeField?.text=item
    }
    
    // MARK: Users
    @IBAction func addUserBtnAction(sender:UIButton){
        
        let userVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UserViewController") as? KDUserViewController
        
        userVc!.modalPresentationStyle = .popover
       
        let viewPresentationController = userVc!.popoverPresentationController
        if let presentationController = viewPresentationController{
           
               presentationController.delegate=self
               presentationController.sourceView=sender
               presentationController.permittedArrowDirections=UIPopoverArrowDirection.any
        }
       
        userVc!.preferredContentSize = CGSize(width: 900, height: 200)
        self.present(userVc!, animated: true, completion: nil)
        self.currentPopoverController=userVc!
    }
    
    @objc func privacyAction(){
        
        let alert = UIAlertController(title: "Enter password", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField()
        alert.textFields![0].isSecureTextEntry = true
        alert.textFields![0].textAlignment = .center
        alert.textFields![0].font = UIFont.boldSystemFont(ofSize: 12)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { [unowned alert] _ in
            
            let pwd = alert.textFields![0]
            self.performSelector(onMainThread: #selector(self.checkPasswordAndPresentPrivacyAlert), with: pwd.text, waitUntilDone: false)
            
        }))
        self.present(alert, animated: true) { }
    }
    
    @objc func checkPasswordAndPresentPrivacyAlert(password:String){
        
        if loggedInUser?.userPIN! == password{
            
            let alert = UIAlertController(title: "Admin Action", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Clear All Dockets", style: UIAlertAction.Style.destructive, handler: { [unowned alert] _ in
                
               
                
            }))
            
            alert.addAction(UIAlertAction(title: "Reload Sample Dockets", style: UIAlertAction.Style.default, handler: { [unowned alert] _ in
                
               
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true) {}
            
        }else{
            
            let alert = UIAlertController(title: "Incorrect Password", message: "The entered password is incorrect. Please try again!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true) {}
        }
    }
    
    @objc func clearAllDockets(){
        
        
    }
    
    // MARK: Loading Sample Orders
    @objc func loadSampleOrders(){
        
        let filePath = Bundle.main.path(forResource: "SampleOrders", ofType: "txt")
        let url = URL.init(fileURLWithPath: filePath!)
        
        do{
            let ordersFromFile = try String(contentsOf: url)            
            if ordersFromFile.count>0
            {
                var dictionary : Dictionary<String, Any>?
                let data = Data(ordersFromFile.utf8)
                    
                do{
                    dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    
                    let dict = NSDictionary(dictionary: dictionary!)
                    if dict != nil{
                        
                        let allOrders = (dict.value(forKey: "SampleOrders") as? NSArray)!
                        
                        for orderDict in allOrders{
                        
                            let newOrder = Order.createOrderFromJSONDict(jsonDict: orderDict as! NSDictionary, container: sharedCoredataCoordinator.persistentContainer)
                            if newOrder != nil{
                                sharedCoredataCoordinator.saveContext()
                            }
                        }
                    }
                }catch let error as NSError{
                    
                    print("error in parsing \(error.userInfo)")
                }
            }
            
            
        }catch{
            
        }
    }
}

/**
 Archived codes:
 /*
  @NSManaged public var bgColor: String?
     @NSManaged public var fontSize: Int32
     @NSManaged public var kitchenId: Int32
     @NSManaged public var kitchenName: String?
     @NSManaged public var soundMode: Bool
     @NSManaged public var soundType: String?
     @NSManaged public var ticketSize: Int32
     @NSManaged public var turnToRedAfter: Int32
     @NSManaged public var turnToYellowAfter: Int32
     @NSManaged public var viewMode: Int32
  */
 /*let row1 = KDRowObject(row_Type: RowType.RowTypeColor, row_Name: "Background Color", row_Value: sharedKitchen.bgColor! as NSObject)
 let row2 = KDRowObject(row_Type: RowType.RowTypeSlider, row_Name: "Docket Font", row_Value: sharedKitchen.fontSize as NSObject)
 let row3 = KDRowObject(row_Type: RowType.RowTypeText, row_Name: "Kitchen Name", row_Value: sharedKitchen.kitchenName! as NSObject)
 
 let row4 = KDRowObject(row_Type: RowType.RowTypeBool, row_Name: "Sound On/Off", row_Value: sharedKitchen.soundMode as NSObject)
 let row5 = KDRowObject(row_Type: RowType.RowTypeList, row_Name: "Sound Type", row_Value: sharedKitchen.soundType! as NSObject)
 let row6 = KDRowObject(row_Type: RowType.RowTypeSegment, row_Name: "Docket Size", row_Value: sharedKitchen.ticketSize as NSObject)
 
 let row7 = KDRowObject(row_Type: RowType.RowTypeText, row_Name: "Turn to Red after", row_Value: sharedKitchen.turnToRedAfter as NSObject)
 let row8 = KDRowObject(row_Type: RowType.RowTypeText, row_Name: "Turn to Yellow after", row_Value: sharedKitchen.turnToYellowAfter as NSObject)
 let row9 = KDRowObject(row_Type: RowType.RowTypeText, row_Name: "Kitchen Name", row_Value: sharedKitchen.kitchenName! as NSObject)
 let objects = NSArray(array: [row1, row2, row3, row4, row5, row6, row7, row8, row9])
 let sectionObject = KDSectionObject(title: "Settings", objects: objects)
 sectionObjects = NSArray(array: [sectionObject])
 
 settingsTableView = UITableView(frame: CGRect(x: 50, y: 50, width: 500, height: 600), style: UITableView.Style.grouped)
 settingsTableView?.delegate=self
 settingsTableView?.dataSource=self
 
 self.view.addSubview(settingsTableView!)*/
 */
