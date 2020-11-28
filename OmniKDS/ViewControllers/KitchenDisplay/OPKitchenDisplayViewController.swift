//
//  OPKitchenDisplayViewController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 13/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import AVFoundation

class OPKitchenDisplayViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {
    

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
    var segmentedControl : UISegmentedControl?
    var loadingIndicatorView : LoadingIndicatorView?
    
    var docketPresenter : KDPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mvp - presenter
        self.docketPresenter = KDPresenter(with: docketCollectionView!, orderCollectionView: orderCollectionView!)
        self.docketPresenter.delegate = self
        self.docketPresenter.docketCollectionViewObj = self.docketCollectionView
        self.docketPresenter.orderCollectionViewObj = self.orderCollectionView
        
        self.title = sharedKitchen!.kitchenName!
        isSearchActive = false
        doInitialsForNavigationBar()
        doInitialsForCollectionView()
        updateCountLabels()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeOrderContent), name: Notification.Name(kDidChangeOrderContentNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(someItemStateDidChange), name: Notification.Name(kSomeItemStateDidChangeNotification), object: nil)

        //prompt for sample order
        if !sharedKitchen!.wasSampleOrderLoaded{
            
            sharedKitchen?.wasSampleOrderLoaded = true
            sharedCoredataCoordinator.saveContext()
            
            let alertC = UIAlertController(title: "Explore App with sample dockets", message: "This is for demo purpose. You can clear sample dockets any time from Settings->Privacy. Load sample dockets now?", preferredStyle: UIAlertController.Style.alert)
            
            alertC.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                
            }))
            
            alertC.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
                self.performSelector(onMainThread: #selector(self.loadSampleOrders), with: nil, waitUntilDone:  false)
            }))
            
            self.present(alertC, animated: true);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        docketCollectionView!.backgroundColor = UIColor(hexString: sharedKitchen!.bgColor!)
        self.view!.backgroundColor = UIColor(hexString: sharedKitchen!.bgColor!)
    }
    
    @objc func loadSampleOrders(){
        
        sharedKitchen?.wasSampleOrderLoaded = true
        loadingIndicatorView = LoadingIndicatorView.showLoadingIndicator(in: self.view, withMessage: "Loading sample dockets, please wait...", shouldIgnoreEvents: false)
        self.perform(#selector(loadSampleDocketsWithDelay), with: nil, afterDelay: 2)
    }
    
    @objc func loadSampleDocketsWithDelay(){
                
        self.docketPresenter.loadData(loadWithSampleOrder: true)
    }
    
    @objc func didChangeOrderContent(){
        
        segmentedControl!.selectedSegmentIndex = 0
        docketCollectionView?.reloadData()
        orderCollectionView?.reloadData()
    }
    
    @objc func someItemStateDidChange(){
        
        updateCountLabels()
    }
    
    func doInitialsForNavigationBar() {
        
        self.title = OmniKitchen.getSharedKitchen(container: sharedCoredataCoordinator.persistentContainer).kitchenName
        
        self.view.backgroundColor = UIColor.systemBlue
        let barButton1 : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "summaryIcn"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(showSummaryAction))
        
        let settingsBarBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsIcn"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(settingsAction))
        
//        let logoutBarBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "logoutIcn"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutAction))//UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutAction))
        
        let analyticsBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "analyticsIcn"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(analyticsAction))
        
        let courseBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "courseIcn"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(courseAction))
        
        self.navigationItem.leftBarButtonItems = [barButton1, settingsBarBtn, analyticsBtn, courseBtn]
        
        docketSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        docketSearchBar!.placeholder = "Enter order# to search"
        docketSearchBar!.delegate = self
        docketSearchBar?.showsSearchResultsButton = true
        docketSearchBar?.showsCancelButton=true
        
        segmentedControl = UISegmentedControl(items: ["Open", "Closed"])
        segmentedControl!.addTarget(self, action: #selector(segmentedControlAction), for: UIControl.Event.valueChanged)
        segmentedControl!.backgroundColor = .brown
        
        let font = UIFont.boldSystemFont(ofSize: 16)
        segmentedControl!.setTitleTextAttributes([NSAttributedString.Key.font : font], for: UIControl.State.normal)
        
        segmentedControl!.selectedSegmentIndex=0
        let segBarButtonItem = UIBarButtonItem.init(customView: segmentedControl!)
        let txtBarButtonItem = UIBarButtonItem.init(customView: docketSearchBar!)
        
        self.navigationItem.setRightBarButtonItems([segBarButtonItem, txtBarButtonItem], animated: true)
    }
    
    func doInitialsForCollectionView() {
        
        docketCollectionView?.frame=CGRect(x: 2, y: 0, width: self.view.bounds.size.width-4, height: self.view.bounds.size.height-126)
        self.docketPresenter.registerCells(for: docketCollectionView!)
        
        let docketFrame : CGRect = (docketCollectionView?.frame)!
        
        scrollBgView?.frame=CGRect(x: 0, y: (docketFrame.size.height+docketFrame.origin.y)+5, width: self.view.bounds.size.width, height: 106)
                
        orderCollectionView!.frame = CGRect(x: 2, y: 25, width: (scrollBgView?.bounds.size.width)!, height: (orderCollectionView?.frame.size.height)!)
        
        nextButton?.frame = CGRect(x: (scrollBgView?.frame.size.width)!-(nextButton?.frame.size.width)!, y: 0, width: (nextButton?.frame.size.width)!, height: 45)
        docketCollectionView?.delegate=self.docketPresenter
        docketCollectionView?.dataSource=self.docketPresenter

        var dockCount : Int?
        if sharedKitchen?.docketSize == 0 {
            dockCount = 5
        }else if sharedKitchen?.docketSize == 1{
            dockCount = 4
        }else{
            dockCount = 3
        }
        
        let indicatorWidth = dockCount! * 80
        lowerScrollIndicator = UIView(frame: CGRect(x: 15, y: 20, width: indicatorWidth, height: 5))
        lowerScrollIndicator?.backgroundColor = .blue
        lowerScrollIndicator?.layer.cornerRadius = 5
        lowerScrollIndicator?.layer.borderWidth=0.5
        lowerScrollIndicator?.layer.borderColor = UIColor.green.cgColor
        
        orderCollectionView?.addSubview(lowerScrollIndicator!)
        orderCollectionView?.delegate=self.docketPresenter
        orderCollectionView?.dataSource=self.docketPresenter
        
        docketCollectionView?.reloadData()
        orderCollectionView?.reloadData()
    }
    
    func updateCountLabels(){
        
        self.docketPresenter.updateCountLabels(orderLabel: totalOrdersLabel!, itemLabel: totalItemsLabel!)
    }
}
    
//MARK: View Update Delegates

extension OPKitchenDisplayViewController : ViewUpdateProtocol{
    
    func didCompleteDataSync(from presenter: KDSPresenter) {
        
        LoadingIndicatorView.removeLoadingIndicator(loadingIndicatorView)
        
        if presenter.isEqual(self.docketPresenter){
        
            StatusView.showLargeBottomPopup(withMessage: "Sample dockets loaded successfully!", timeToStay: 2, viewColor: nil, textColor: nil, on: self.view)
            self.docketCollectionView?.reloadData()
            self.orderCollectionView?.reloadData()
        }
    }
    
    func didUpdateModel() {
           
        self.docketCollectionView?.reloadData()
        self.orderCollectionView?.reloadData()
    }
    
    func playKitchenSound(withSoundName soundName: String) {
        
        self.playSound(soundName: soundName)
    }
}

//MARK: - Actions
extension OPKitchenDisplayViewController{
    
    @objc func showSummaryAction(sender:UIBarButtonItem){
        
        let summaryVc = KDSummaryViewController(style: UITableView.Style.grouped) 
        
        let navController = UINavigationController(rootViewController: summaryVc)
        navController.modalPresentationStyle = .popover
        navController.navigationBar.barStyle = .black
        
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
        navVc.navigationBar.barStyle = .black
        navVc.modalPresentationStyle=UIModalPresentationStyle.fullScreen
        self.present(navVc, animated: true, completion: nil)
    }
    
    @objc func logoutAction(){
        
        loggedInUser = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func analyticsAction(){
        
        let analysisVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AnalysisViewController")
       let navVc = UINavigationController(rootViewController: analysisVc)
       navVc.navigationBar.barStyle = .black
       navVc.modalPresentationStyle=UIModalPresentationStyle.fullScreen
       self.present(navVc, animated: true, completion: nil)
    }
    
    @objc func courseAction(sender:UIBarButtonItem){
        
        let summaryVc = KDCourseSummaryViewController()        
        let navController = UINavigationController(rootViewController: summaryVc)
        navController.modalPresentationStyle = .popover
        navController.navigationBar.barStyle = .black
       
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
    
    @objc func segmentedControlAction(sender:UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            
            self.docketPresenter.loadData(withOpenOrders: true)
        }else{
            self.docketPresenter.loadData(withOpenOrders: false)
        }
    }
    
    @objc func cancelBtnAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UIcollectionView Delegate
extension OPKitchenDisplayViewController:UICollectionViewDelegate{
    
    func didSelectItem(atIndexPath indexPath:IndexPath, inCollectionView:UICollectionView){
           
           if inCollectionView==orderCollectionView{
               
               orderCollectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
               docketCollectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
               
               DispatchQueue.main.async {
                   
                   self.indicateVisibleOrders()
               }
           }
       }
}

//MARK: Search
extension OPKitchenDisplayViewController:UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        resetCollectionViews()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        resetCollectionViews()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count>0{
            
            self.docketPresenter.loadData(withSearchTerm: searchText)
        }else{
            
           resetCollectionViews()
        }
    }
    
    func resetCollectionViews(){
        
        self.docketPresenter.loadData(withOpenOrders: true)
        docketSearchBar?.resignFirstResponder()
    }
}

//MARK: - Scrolling
extension OPKitchenDisplayViewController{
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            if scrollView == docketCollectionView{
                           
                DispatchQueue.main.async {
                    
                    self.indicateVisibleOrders()
                }
    //            self.performSelector(onMainThread: #selector(indicateVisibleOrders), with: nil, waitUntilDone: false)
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
            let pageWidth = Float((docketCollectionView?.frame.size.width)!)
            let noOfPages = Float(floor(Float(contentSize!.width)/pageWidth))
            
            if noOfPages > 1{
                
                let currentPage = Float(offset!.x) == 0 ? 0 : ceil((Float(offset!.x) / Float(contentSize!.width)) * noOfPages)
                
                let condition = isNext ? (currentPage < noOfPages) : (currentPage > 0)
                if condition{
                    
                    if isNext{
                        
                        let toPointX = CGFloat((currentPage*pageWidth)+pageWidth)
                        if Float(toPointX) < Float(contentSize!.width){
                         
                            docketCollectionView?.setContentOffset(CGPoint(x: toPointX, y: offset!.y), animated: true)
                        }
                    }else{
                        
                        let toPointX = CGFloat((currentPage*pageWidth)-pageWidth)
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
            let pageWidth = Float((docketCollectionView?.frame.size.width)!)
            let noOfPages = Float(floor(Float(contentSize!.width)/pageWidth))
            let currentPage = Float(offset!.x) == 0 ? 0 : ceil((Float(offset!.x) / Float(contentSize!.width)) * noOfPages)
            
            if noOfPages > 1{
                
                nextButton?.isEnabled = currentPage < noOfPages ? true : false
                prevButton?.isEnabled = currentPage > 0 ? true : false
            }else{
                
                nextButton?.isEnabled = false
                prevButton?.isEnabled = false
            }
            docketCollectionView?.flashScrollIndicators()
        }
        
}

//MARK: Utilities
extension OPKitchenDisplayViewController{
    
    @objc func playSound(soundName:String){
        
        let path = Bundle.main.path(forResource: soundName, ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
    }
}

