//
//  KDTools.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 06/02/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import AVFoundation

class KDTools: NSObject {

    class func docketWidth()->Int{
        
        var width = 215 //small
        if sharedKitchen!.docketSize == 1{
            
            width = 272 //medium
        }
        else if sharedKitchen!.docketSize == 2{
            
            width = 360 //large
        } 
        
        return width
    }
    
    class func docketTextFont()->UIFont{
        
        var font = UIFont.boldSystemFont(ofSize: 12)
        if sharedKitchen!.docketSize == 1{
           
            font = UIFont.boldSystemFont(ofSize: 15)
        }else if sharedKitchen!.docketSize == 2{
           
           font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        return font
    }
    
    class func docketHeaderFont()->UIFont{
        
        var font = UIFont.boldSystemFont(ofSize: 13)
        if sharedKitchen!.docketSize == 1{
            
            font = UIFont.boldSystemFont(ofSize: 16)
        }else if sharedKitchen!.docketSize == 2{
            
            font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        return font
    }
}
