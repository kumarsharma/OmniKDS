//
//  ViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 03/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pinView : UIView?
    @IBOutlet weak var pinField : UITextField?
    @IBOutlet weak var backgroundView: UIImageView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView?.frame = self.view.bounds
    }
    
    @IBAction func loginButtonAction(_sender:UIButton) {
        
        /*let alert = UIAlertController(title: "Oh so nice!", message: "But sorry, browsy is not ready yet. Please check again later!", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true) { 
            
        }*/
        
        let kdView : OPKitchenDisplayViewController? = OPKitchenDisplayViewController()
        let nav : UINavigationController = UINavigationController(rootViewController: kdView!)
        nav.modalPresentationStyle=UIModalPresentationStyle.fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    @IBAction func numsButtonPressed(sender: UIButton){
        
        var nums: String?
        nums = pinField?.text
        let num : Int = sender.tag
        
        if nums!.count>0{
            
            nums! += "\(num)" 
        }else{
            
            nums = "\(num)"
        }
        
        pinField?.text = nums!
    }
    
    @IBAction func backButtonPressed(sender:UIButton){
        
        var nums: String?
        nums = pinField?.text
        if nums!.count>0{
             
            nums!.removeLast()
            
            if nums!.count>0{
                pinField?.text = nums!
            }
            else{
                pinField?.text=""
            }
        }
    }
    
    @IBAction func clearButtonPressed(sender:UIButton){
        
        pinField?.text=""
    }
}

