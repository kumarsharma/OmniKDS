//
//  OPKitchenDisplayViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 13/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class OPKitchenDisplayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = OmniKitchen.getSharedKItchen(container: sharedCoredataCoordinator.persistentContainer).kitchenName
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelBtnAction))
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.systemBlue
    }
    
    @objc func cancelBtnAction() {
        
        self.dismiss(animated: true, completion: nil)
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
