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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.backgroundColor=UIColor.green;
        button.titleLabel?.text="Browser"
        button.addTarget(self, action: #selector(browsyButtonAction(_sender:)), for: .touchUpInside)
        
        button.frame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 100, height: 30)
        self.view.addSubview(button)
        
        
    }
    
    @objc func browsyButtonAction(_sender:UIButton) {
        
        let alert = UIAlertController(title: "Oh so nice!", message: "But sorry, browsy is not ready yet. Please check again later!", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true) { 
            
        }
    }


}

