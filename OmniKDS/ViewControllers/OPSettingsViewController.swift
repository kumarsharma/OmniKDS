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
    var selectedBgColorHex : String?
    var currentPopoverController : UIViewController?
    var soundEffect : AVAudioPlayer?
    var activeTextField : UITextField?

    @IBOutlet weak var userTableView:UITableView?
    @IBOutlet weak var bgColorButton : UIButton?
    @IBOutlet weak var kitchenNameField:UITextField?
    @IBOutlet weak var newDocketNotiSwitch:UISwitch?
    @IBOutlet weak var closeDocketNotiSwitch:UISwitch?
    @IBOutlet weak var newDocketSoundField:UITextField?
    @IBOutlet weak var closeDocketSoundField:UITextField?
    @IBOutlet weak var docketSizeControl:UISegmentedControl?
    @IBOutlet weak var turnToRedField:UITextField?
    @IBOutlet weak var turnToYelloField:UITextField?
    @IBOutlet weak var controlsBgView:UIView?
    @IBOutlet weak var userBgView:UIView?
    @IBOutlet weak var mainBgView:UIView?
    @IBOutlet weak var newDocketBgView:UIView?
    @IBOutlet weak var docketDoneBgView:UIView?
    
    @IBOutlet weak var itemDoneBgView:UIView?
    @IBOutlet weak var itemUnDoneBgView:UIView?
    
    @IBOutlet weak var itemDoneNotiSwitch:UISwitch?
    @IBOutlet weak var itemDoneSoundField:UITextField?
    @IBOutlet weak var itemUnDoNotiSwitch:UISwitch?
    @IBOutlet weak var itemUnDoSoundField:UITextField?
    
    @IBOutlet weak var templateButtonOne : UIButton?
    @IBOutlet weak var templateButtonTwo : UIButton?
    
    @IBOutlet weak var addUserButton : UIButton?
    @IBOutlet weak var versionLabel:UILabel?
    var userFRC : NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Display Settings"

        let sharedKitchen = OmniKitchen.getSharedKitchen(container: sharedCoredataCoordinator.getPersistentContainer())
        kitchenNameField?.text=sharedKitchen.kitchenName
        turnToRedField?.text="\(sharedKitchen.turnToRedAfter)"
        turnToYelloField?.text="\(sharedKitchen.turnToYellowAfter)"
        docketSizeControl?.selectedSegmentIndex=Int(sharedKitchen.docketSize)
        newDocketNotiSwitch?.isOn=sharedKitchen.newDocketNotification
        newDocketSoundField?.text=sharedKitchen.newDocketSoundName
        
        closeDocketNotiSwitch?.isOn=sharedKitchen.closeDocketNotification
        closeDocketSoundField?.text=sharedKitchen.closeDocketSoundName
        
        itemDoneNotiSwitch?.isOn=sharedKitchen.doneItemNotification
        itemDoneSoundField?.text=sharedKitchen.doneItemSoundEffect
        itemUnDoNotiSwitch?.isOn=sharedKitchen.unDoItemNotification
        itemUnDoSoundField?.text=sharedKitchen.unDoItemSoundEffect
                
        if sharedKitchen.newDocketSoundName!.count>0{
            
            newDocketSoundField?.rightViewMode = UITextField.ViewMode.always
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: 0, y: 0, width: 200, height: (newDocketSoundField?.frame.size.height)!)
            btn.setTitleColor(.blue, for: UIControl.State.normal)
            btn.setTitle("▶️", for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(playNewDocketSoundName), for: UIControl.Event.touchUpInside)
            newDocketSoundField?.rightView=btn
        }
        
        if sharedKitchen.closeDocketSoundName!.count>0{
            
            closeDocketSoundField?.rightViewMode = UITextField.ViewMode.always
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: 0, y: 0, width: 200, height: (closeDocketSoundField?.frame.size.height)!)
            btn.setTitleColor(.blue, for: UIControl.State.normal)
            btn.setTitle("▶️", for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(playCloseDocketSoundName), for: UIControl.Event.touchUpInside)
            closeDocketSoundField?.rightView=btn
        }
        
        if sharedKitchen.doneItemSoundEffect!.count>0{
            
            itemDoneSoundField?.rightViewMode = UITextField.ViewMode.always
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: 0, y: 0, width: 200, height: (itemDoneSoundField?.frame.size.height)!)
            btn.setTitleColor(.blue, for: UIControl.State.normal)
            btn.setTitle("▶️", for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(playItemDoneSoundEffect), for: UIControl.Event.touchUpInside)
            itemDoneSoundField?.rightView=btn
        }
        
        if sharedKitchen.unDoItemSoundEffect!.count>0{
            
            itemUnDoSoundField?.rightViewMode = UITextField.ViewMode.always
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: 0, y: 0, width: 200, height: (itemUnDoSoundField?.frame.size.height)!)
            btn.setTitleColor(.blue, for: UIControl.State.normal)
            btn.setTitle("▶️", for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(playItemUnDoSoundEffect), for: UIControl.Event.touchUpInside)
            itemUnDoSoundField?.rightView=btn
        }
        
        self.selectedBgColorHex=sharedKitchen.bgColor
        bgColorButton?.backgroundColor=UIColor.init(hexString: self.selectedBgColorHex!)
        bgColorButton?.layer.cornerRadius=15
        bgColorButton?.layer.borderWidth=0.5
        bgColorButton?.layer.borderColor=UIColor.darkGray.cgColor
        
        templateButtonOne?.isSelected = sharedKitchen.screenTemplate == 1 ? true : false
        templateButtonTwo?.isSelected = sharedKitchen.screenTemplate == 2 ? true : false

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
            newDocketNotiSwitch?.isUserInteractionEnabled=false
            newDocketSoundField?.isUserInteractionEnabled=false
            docketSizeControl?.isUserInteractionEnabled=false
            
            closeDocketNotiSwitch?.isUserInteractionEnabled=false
            closeDocketSoundField?.isUserInteractionEnabled=false

            let saveBtn=UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(saveChanges))
            self.navigationItem.rightBarButtonItems = [saveBtn]
                   
        }else{
            
            let privacyBtn=UIBarButtonItem(image: UIImage(named: "privacyIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(privacyAction))
            let saveBtn=UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(saveChanges))
            self.navigationItem.rightBarButtonItems = [saveBtn, privacyBtn]       
        }
        
        controlsBgView?.layer.borderWidth = 2
        controlsBgView?.layer.borderColor = UIColor.darkGray.cgColor
        controlsBgView?.layer.cornerRadius = 5
        
        userBgView?.layer.borderWidth = 2
        userBgView?.layer.borderColor = UIColor.darkGray.cgColor
        userBgView?.layer.cornerRadius = 5
        
        mainBgView?.backgroundColor = .clear
        mainBgView?.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        
        self.changeBgEffectOf(bgView: newDocketBgView!)
        self.changeBgEffectOf(bgView: docketDoneBgView!)
        self.changeBgEffectOf(bgView: itemDoneBgView!)
        self.changeBgEffectOf(bgView: itemUnDoneBgView!)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        versionLabel?.text = "OmniKDS Version \(appVersion!) (\(buildVersion!))"
        
        let tvBgView = UIView(frame: userTableView!.frame)
        tvBgView.backgroundColor = .clear
        userTableView?.backgroundView = tvBgView
    }
    
    func changeBgEffectOf(bgView:UIView){
        
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.darkGray.cgColor
        bgView.layer.cornerRadius = 5
    }
    
    @objc func playNewDocketSoundName(){
        
        let sharedKitchen = OmniKitchen.getSharedKitchen(container: sharedCoredataCoordinator.getPersistentContainer())
        let path = Bundle.main.path(forResource: "\(sharedKitchen.newDocketSoundName!)", ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
    }
    @objc func playCloseDocketSoundName(){
        
        let sharedKitchen = OmniKitchen.getSharedKitchen(container: sharedCoredataCoordinator.getPersistentContainer())
        let path = Bundle.main.path(forResource: "\(sharedKitchen.closeDocketSoundName!)", ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
    }
    
    @objc func playItemDoneSoundEffect(){
        
        let sharedKitchen = OmniKitchen.getSharedKitchen(container: sharedCoredataCoordinator.getPersistentContainer())
        let path = Bundle.main.path(forResource: "\(sharedKitchen.doneItemSoundEffect!)", ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
    }
    
    @objc func playItemUnDoSoundEffect(){
        
        let sharedKitchen = OmniKitchen.getSharedKitchen(container: sharedCoredataCoordinator.getPersistentContainer())
        let path = Bundle.main.path(forResource: "\(sharedKitchen.unDoItemSoundEffect!)", ofType: "m4r")!
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
            cell.backgroundColor = .clear
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
        let nav = UINavigationController(rootViewController: colorVc)
        nav.navigationBar.barStyle = .black
        nav.modalPresentationStyle = .popover
        colorVc.delegate=self
        let viewPresentationController = nav.popoverPresentationController
        if let presentationController = viewPresentationController {
            presentationController.delegate = self
            presentationController.sourceView = bgColorButton
            presentationController.permittedArrowDirections = UIPopoverArrowDirection.left
        }
        
        nav.preferredContentSize=CGSize(width: 320, height: 400)
        self.present(nav, animated: true, completion: nil)
        self.currentPopoverController=nav
    }
    
    @IBAction func soundModeSwitchAction(sender:UISwitch){
        
        
    }
    
    @IBAction func docketSizeBarAction(sender:UISegmentedControl){
        
        
    }
    
    @objc func saveChanges(){
        
        let sharedKitchen = OmniKitchen.getSharedKitchen(container: sharedCoredataCoordinator.getPersistentContainer())
        
        sharedKitchen.kitchenName = kitchenNameField?.text
        let n=turnToRedField?.text as NSString?
        sharedKitchen.turnToRedAfter = n?.intValue ?? 0
        
        let m=turnToYelloField?.text as NSString?
        sharedKitchen.turnToYellowAfter=m?.intValue ?? 0
        
        sharedKitchen.newDocketNotification=newDocketNotiSwitch!.isOn
        sharedKitchen.docketSize=Int32(docketSizeControl?.selectedSegmentIndex ?? 0)
        sharedKitchen.bgColor=self.selectedBgColorHex!
        sharedKitchen.newDocketSoundName=newDocketSoundField?.text
        
        sharedKitchen.closeDocketSoundName=closeDocketSoundField?.text
        sharedKitchen.closeDocketNotification=closeDocketNotiSwitch!.isOn
        
        sharedKitchen.doneItemSoundEffect = itemDoneSoundField?.text
        sharedKitchen.doneItemNotification = itemDoneNotiSwitch!.isOn
        sharedKitchen.unDoItemSoundEffect = itemUnDoSoundField?.text
        sharedKitchen.unDoItemNotification = itemUnDoNotiSwitch!.isOn
        sharedKitchen.screenTemplate = templateButtonOne!.isSelected ? 1 : 2
        
        sharedCoredataCoordinator.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(kDidChangeOrderContentNotification), object: nil)
        //dismiss now
        dismissView()
        
    }
    
    func didSelectColorHex(colorHex: String) {
     
        let sharedKitchen = OmniKitchen.getSharedKitchen(container: sharedCoredataCoordinator.getPersistentContainer())
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
        
        self.activeTextField = textField
        if textField == newDocketSoundField || textField == closeDocketSoundField || textField == itemDoneSoundField || textField == itemUnDoSoundField{
            
            self.showSoundTypeSelectionUI()
            return false
        }
        
        return true
    }
    
    func showSoundTypeSelectionUI(){
        
        let pickerVc = KDPickerController(style: UITableView.Style.grouped)
        pickerVc.delegate=self
        pickerVc.itemList=NSArray(array: ["sound1","sound2", "sound3", "sound4", "sound5","sound6","sound7", "sound8", "sound9", "sound10", "sound11","sound12","sound13", "sound14", "sound15", "sound16", "sound17","sound18","sound19", "sound20", "sound21", "sound22", "sound23","sound24","sound25", "sound26", "sound27", "sound28", "sound29", "sound30"])
        pickerVc.selectedItem=self.activeTextField?.text
        let navVc = UINavigationController(rootViewController: pickerVc)
        navVc.modalPresentationStyle = .popover
        navVc.navigationBar.barStyle = .black
        let viewPresentationController = navVc.popoverPresentationController
        if let presentationController = viewPresentationController{
            
            presentationController.delegate=self
            presentationController.sourceView=self.activeTextField
            presentationController.permittedArrowDirections=UIPopoverArrowDirection.down
        }
        
        navVc.preferredContentSize = CGSize(width: 300, height: 450)
        self.present(navVc, animated: true, completion: nil)
        self.currentPopoverController=pickerVc
    }
    
    func didSelectItem(item: String) {

        self.activeTextField?.text = item
        /*
        if self.activeTextField == newDocketSoundField{
        
            newDocketSoundField?.text=item
        }else if self.activeTextField == closeDocketSoundField{
            
            closeDocketSoundField?.text = item
        }*/
    }
    
    @IBAction func templateButtonActions(sender:UIButton){
        
        sender.isSelected = !sender.isSelected
        
        if sender == templateButtonOne{
            
            templateButtonTwo?.isSelected = sender.isSelected ? false : true
        }
        else if sender == templateButtonTwo{
            
            templateButtonOne?.isSelected = sender.isSelected ? false : true
        }
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
        alert.textFields![0].font = UIFont.boldSystemFont(ofSize: 17)
        
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
            
            alert.addAction(UIAlertAction(title: "Clear All Dockets", style: UIAlertAction.Style.destructive, handler: { _ in
                
               self.performSelector(onMainThread: #selector(self.clearAllDockets), with: nil, waitUntilDone: false)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Clear All Open Dockets", style: UIAlertAction.Style.destructive, handler: { _ in
                
               self.performSelector(onMainThread: #selector(self.clearAllOpenDockets), with: nil, waitUntilDone: false)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Clear All Closed Dockets", style: UIAlertAction.Style.destructive, handler: { _ in
                
               self.performSelector(onMainThread: #selector(self.clearAllClosedDockets), with: nil, waitUntilDone: false)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Reload Sample Dockets", style: UIAlertAction.Style.default, handler: { _ in
                
                self.performSelector(onMainThread: #selector(self.loadSampleOrders), with: nil, waitUntilDone: false)
                
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
        
        Order.removeAll()
        OrderItem.removeAll()
        ItemOption.removeAll()
        
        let alert = UIAlertController(title: "All dockets have been cleared!", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true) {}
        NotificationCenter.default.post(name: NSNotification.Name(kDidChangeOrderContentNotification), object: nil)
    }
    
    @objc func clearAllClosedDockets(){
        
        Order.removeAll(open: false)
        
        let alert = UIAlertController(title: "All closed dockets have been cleared!", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true) {}
        NotificationCenter.default.post(name: NSNotification.Name(kDidChangeOrderContentNotification), object: nil)
    }
    
    @objc func clearAllOpenDockets(){
        
        Order.removeAll(open: true)
        
        let alert = UIAlertController(title: "All open dockets have been cleared!", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true) {}
        NotificationCenter.default.post(name: NSNotification.Name(kDidChangeOrderContentNotification), object: nil)
    }
    
    // MARK: Loading Sample Orders
    @objc func loadSampleOrders(){
        
        sharedCoredataCoordinator.loadSampleOrders()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            userTableView?.reloadData()
    }
        
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            if type == NSFetchedResultsChangeType.insert{
            
                userTableView?.insertRows(at: [newIndexPath!], with: UITableView.RowAnimation.fade)
            }else if type == NSFetchedResultsChangeType.delete{
            
                userTableView?.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            }else if type == NSFetchedResultsChangeType.update{
            
                userTableView?.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            }
        }
}
