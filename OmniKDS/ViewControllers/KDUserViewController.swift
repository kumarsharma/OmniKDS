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
    
    var currentUser:KitchenUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentUser != nil{
            
            fNameField?.text=currentUser?.firstName
            lNameField?.text=currentUser?.lastName
            phoneField?.text=currentUser?.phone
            pinField?.text=currentUser?.userPIN
        }
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
    }
    
    @IBAction func cancelBtnAction(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showError(error:String) {
        
        let alert = UIAlertController(title: "Missing Field", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true) { 
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
