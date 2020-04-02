//
//  KDAnalysisViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 19/03/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class KDAnalysisViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView?
    @IBOutlet weak var fromDateField: UITextField?
    @IBOutlet weak var toDateField: UITextField?
    @IBOutlet weak var submitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="Analysis"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelBtnAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneBtnAction))
        
        backgroundView?.frame = self.view.bounds
    }
    
    @objc func cancelBtnAction(){
           
        self.dismiss(animated: true, completion: nil)
    }

    @objc func doneBtnAction(){
           
 
        self.dismiss(animated: true, completion: nil)   
    }
}
