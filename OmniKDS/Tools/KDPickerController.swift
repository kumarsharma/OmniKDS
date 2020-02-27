//
//  KDPickerController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 31/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import AVFoundation

protocol KDPickerDelegate {
    
    func didSelectItem(item:String)
}

class KDPickerController: UITableViewController {

    var itemList:NSArray?
    var selectedItem:String?
    var delegate:KDPickerDelegate?
    var soundEffect : AVAudioPlayer?
    var currentCell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="Select an Item"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelBtnAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneBtnAction))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func cancelBtnAction(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneBtnAction(){
        
        if self.delegate != nil{
            
            self.delegate?.didSelectItem(item: self.selectedItem!)
        }
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.itemList!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let item = self.itemList?.object(at: indexPath.row) as? String
        cell.textLabel?.text = item
        
        if selectedItem != nil{
            
            if selectedItem == item{
                cell.accessoryType=UITableViewCell.AccessoryType.checkmark
            }
            else{
                cell.accessoryType=UITableViewCell.AccessoryType.none
            }
            currentCell=cell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.itemList?.object(at: indexPath.row) as? String
        self.selectedItem=item
        let path = Bundle.main.path(forResource: "\(item!)", ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType=UITableViewCell.AccessoryType.checkmark
        currentCell?.accessoryType = UITableViewCell.AccessoryType.none
        currentCell=cell
    }
}
