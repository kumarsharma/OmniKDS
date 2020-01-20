//
//  OPTableItemView.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 20/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class OPTableItemView: UICollectionViewCell {
    
    
    var headerLabel, footerLabel : UILabel? 
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    } 
    
    override init(frame: CGRect) {
        
        super.init(frame:.zero)
        self.backgroundColor=UIColor.green
    }
    
    func setupSubViews(){
        
        if headerLabel==nil{
            
            headerLabel=UILabel(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height/2))
            headerLabel!.text="Table 1"
            headerLabel!.textColor=UIColor.white
            headerLabel!.backgroundColor=UIColor.red
            
            footerLabel=UILabel()
            footerLabel?.frame=CGRect.init(x: 0, y: headerLabel!.frame.size.height, width: self.frame.size.width, height: self.frame.size.height/2)
            footerLabel!.text="6:25 PM"
            footerLabel!.textColor=UIColor.darkGray
            footerLabel!.backgroundColor=UIColor.darkText

            self.addSubview(headerLabel!)
            self.addSubview(footerLabel!)
        }
    }
}
