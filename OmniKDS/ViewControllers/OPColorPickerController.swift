//
//  OPColorPickerController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 29/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol OPColorPickerDelegate {
    
    func didSelectColorHex(colorHex:String)
}

class OPColorPickerController: UICollectionViewController {

    var delegate : OPColorPickerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="Select an Item"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelBtnAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "doneIcn"), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneBtnAction))
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @objc func cancelBtnAction(){
           
        self.dismiss(animated: true, completion: nil)
    }
       
    @objc func doneBtnAction(){
          
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 160
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var colors : NSArray?
        let palettePath = Bundle.main.path(forResource: "colorPalette", ofType: "plist")
        let plistArray = NSArray(contentsOfFile: palettePath!)
        if let colorPalettePlistFile = plistArray{
            
            colors = colorPalettePlistFile as! [String] as NSArray
        }
        
        let hexString = colors![indexPath.row]
        
        let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.init(hexString: hexString as! String)    
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 10, height: 10)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var colors : NSArray?
        let palettePath = Bundle.main.path(forResource: "colorPalette", ofType: "plist")
        let plistArray = NSArray(contentsOfFile: palettePath!)
        if let colorPalettePlistFile = plistArray{
            
            colors = colorPalettePlistFile as! [String] as NSArray
        }
        
        let hexString = colors![indexPath.row] as! String
        if delegate != nil{
            
            delegate?.didSelectColorHex(colorHex: hexString)
        }
    }

}
