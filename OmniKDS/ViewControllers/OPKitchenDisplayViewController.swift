//
//  OPKitchenDisplayViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 13/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

class OPKitchenDisplayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var docketCollectionView : UICollectionView?
    @IBOutlet weak var orderCollectionView : UICollectionView?
    @IBOutlet weak var scrollBgView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialsForNavigationBar()
        doInitialsForCollectionView()
    }
    
    func doInitialsForNavigationBar() {
        
        self.title = OmniKitchen.getSharedKItchen(container: sharedCoredataCoordinator.persistentContainer).kitchenName
        
        self.view.backgroundColor = UIColor.systemBlue
        let barButton1 : UIBarButtonItem = UIBarButtonItem(title: "Show Summary", style: UIBarButtonItem.Style.done, target: self, action: #selector(showSummaryAction))
        
        let settingsBarBtn : UIBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItem.Style.done, target: self, action: #selector(settingsAction))
        self.navigationItem.leftBarButtonItems = [barButton1, settingsBarBtn]
        
        
        let segmentedBar : UISegmentedControl = UISegmentedControl(items: ["Open", "Closed"])
        segmentedBar.addTarget(self, action: #selector(segmentedControlAction), for: UIControl.Event.valueChanged)
        segmentedBar.selectedSegmentIndex=0
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: segmentedBar)
    }
    
    func doInitialsForCollectionView() {
        
        docketCollectionView?.frame=CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height-106)
        
        let docketFrame : CGRect = (docketCollectionView?.frame)!
        
        scrollBgView?.frame=CGRect(x: 0, y: (docketFrame.size.height+docketFrame.origin.y)+5, width: self.view.bounds.size.width, height: 106)
        docketCollectionView?.register(OPKitchenItemView.self, forCellWithReuseIdentifier: "cell")
        orderCollectionView?.register(OPTableItemView.self, forCellWithReuseIdentifier: "cell2")
        docketCollectionView?.delegate=self
        docketCollectionView?.dataSource=self
        docketCollectionView?.reloadData()
    }
    
    @objc func showSummaryAction(){
        
        
    }
    
    @objc func settingsAction(){
        
        let settingsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SettingsViewController")
        let navVc = UINavigationController(rootViewController: settingsVc)
        navVc.modalPresentationStyle=UIModalPresentationStyle.fullScreen
        self.present(navVc, animated: true, completion: nil)
    }
    
    @objc func segmentedControlAction(sender:UISegmentedControl){
        
    }
    
    @objc func cancelBtnAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 5
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var colCell : UICollectionViewCell?
        if collectionView==docketCollectionView{
            let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OPKitchenItemView
            cell?.setupSubViews()
            colCell = cell
        }
        else{
            
            let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? OPTableItemView
            cell?.setupSubViews()
            colCell = cell
        }
//        cell!.backgroundColor = .black
      
        return colCell!
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView==docketCollectionView) ? CGSize(width: 300, height: 600) : CGSize(width: 80, height: 80)
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
}
