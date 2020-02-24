//
//  OPKitchenDisplayViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 13/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class OPKitchenDisplayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var docketCollectionView : UICollectionView?
    @IBOutlet weak var orderCollectionView : UICollectionView?
    @IBOutlet weak var scrollBgView:UIView?
    @IBOutlet weak var nextButton : UIButton?
    @IBOutlet weak var prevButton : UIButton?
    @IBOutlet weak var totalOrdersLabel : UILabel?
    @IBOutlet weak var totalItemsLabel : UILabel?
    var currentPopoverController : UIViewController?
    var docketSearchBar : UISearchBar?
    var searchText : String?
    var isSearchActive : Bool?
    var lowerScrollIndicator : UIView? 
    var soundEffect : AVAudioPlayer?

    lazy var orderFetchedController :  NSFetchedResultsController<NSFetchRequestResult> = {
        
        let frc = NSFetchedResultsController(fetchRequest: Order.viewFetchRequest(), managedObjectContext: sharedCoredataCoordinator.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate=self
        do{
            try frc.performFetch()
        }catch _{
            
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSearchActive = false
        doInitialsForNavigationBar()
        doInitialsForCollectionView()
        updateCountLabels()
        
//        print(doSumOfDigits(num: 439230))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = sharedKitchen!.kitchenName! + " (" + loggedInUser!.firstName! + ")"
        docketCollectionView!.backgroundColor = UIColor(hexString: sharedKitchen!.bgColor!)
        self.view!.backgroundColor = UIColor(hexString: sharedKitchen!.bgColor!)
    }
    
    func doInitialsForNavigationBar() {
        
        self.title = OmniKitchen.getSharedKItchen(container: sharedCoredataCoordinator.persistentContainer).kitchenName
        
        self.view.backgroundColor = UIColor.systemBlue
        let barButton1 : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "summaryIcn"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(showSummaryAction))
        
        let settingsBarBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsIcn"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(settingsAction))
        
        let logoutBarBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "logoutIcn"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutAction))//UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutAction))
        
        self.navigationItem.leftBarButtonItems = [barButton1, settingsBarBtn, logoutBarBtn]
        
        docketSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        docketSearchBar!.placeholder = "Enter order# to search"
//        searchTextField!.backgroundColor = .white
        docketSearchBar!.delegate = self
        docketSearchBar?.showsSearchResultsButton = true
        docketSearchBar?.showsCancelButton=true
        
        let segmentedBar : UISegmentedControl = UISegmentedControl(items: ["Open", "Closed"])
        segmentedBar.addTarget(self, action: #selector(segmentedControlAction), for: UIControl.Event.valueChanged)
        segmentedBar.backgroundColor = .brown
        
        let font = UIFont.boldSystemFont(ofSize: 16)
        segmentedBar.setTitleTextAttributes([NSAttributedString.Key.font : font], for: UIControl.State.normal)
        
        segmentedBar.selectedSegmentIndex=0
        let segBarButtonItem = UIBarButtonItem.init(customView: segmentedBar)
        let txtBarButtonItem = UIBarButtonItem.init(customView: docketSearchBar!)
        
        self.navigationItem.setRightBarButtonItems([segBarButtonItem, txtBarButtonItem], animated: true)
    }
    
    func doInitialsForCollectionView() {
        
        docketCollectionView?.frame=CGRect(x: 2, y: 0, width: self.view.bounds.size.width-4, height: self.view.bounds.size.height-126)
        
        let docketFrame : CGRect = (docketCollectionView?.frame)!
        
        scrollBgView?.frame=CGRect(x: 0, y: (docketFrame.size.height+docketFrame.origin.y)+5, width: self.view.bounds.size.width, height: 106)
        docketCollectionView?.register(OPKitchenItemView.self, forCellWithReuseIdentifier: "cell")
        
        orderCollectionView!.frame = CGRect(x: 2, y: 25, width: (scrollBgView?.bounds.size.width)!, height: (orderCollectionView?.frame.size.height)!)
        
        nextButton?.frame = CGRect(x: (scrollBgView?.frame.size.width)!-(nextButton?.frame.size.width)!, y: 0, width: (nextButton?.frame.size.width)!, height: 25)
        orderCollectionView?.register(OPTableItemView.self, forCellWithReuseIdentifier: "cell2")
        docketCollectionView?.delegate=self
        docketCollectionView?.dataSource=self
        docketCollectionView?.reloadData()
        
        var dockCount : Int?
        if sharedKitchen?.ticketSize == 0 {
            dockCount = 5
        }else if sharedKitchen?.ticketSize == 1{
            dockCount = 4
        }else{
            dockCount = 3
        }
        
        let indicatorWidth = dockCount! * 80
        lowerScrollIndicator = UIView(frame: CGRect(x: 15, y: 5, width: indicatorWidth, height: 5))
        lowerScrollIndicator?.backgroundColor = .blue
        lowerScrollIndicator?.layer.cornerRadius = 5
        lowerScrollIndicator?.layer.borderWidth=0.5
        lowerScrollIndicator?.layer.borderColor = UIColor.green.cgColor
        orderCollectionView?.addSubview(lowerScrollIndicator!)
    }
    
    @objc func showSummaryAction(sender:UIBarButtonItem){
        
        let summaryVc = KDSummaryViewController(style: UITableView.Style.grouped) 
        
        let navController = UINavigationController(rootViewController: summaryVc)
        navController.modalPresentationStyle = .popover
        
        let viewPresentationController = navController.popoverPresentationController
         if let presentationController = viewPresentationController{
            
            presentationController.delegate=self
            presentationController.barButtonItem = sender
            presentationController.permittedArrowDirections=UIPopoverArrowDirection.any
         }
        
         navController.preferredContentSize = CGSize(width: 400, height: 900)
         self.present(navController, animated: true, completion: nil)
         self.currentPopoverController=navController
    }
    
    @objc func settingsAction(){
        
        let settingsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SettingsViewController")
        let navVc = UINavigationController(rootViewController: settingsVc)
        navVc.modalPresentationStyle=UIModalPresentationStyle.fullScreen
        self.present(navVc, animated: true, completion: nil)
    }
    
    @objc func logoutAction(){
        
        loggedInUser = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func segmentedControlAction(sender:UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            
            orderFetchedController.fetchRequest.predicate = NSPredicate(format: "isOpen=true")
        }else{
            orderFetchedController.fetchRequest.predicate = NSPredicate(format: "isOpen=false")
        }
        
        do{
            try orderFetchedController.performFetch()
        }catch{
            
        }
        docketCollectionView?.reloadData()
        orderCollectionView?.reloadData()
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
        return self.orderFetchedController.fetchedObjects!.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var colCell : UICollectionViewCell?
        let anOrder = self.orderFetchedController.object(at: indexPath) as? Order
        if collectionView==docketCollectionView{
            let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OPKitchenItemView
            cell?.order = anOrder
            cell?.setupSubViews()
            cell?.reloadCell()
            colCell = cell
        }
        else{
            
            let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? OPTableItemView
            cell?.order = anOrder
            cell?.setupSubViews()
            colCell = cell
        }
//        cell!.backgroundColor = .black
      
        return colCell!
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView==docketCollectionView) ? CGSize(width: KDTools.docketWidth(), height: 600) : CGSize(width: 80, height: 80)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView==orderCollectionView{
            
            orderCollectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            docketCollectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            self.performSelector(onMainThread: #selector(indicateVisibleOrders), with: nil, waitUntilDone: false)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        docketCollectionView?.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == NSFetchedResultsChangeType.insert{
        
            if sharedKitchen!.soundMode{
                
                self.performSelector(onMainThread: #selector(playSound), with: sharedKitchen!.soundType!, waitUntilDone: true)
            }
            docketCollectionView?.insertItems(at: [newIndexPath!])
            orderCollectionView?.insertItems(at: [newIndexPath!])
        }else if type == NSFetchedResultsChangeType.delete{
        
            docketCollectionView?.deleteItems(at: [indexPath!])
            orderCollectionView?.deleteItems(at: [indexPath!])
        }else if type == NSFetchedResultsChangeType.update{
        
            docketCollectionView?.reloadItems(at: [indexPath!])
            orderCollectionView?.reloadItems(at: [indexPath!])
        }
        
    }
    
    @objc func playSound(soundName:String){
        
        let path = Bundle.main.path(forResource: soundName, ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
    }
    
    //MARK: scrolling

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == docketCollectionView{
            
            self.performSelector(onMainThread: #selector(indicateVisibleOrders), with: nil, waitUntilDone: false)
        } 
    }
    
    @objc func indicateVisibleOrders(){
        
        let count = docketCollectionView?.visibleCells.count
        if count! > 0{
            
            let visibleCellAny = docketCollectionView?.visibleCells[0]
            let ip = docketCollectionView?.indexPath(for: visibleCellAny!)
            
            orderCollectionView?.scrollToItem(at: ip!, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            
            let cell = orderCollectionView?.cellForItem(at: ip!)
            lowerScrollIndicator?.frame = .init(x: (cell?.frame.origin.x)!, y: (lowerScrollIndicator?.frame.origin.y)!, width: (lowerScrollIndicator?.frame.size.width)!, height: (lowerScrollIndicator?.frame.size.height)!)
        }
        updateNextPrevButtons()
    }
    
    @IBAction func nextBtnAction(sender:UIButton){
        
        changePage(isNext: true)
    }
    
    @IBAction func prevBtnAction(sender:UIButton){
        
        changePage(isNext: false)
    }
    
    func changePage(isNext: Bool){
        
        let offset = docketCollectionView?.contentOffset
        let contentSize = docketCollectionView?.contentSize
        let noOfPages = Float(contentSize!.width/1108)
        
        if noOfPages > 1{
            
            let currentPage = Float(offset!.x) == 0 ? 0 : (Float(offset!.x) / Float(contentSize!.width)) * noOfPages
            
            let condition = isNext ? (currentPage < noOfPages) : (currentPage > 0)
            if condition{
                
                if isNext{
                    
                    let toPointX = CGFloat((currentPage*1108)+1108)
                    
                    if Float(toPointX) < Float(contentSize!.width){
                     
                        docketCollectionView?.setContentOffset(CGPoint(x: toPointX, y: offset!.y), animated: true)
                    }
                }else{
                    
                    let toPointX = CGFloat((currentPage*1108)-1108)
                    
                    if Float(toPointX) >= 0{
                     
                        docketCollectionView?.setContentOffset(CGPoint(x: toPointX, y: offset!.y), animated: true)
                    }
                }
                indicateVisibleOrders()
                updateNextPrevButtons()
            }
        }
    }
    
    func updateNextPrevButtons(){
        
        let offset = docketCollectionView?.contentOffset
        let contentSize = docketCollectionView?.contentSize
        let noOfPages = Float(contentSize!.width/1108)
        let currentPage = Float(offset!.x) == 0 ? 0 : (Float(offset!.x) / Float(contentSize!.width)) * noOfPages
        
        if noOfPages > 1{
            
            nextButton?.isEnabled = currentPage < noOfPages ? true : false
            prevButton?.isEnabled = currentPage > 0 ? true : false
        }else{
            
            nextButton?.isEnabled = false
            prevButton?.isEnabled = false
        }
        docketCollectionView?.flashScrollIndicators()
    }
    
    func updateCountLabels(){
        
        let totalOrders = orderFetchedController.fetchedObjects?.count
        let orderIds = NSMutableArray()
        var totalItems = 0
        var totalItemsDone = 0
        var totalItemsPending = 0
        for order in orderFetchedController.fetchedObjects! {
            
            let anOrder = order as? Order
            orderIds.add(anOrder?.orderId! as Any)
        }
        
        var predicate = NSPredicate(format: "orderId IN %@ AND isFinished=true", orderIds)
        do{
            predicate = NSPredicate(format: "orderId IN %@ AND isFinished=true", orderIds)
            totalItemsDone = try OrderItem.fetchCountWithPredicate(predicate: predicate)
            
            predicate = NSPredicate(format: "orderId IN %@ AND isFinished=false", orderIds)
            totalItemsPending = try OrderItem.fetchCountWithPredicate(predicate: predicate)
            
            totalItems = totalItemsDone + totalItemsPending
        }catch{
            
        }
        
        totalOrdersLabel?.text = String(format: "Total orders: %d", totalOrders ?? 0)
        totalItemsLabel?.text = String(format: "Totam items: %d (Done: %d, Pending: %d)", totalItems, totalItemsDone, totalItemsPending)
    }
    
    func doSumOfDigits(num:Int)-> Int{
        
        let strNum = String(format: "%d", num)
        if strNum.count > 1{
            
            var sum : Int = 0
            for char in strNum{
                
                let n = Int(String(char))!
                sum += n
            }
            
            return doSumOfDigits(num: sum)
        }else{
            
            return num
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        resetCollectionViews()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        resetCollectionViews()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count>0{
            
            let predicate = NSPredicate(format: "isOpen=true AND orderNo CONTAINS[c] %@", searchText)
            self.orderFetchedController.fetchRequest.predicate = predicate
            
            do{
                try self.orderFetchedController.performFetch()
            }catch _{
                
            }
            
            docketCollectionView?.reloadData()
            orderCollectionView?.reloadData()
        }else{
            
           resetCollectionViews()
        }
    }
    
    func resetCollectionViews(){
        
        let predicate = NSPredicate(format: "isOpen=true")
        self.orderFetchedController.fetchRequest.predicate = predicate
        
        do{
            try self.orderFetchedController.performFetch()
        }catch _{
            
        }
        
        docketCollectionView?.reloadData()
        orderCollectionView?.reloadData()
        
        docketSearchBar?.resignFirstResponder()
    }
}
