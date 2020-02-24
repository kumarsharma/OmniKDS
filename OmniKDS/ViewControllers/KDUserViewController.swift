//
//  KDUserViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 31/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class KDUserViewController: UIViewController {

    @IBOutlet weak var fNameField:UITextField?
    @IBOutlet weak var lNameField:UITextField?
    @IBOutlet weak var phoneField:UITextField?
    @IBOutlet weak var pinField:UITextField?
    
    @IBOutlet weak var cancelBtn : UIButton?
    @IBOutlet weak var saveBtn : UIButton?
    @IBOutlet weak var deleteBtn : UIButton?
    
    var currentUser:KitchenUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fNameField?.becomeFirstResponder()

        self.view!.layer.borderWidth = 2
        self.view!.layer.borderColor = UIColor.darkGray.cgColor
        self.view!.layer.cornerRadius = 5
        self.view.backgroundColor = .tertiaryLabel
        
        if currentUser != nil{
            
            fNameField?.text=currentUser?.firstName
            lNameField?.text=currentUser?.lastName
            phoneField?.text=currentUser?.phone
            pinField?.text=currentUser?.userPIN
            
            deleteBtn?.isEnabled = true
        }else{
            
            deleteBtn?.isEnabled = false
        }
        
        modifyButton(btn: cancelBtn!)
        modifyButton(btn: saveBtn!)
        modifyButton(btn: deleteBtn!)
    }
    
    @IBAction func saveBtnAction(){
        
        if (fNameField?.text!.count)! <= 0{
            
            self.showError(error: "Please enter valid first name!")
            return
        } 
        
        if (pinField?.text!.count)! <= 0{
            
            self.showError(error: "Please enter PIN!")
            return
        } 
        
        var checkUser: KitchenUser?
        
        
        do{
        
            checkUser = try KitchenUser.fetchObjectWithPredicate(predicate: NSPredicate(format: "userPIN=%@", pinField!.text!)) as? KitchenUser
        }catch{
            
        }
        
        
        if checkUser == nil || (checkUser != nil && currentUser?.userPIN == pinField?.text){
            
            if currentUser == nil{
                
                let newUser = KitchenUser.addNewUser(firstName: fNameField!.text!, lastName: lNameField!.text!, isAdmin: false, email: "", phone: phoneField!.text!, userPIN: pinField!.text!)
                currentUser=newUser
            }
            else{
                
               currentUser?.firstName = fNameField?.text
               currentUser?.lastName = lNameField?.text
               currentUser?.phone = phoneField?.text
               currentUser?.userPIN = pinField?.text
            }
            
            sharedCoredataCoordinator.saveContext()
            self.dismiss(animated: true, completion: nil)
        }else{
            
            self.showError(error: "User PIN already assigned!")
            return
        }
    }
    
    @IBAction func cancelBtnAction(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnAction(){
        
        sharedCoredataCoordinator.persistentContainer.viewContext.delete(currentUser!)
        sharedCoredataCoordinator.saveContext()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showError(error:String) {
        
        let alert = UIAlertController(title: "Invalid Entry", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true) { 
            
        }
    }
    
    func modifyButton(btn:UIButton){
        
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth=0.5
        btn.layer.borderColor = UIColor.darkText.cgColor
    }

}
