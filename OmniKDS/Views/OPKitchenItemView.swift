//
//  OPKitchenItemView.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 16/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class OPKitchenItemView: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var kitchenItems : NSMutableArray?
    var tableView : UITableView?
    var headerLabel : UILabel?  
    
    override init(frame: CGRect) {
        
        super.init(frame:.zero)
        self.backgroundColor=UIColor.green
    }
    
    func setupSubViews(){
        
        if headerLabel==nil{
            kitchenItems=["Item 1", "Item 2", "Item 3"]
            
            headerLabel=UILabel(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 100))
            headerLabel!.text="Table 1         10min"
            headerLabel!.textColor=UIColor.white
            headerLabel!.backgroundColor=UIColor.red
            
            tableView=UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
            tableView?.frame=CGRect.init(x: 0, y: headerLabel!.frame.size.height, width: self.frame.size.width, height: self.frame.size.height-headerLabel!.frame.size.height)
            tableView!.delegate=self; tableView!.dataSource=self
            
            self.addSubview(headerLabel!)
            self.addSubview(tableView!)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.kitchenItems!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil{
            
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        cell.textLabel?.text=self.kitchenItems?.object(at: indexPath.row) as? String
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}
